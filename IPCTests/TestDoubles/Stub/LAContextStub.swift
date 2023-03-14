//
//  LAContextStub.swift
//  IPCTests
//
//  Created by Eduardo García González on 13/03/23.
//

import Foundation
import LocalAuthentication

final class LAContextStub: LAContext {
    var stubbedEvaluatePolicyResult: (Bool, Error?) = (true, nil)
    var stubbedCanEvaluatePolicyResult: Bool = false
    var stubbedPermissionsError: Error?
    var stubbedBiometryType: LABiometryType = .faceID
    
    override var biometryType: LABiometryType {
        stubbedBiometryType
    }
    
    override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
        reply(stubbedEvaluatePolicyResult.0, stubbedEvaluatePolicyResult.1)
    }
    
    override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        error?.pointee = stubbedPermissionsError as? NSError
        return stubbedCanEvaluatePolicyResult
    }
}
