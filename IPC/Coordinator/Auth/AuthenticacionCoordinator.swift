//
//  AuthenticacionCoordinator.swift
//  IPC
//
//  Created by Eduardo García González on 12/03/23.
//

import Foundation
import LocalAuthentication
import UIKit

protocol AuthenticationCoordinationNavigationDelegate: AnyObject {
    func didAuthenticationSuccess(parentViewController: UIViewController)
}

final class AuthenticationCoordinator: Coordinator {
    internal var child: [Coordinator] = []
    internal var parentViewController: UIViewController?
    internal var router: Router
    private let localContext: LAContext
    private lazy var nextViewController: AuthenticationViewController = {
        let localValidationRepository = LAPermissionsValidatorRepository(context: localContext)
        let localAuthenticationRepository = LARepository(context: localContext)
        let nextController = AuthenticationViewController(viewModel: .init(
            localAuthenticationValidatorRepository: localValidationRepository,
            localAuthenticationRepository: localAuthenticationRepository,
            localContext: localContext)
        )
        
        nextController.navigationDelegate = self
        
        return nextController
    }()
    
    init(parentViewController: UIViewController?, localContext: LAContext, router: Router? = nil) {
        self.parentViewController = parentViewController
        self.localContext = localContext
        if let router {
            self.router = router
        } else {
            self.router = RouterImplementation(root: parentViewController)
        }
    }
    
    func start() {
        if let navigationController = parentViewController as? UINavigationController,
           navigationController.viewControllers.count == 0 {
            router.setRoot(nextViewController, animated: true)
            return
        }
        
        router.present(nextViewController, animated: true)
    }
}

extension AuthenticationCoordinator: AuthenticationCoordinationNavigationDelegate {
    public func didAuthenticationSuccess(parentViewController: UIViewController) {
        let nextCoordinator = ChartCoordinator(parentViewController: parentViewController)
        nextCoordinator.start()
    }
}
