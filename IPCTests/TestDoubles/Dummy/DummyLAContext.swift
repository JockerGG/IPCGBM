//
//  DummyLAContext.swift
//  IPCTests
//
//  Created by Eduardo García González on 15/03/23.
//

import Foundation
import LocalAuthentication

final class DummyLAContext: LAContext {
    override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) { }
    override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool { return false }
}
