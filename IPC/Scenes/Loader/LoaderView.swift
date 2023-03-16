//
//  LoaderView.swift
//  IPC
//
//  Created by Eduardo García González on 15/03/23.
//

import Foundation
import UIKit

final class LoaderView: BaseView<LoaderView.UIModel, LoaderView.Action> {
    enum Action { }
    struct UIModel { }
    
    lazy var loaderIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.prepareForAutolayout()
        
        return view
    }()
    
    
    override func addSubviews() {
        addSubview(loaderIndicator)
    }
    
    override func setConstraints() {
        let loaderIndicatorConstraints = [
            loaderIndicator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            loaderIndicator.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(loaderIndicatorConstraints)
    }
    
    func startAnimation() {
        loaderIndicator.startAnimating()
    }
    
    func stopAnimation() {
        loaderIndicator.stopAnimating()
    }
    
}
