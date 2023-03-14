//
//  AppCoordinator.swift
//  IPC
//
//  Created by Eduardo García González on 13/03/23.
//

import UIKit
import LocalAuthentication

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let localContext: LAContext
    internal var child: [Coordinator] = []
    internal var router: Router
    internal weak var parentViewController: UIViewController?
    
    init(window: UIWindow,
         parentViewController: UIViewController,
         localContext: LAContext) {
        self.window = window
        self.parentViewController = parentViewController
        self.router = RouterImplementation()
        self.localContext = localContext
    }
    
    func start() {
        window.rootViewController = parentViewController
        let authCoordinator = AuthenticationCoordinator(parentViewController: parentViewController,
                                                        localContext: localContext)
        authCoordinator.start()
        window.makeKeyAndVisible()
    }
}
