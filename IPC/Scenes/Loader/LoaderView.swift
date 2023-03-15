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
        let view = UIActivityIndicatorView(style: .medium)
        view.prepareForAutolayout()
        
        return view
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.prepareForAutolayout()
        
        return view
    }()
    
    
    override func addSubviews() {
        addSubview(blurView)
        addSubview(loaderIndicator)
    }
    
    override func setConstraints() {
        let blurViewConstraints = [
            blurView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: blurView.leadingAnchor),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: blurView.bottomAnchor)
        ]
        
        let loaderIndicatorConstraints = [
            loaderIndicator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            loaderIndicator.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(blurViewConstraints + loaderIndicatorConstraints)
    }
    
    func startAnimation() {
        loaderIndicator.startAnimating()
    }
    
    func stopAnimation() {
        loaderIndicator.stopAnimating()
    }
    
}
