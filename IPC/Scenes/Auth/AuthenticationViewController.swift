//
//  ViewController.swift
//  IPC
//
//  Created by Eduardo García González on 12/03/23.
//

import UIKit


final class AuthenticationViewController: UIViewController, BaseViewController {
    private let viewModel: AuthenticationViewModel
    private let uiModelBuilder: AuthenticationUIModelBuilder
    private weak var navigationDelegate: AuthenticationCoordinationNavigationDelegate?
    
    private lazy var formView: AuthenticationView = {
        let view = AuthenticationView(uiModel: .init(biometricType: .touchID),
                                      actionHandler: { [weak self] action in
            self?.handle(action)
        })
        
        return view
    }()
    
    init(viewModel: AuthenticationViewModel,
         uiModelBuilder: AuthenticationUIModelBuilder = AuthenticationUIModelBuilder(),
         navigationDelegate: AuthenticationCoordinationNavigationDelegate?) {
        self.viewModel = viewModel
        self.uiModelBuilder = uiModelBuilder
        self.navigationDelegate = navigationDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.notifier = { [weak self] notification in
            self?.updateUI(with: notification)
        }
        
        viewModel.validateBiometric()
    }
    
    override func loadView() {
        super.loadView()
        self.view = formView
    }
    
    private func updateUI(with notification: AuthenticationViewModel.NotifierActions) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch notification {
            case .update(let biometricType):
                self.formView.uiModel = self.uiModelBuilder.assemble(with: biometricType)
            case .didLoginSuccess:
                self.navigationDelegate?.didAuthenticationSuccess(parentViewController: self)
            case .didShowAlert(let title, let message, let actions):
                self.showAlertController(title: title, message: message, actions: actions)
            }
        }
    }
    
    private func handle(_ action: AuthenticationView.Actions) {
        switch action {
        case .didTapLoginButton:
            viewModel.didTapLogin()
        }
    }
}

