//
//  AuthenticacionCoordinator.swift
//  IPC
//
//  Created by Eduardo García González on 12/03/23.
//

import Foundation
import LocalAuthentication
import UIKit

final class AuthenticationCoordinator: Coordinator {
    internal var child: [Coordinator] = []
    internal weak var parentViewController: UIViewController?
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
        
        return nextController
    }()
    
    init(parentViewController: UIViewController?, localContext: LAContext) {
        self.parentViewController = parentViewController
        self.router = RouterImplementation(root: parentViewController)
        self.localContext = localContext
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
