//
//  BaseViewController.swift
//  IPC
//
//  Created by Eduardo García González on 13/03/23.
//

import UIKit

protocol BaseViewController: AnyObject {
    func showAlertController(title: String, message: String?, actions: [AlertAction])
    func showLoader()
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
        UIView.animate(withDuration: 0.2, delay: .zero, options: .transitionCrossDissolve) { [weak self] in
            self?.view.addSubview(loaderView)
            loaderView.startAnimation()
        }
    }
    
    func hideLoader() {
        guard let loaderView = self.view.subviews.first(where: { $0 is LoaderView }) as? LoaderView else { return }
        UIView.animate(withDuration: 0.2, delay: .zero, options: .transitionCrossDissolve) {
            loaderView.startAnimation()
            loaderView.removeFromSuperview()
        }
    }
}
