//
//  BaseView.swift
//  IPC
//
//  Created by Eduardo García González on 12/03/23.
//

import Foundation
import UIKit

open class BaseView<T, U>: UIView {
    public typealias ActionHandler = ((U) -> Void)?
    open var uiModel: T? {
        didSet {
            updateUI()
        }
    }
    open var actionHandler: ActionHandler
    
    public init(uiModel: T? = nil, actionHandler: ActionHandler) {
        self.uiModel = uiModel
        self.actionHandler = actionHandler
        super.init(frame: .zero)
        
        addSubviews()
        setConstraints()
        updateUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func addSubviews() { }
    open func setConstraints() { }
    open func updateUI() { }
}
