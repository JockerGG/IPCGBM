//
//  LARepository.swift
//  IPC
//
//  Created by Eduardo García González on 13/03/23.
//

import Foundation
import LocalAuthentication

protocol LARepositorable {
    /// Login user with biometric authentication.
    func login(completion: @escaping ((Result<Bool, Error>) -> Void))
}

/// Implementation of `LARepositorable`
final class LARepository: LARepositorable {
    /// Local authentication context.
    let context: LAContext
    
    /// - Paramenters:
    ///     - context: The local authentication context.
    init(context: LAContext) {
        self.context = context
    }
    
    /// Login user with biometric authentication.
    func login(completion: @escaping ((Result<Bool, Error>) -> Void)) {
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "authentication-login-reason".localized) { (success, error) in
            if let error = error {
                let localizedError = IPCError.evaluate(error: error)
                completion(.failure(localizedError))
                return
            }
            
            completion(.success(success))
        }
    }
}
