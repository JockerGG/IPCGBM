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
    
    /// Model to set the necessary information to the view.
    /// When the model is modified the view will render the changes.
    open var uiModel: T? {
        didSet {
            updateUI()
        }
    }
    
    /// Clousre to notify the view controller the interactios of the user with the view.
    /// This is an open var  and must be assigned to has functionality, 
    open var actionHandler: ActionHandler
    
    /// - Parameters:
    ///     - uiModel: The model that will update the view's information.
    ///     - actionHandler: The clousure implementation to notify the view controller the user's interactions.
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
    
    /// Add the necessary subviews to the main view.
    /// This is an open function and must be implemented to has functionality.
    open func addSubviews() { }
    
    /// Set the constraints of the subviews to the main view.
    /// This is an open function and must be implemented to has functionality.
    open func setConstraints() { }
    
    /// Update the view with the changes of the `uiModel`.
    /// This is an open function and must be implemented to has functionality.
    open func updateUI() { }
}
