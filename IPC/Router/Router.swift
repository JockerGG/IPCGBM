//
//  Router.swift
//  IPC
//
//  Created by Eduardo García González on 12/03/23.
//

import UIKit

protocol Router: AnyObject {
    /// Parent controller to perform the navigation
    var root: UIViewController? { get set }
    
    /// Present the `viewController`
    func present(_ viewController: UIViewController, animated: Bool)
    
    /// Push the `viewController`
    func push(_ viewController: UIViewController, animated: Bool)
    
    /// Pop the presented controller in the `UIViewController` stack.
    func pop(animated: Bool, completion: (() -> Void)?)
    
    /// Dismiss the current `viewController`
    func dismiss(animated: Bool, completion: (() -> Void)?)
    
    /// Set the `viewController` as the root.
    func setRoot(_ viewController: UIViewController, animated: Bool)
    
    /// Pop all controllers to the root of the `UINavigationController`
    func popToRootViewController(animated: Bool, completion: (() -> Void)?)
}

/// Implementation of  `Router`
final class RouterImplementation: Router {
    var root: UIViewController?
    
    /// - Parameters:
    ///     - root: The controller that handle the navigation.
    init(root: UIViewController? = nil) {
        self.root = root
    }
    
    func present(_ viewController: UIViewController, animated: Bool) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = viewController.modalPresentationStyle
        root?.present(navigationController, animated: animated)
    }
    
    func push(_ viewController: UIViewController, animated: Bool) {
        guard let rootNavigationController = root as? UINavigationController else { return }
        rootNavigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool, completion: (() -> Void)?) {
        guard let rootNavigationController = root as? UINavigationController else { return }
        rootNavigationController.popViewController(animated: animated)
        completion?()
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        root?.dismiss(animated: animated, completion: completion)
    }
    
    func setRoot(_ viewController: UIViewController, animated: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }
        
        if !(viewController is UINavigationController) {
            let navigationController = UINavigationController(rootViewController: viewController)
            sceneDelegate.window?.rootViewController = navigationController
            return
        }
        
        sceneDelegate.window?.rootViewController = viewController
    }
    
    func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        guard let rootNavigationController = root as? UINavigationController else { return }
        rootNavigationController.popToRootViewController(animated: animated)
        completion?()
    }
}
