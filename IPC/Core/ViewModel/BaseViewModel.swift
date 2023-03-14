//
//  BaseViewModel.swift
//  IPC
//
//  Created by Eduardo García González on 13/03/23.
//

import Foundation

open class BaseViewModel<T> {
    open var notifier: ((T) -> Void)?
}
