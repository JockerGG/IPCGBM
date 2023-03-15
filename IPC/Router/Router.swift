//
//  Router.swift
//  IPC
//
//  Created by Eduardo García González on 12/03/23.
//

import UIKit

protocol Router: AnyObject {
    var root: UIViewController? { get set }
    func present(_ viewController: UIViewController, animated: Bool)
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func setRoot(_ viewController: UIViewController, animated: Bool)
    func popToRootViewController(animated: Bool, completion: (() -> Void)?)
}

final class RouterImplementation: Router {
    var root: UIViewController?
    
    init(root: UIViewController? = nil) {
        self.root = root
    }
    
    func present(_ viewController: UIViewController, animated: Bool) {
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.present(navigationController, animated: animated)
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
