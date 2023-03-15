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
    private var shouldBeRoot: Bool = true
    private lazy var nextViewController: AuthenticationViewController = {
        let localValidationRepository = LAPermissionsValidatorRepository(context: localContext)
        let localAuthenticationRepository = LARepository(context: localContext)
        let nextController = AuthenticationViewController(viewModel: .init(
            localAuthenticationValidatorRepository: localValidationRepository,
            localAuthenticationRepository: localAuthenticationRepository,
            localContext: localContext),
            navigationDelegate: self
        )
        
        nextController.modalPresentationStyle = .fullScreen
        
        return nextController
    }()
    
    init(parentViewController: UIViewController?, localContext: LAContext, router: Router? = nil, shouldBeRoot: Bool) {
        self.parentViewController = parentViewController
        self.shouldBeRoot = shouldBeRoot
        self.localContext = localContext
        if let router {
            self.router = router
        } else {
            self.router = RouterImplementation(root: parentViewController)
        }
    }
    
    func start() {
        shouldBeRoot ? router.setRoot(nextViewController, animated: true) : router.present(nextViewController, animated: true)
    }
}

extension AuthenticationCoordinator: AuthenticationCoordinationNavigationDelegate {
    public func didAuthenticationSuccess(parentViewController: UIViewController) {
        guard shouldBeRoot else {
            router.dismiss(animated: true, completion: nil)
            return
        }
        
        let nextCoordinator = ChartCoordinator(parentViewController: parentViewController)
        nextCoordinator.start()
    }
}
