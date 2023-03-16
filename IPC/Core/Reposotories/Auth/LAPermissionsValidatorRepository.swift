//
//  LAPermissionsValidatorRepository.swift
//  IPC
//
//  Created by Eduardo García González on 13/03/23.
//

import Foundation
import LocalAuthentication

enum LAPermissionsValidatorStep {
    case granted
    case configuration(error: Error?)
}

protocol LAPermissionsValidatorRepositorable {
    var context: LAContext { get }
    func validate() -> LAPermissionsValidatorStep
}

/// Validates if the user has granted permission to use biometric authentication.
final class LAPermissionsValidatorRepository: LAPermissionsValidatorRepositorable {
    ///  Local authentication context. 
    internal var context: LAContext
    
    /// Error in the case the validation fails.
    private var error: NSError?
    
    /// - Parameters:
    ///     - context: Local authentication context.
    init(context: LAContext) {
        self.context = context
    }
    
    /// Verify if the user has granted permissions to perform the authentication. 
    func validate() -> LAPermissionsValidatorStep {
        /// Check for permissions
        let permissions = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        return permissions ? .granted : .configuration(error: error)
    }
}
