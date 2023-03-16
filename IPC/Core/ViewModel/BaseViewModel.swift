//
//  BaseViewModel.swift
//  IPC
//
//  Created by Eduardo García González on 13/03/23.
//

import Foundation

open class BaseViewModel<T> {
    /// Clousure that notifies to the view about new changes. 
    open var notifier: ((T) -> Void)?
}
