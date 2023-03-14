//
//  Unwrapper.swift
//  IPC
//
//  Created by Eduardo García González on 13/03/23.
//

import Foundation

enum Unwrapper {
    static func unwrap(_ string: String?) -> String {
        guard let string else {
            return ""
        }
        
        return string
    }
    
    static func unwrap<T>(_ value: T?, defaultValue: T) -> T {
        guard let value else {
            return defaultValue
        }
        
        return value
    }
}
