//
//  LARepository.swift
//  IPC
//
//  Created by Eduardo García González on 13/03/23.
//

import Foundation
import LocalAuthentication

protocol LocalAuthenticationRepositorable {
    func login(completion: @escaping ((Result<Bool, Error>) -> Void))
}

final class LARepository: LocalAuthenticationRepositorable {
    let context: LAContext
    var error: NSError?
    
    init(context: LAContext) {
        self.context = context
    }
    
    func login(completion: @escaping ((Result<Bool, Error>) -> Void)) {
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "authentication-login-subtitle".localized) { (success, error) in
            if let error = error {
                let localizedError = IPCError.evaluate(error: error)
                completion(.failure(localizedError))
                return
            }
            
            completion(.success(success))
        }
    }
}
