//
//  ChartViewModel.swift
//  IPC
//
//  Created by Eduardo García González on 15/03/23.
//

import Foundation

final class ChartViewModel: BaseViewModel<ChartViewModel.NotifierActions> {
    enum NotifierActions {
        case didUpdate(data: [ChartUIData])
        case didUpdateFromSimulation(data: [ChartUIData], complete: Bool)
        case showAlert(title: String, message: String, actions: [AlertAction])
    }
    
    private let ipcRepository: IPCRepositorable
    private let ipcRealTimeRepository: IPCRealTimeRepositorable
    private var data: [ChartUIData] = []
    private var timer: Timer?
    
    init(ipcRepository: IPCRepositorable,
         ipcRealTimeRepository: IPCRealTimeRepositorable) {
        self.ipcRepository = ipcRepository
        self.ipcRealTimeRepository = ipcRealTimeRepository
        super.init()
    }
    
    func loadData() {
        ipcRepository.getIPCData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let dateFormatter: DateFormatter = DateFormatter.formatter(with: DateFormatter.Formats.simple.rawValue)
                self.data = data.map { .init(y: $0.price, x: dateFormatter.string(from: $0.date)) }
                self.notifier?(.didUpdate(data: self.data))
            case .failure(let error):
                self.notifier?(.showAlert(title: "chart-data-error".localized,
                                          message: error.localizedDescription,
                                          actions: [
                                            .init(title: "authentication-login-error-retry".localized,
                                                  style: .default,
                                                  action: {
                                                      self.loadData()
                                                  })
                                          ]))
            }
        }
    }
    
    func simulateRealTime() {
        self.timer = ipcRealTimeRepository.simulate(with: data) { [weak self] data in
            self?.notifier?(.didUpdateFromSimulation(data: data, complete: false))
        } completion: { [weak self] data in
            self?.notifier?(.didUpdateFromSimulation(data: data, complete: true))
        }
    }
    
    func stopRealTimeSimulation() {
        self.timer?.invalidate()
        self.timer = nil
        self.notifier?(.didUpdate(data: data))
    }
}
