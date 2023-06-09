//
//  ChartViewController.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//

import Foundation
import UIKit

final class ChartViewController: UIViewController, BaseViewController {
    private let viewModel: ChartViewModel
    private let uiModelBuilder: ChartUIModelBuilder
    
    lazy var formView: ChartView = {
        let chartView = ChartView(uiModel: .init(data: [], simulationEnabled: false), actionHandler: { [weak self] action in
            self?.handle(action)
        })
        
        return chartView
    }()
    
    init(viewModel: ChartViewModel, uiModelBuilder: ChartUIModelBuilder = ChartUIModelBuilder()) {
        self.viewModel = viewModel
        self.uiModelBuilder = uiModelBuilder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "chart-view-title".localized
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        viewModel.notifier = { [weak self] notification in
            self?.updateUI(with: notification)
        }
        
        self.showLoader()
        viewModel.loadData()
    }
    
    override func loadView() {
        super.loadView()
        self.view = formView
    }
    
    private func updateUI(with notification: ChartViewModel.NotifierActions) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            switch notification {
            case .didUpdate(let data):
                self.formView.uiModel = self.uiModelBuilder.assemble(with: data)
                self.hideLoader()
            case .didUpdateFromSimulation(let data, let complete):
                self.formView.uiModel = self.uiModelBuilder.assemble(with: data, simulationEnabled: !complete)
            case .showAlert(let title, let message, let actions):
                self.showAlertController(title: title, message: message, actions: actions)
            }
        }
    }
    
    private func handle(_ action: ChartView.Actions) {
        switch action {
        case .valueChanged(let enableSimulation):
            enableSimulation ? viewModel.simulateRealTime() : viewModel.stopRealTimeSimulation()
        }
    }
}
