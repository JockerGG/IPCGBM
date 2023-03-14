//
//  IPCError.swift
//  IPC
//
//  Created by Eduardo García González on 13/03/23.
//

import Foundation
import LocalAuthentication

enum IPCError: Error, LocalizedError {
    case unknown
    case error(reason: String)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "generic-unknown-message".localized
        case .error(let reason):
            return reason
        }
    }
    
    static func evaluate(error: Error?) -> Error {
        if let error = error as? LAError {
            switch error.code {
            case .authenticationFailed:
                return IPCError.error(reason: "".localized)
            case .biometryLockout:
                return IPCError.error(reason: "".localized)
            default:
                return IPCError.unknown
            }
        }
        
        return IPCError.unknown
    }
}
