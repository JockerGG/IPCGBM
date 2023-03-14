//
//  LAPermissionsValidatoryRepositorySpy.swift
//  IPCTests
//
//  Created by Eduardo García González on 13/03/23.
//

import XCTest

@testable import IPC
import LocalAuthentication

final class LAPermissionsValidatoryRepositorySpy: LAPermissionsValidatorRepositorable {
    // MARK: - Spy: LAPermissionsValidatorRepositorable
    var contextGetterCalled: Bool { contextGetterCallCount > 0 }
    var contextGetterCallCount: Int = 0
    var stubbedContext: LAContext!

    var context: LAContext {
        contextGetterCallCount += 1
        return stubbedContext
    }
    var validateCalled: Bool { validateCallCount > 0 }
    var validateCallCount: Int = 0
    var validateResult: LAPermissionsValidatorStep!

    func validate() -> LAPermissionsValidatorStep {
        validateCallCount += 1
        return validateResult
    }
}
