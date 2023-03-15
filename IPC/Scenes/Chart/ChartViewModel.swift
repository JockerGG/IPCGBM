//
//  ChartViewModel.swift
//  IPC
//
//  Created by Eduardo García González on 15/03/23.
//

import Foundation

final class ChartViewModel: BaseViewModel<ChartViewModel.NotifierActions> {
    enum NotifierActions {
        case didUpdate(data: [ChartData])
        case showAlert(title: String, message: String, actions: [AlertAction])
    }
    
    private let ipcRepository: IPCRepositorable
    private var data: [ChartData] = []
    
    init(ipcRepository: IPCRepositorable) {
        self.ipcRepository = ipcRepository
        super.init()
    }
    
    func loadData() {
        ipcRepository.getIPCData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let dateFormatter: DateFormatter = DateFormatter.formatter(with: DateFormatter.Formats.simple.rawValue)
                let data: [ChartData] = data.map { .init(y: $0.price, x: dateFormatter.string(from: $0.date)) }
                self.notifier?(.didUpdate(data: data))
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
}
