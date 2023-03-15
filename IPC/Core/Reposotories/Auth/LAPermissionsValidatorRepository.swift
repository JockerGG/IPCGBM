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

final class LAPermissionsValidatorRepository: LAPermissionsValidatorRepositorable {
    internal var context: LAContext
    private var error: NSError?
    
    init(context: LAContext) {
        self.context = context
    }
    
    func validate() -> LAPermissionsValidatorStep {
        /// Check for permissions
        let permissions = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        return permissions ? .granted : .configuration(error: error)
    }
}
