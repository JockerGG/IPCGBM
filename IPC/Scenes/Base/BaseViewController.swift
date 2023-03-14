//
//  BaseViewController.swift
//  IPC
//
//  Created by Eduardo García González on 13/03/23.
//

import UIKit

protocol BaseViewController: AnyObject {
    func showAlertController(title: String, message: String?, actions: [AlertAction])
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
}
