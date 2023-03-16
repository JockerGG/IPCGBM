//
//  BaseViewController.swift
//  IPC
//
//  Created by Eduardo García González on 13/03/23.
//

import UIKit

protocol BaseViewController: AnyObject {
    /// Present an alert controller in the `viewController` where is invoked.
    /// - Parameters:
    ///     - title: The title of the alert controller.
    ///     - message: The message of the alert controller.
    ///     - actions: The actions that the alert controller could include,
    func showAlertController(title: String, message: String?, actions: [AlertAction])
    
    /// Show a basic view that indicates the `viewController` is loading.
    func showLoader()
    
    /// Remove the `LoaderView` from the current `viewController`
    func hideLoader()
}

extension BaseViewController where Self: UIViewController {
    func showAlertController(title: String, message: String?, actions: [AlertAction]) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let alertActions = actions.map { $0.toAction(alertController: alertController) }
        alertActions.forEach { alertController.addAction($0) }
        self.present(alertController, animated: true)
    }
    
    func showLoader() {
        guard !self.view.subviews.contains(where: { $0 is LoaderView }) else { return }
        let loaderView = LoaderView(actionHandler: { _ in })
        loaderView.prepareForAutolayout()
        loaderView.isHidden = true
        self.view.addSubview(loaderView)
        
        NSLayoutConstraint.activate([
            loaderView.topAnchor.constraint(equalTo: self.view.topAnchor),
            loaderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            loaderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            loaderView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        UIView.animate(withDuration: 0.2, delay: .zero, options: .transitionCrossDissolve) {
            loaderView.isHidden = false
            loaderView.startAnimation()
        }
    }
    
    func hideLoader() {
        guard let loaderView = self.view.subviews.first(where: { $0 is LoaderView }) as? LoaderView else { return }
        NSLayoutConstraint.deactivate(loaderView.constraints)
        
        UIView.animate(withDuration: 0.2, delay: .zero, options: .transitionCrossDissolve) {
            loaderView.startAnimation()
            loaderView.removeFromSuperview()
        }
    }
}
