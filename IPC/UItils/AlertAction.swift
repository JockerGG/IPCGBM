//
//  AlertAction.swift
//  IPC
//
//  Created by Eduardo García González on 13/03/23.
//

import Foundation
import UIKit

struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let action: (() -> Void)?
    
    func toAction(alertController: UIAlertController) -> UIAlertAction {
        UIAlertAction(title: title, style: style) { _ in
            alertController.dismiss(animated: true)
            action?()
        }
    }
}
