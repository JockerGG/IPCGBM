//
//  DummyURLSessionDataTask.swift
//  IPCTests
//
//  Created by Eduardo García González on 14/03/23.
//

import Foundation

@testable import IPC

final class DummyURLSessionDataTask: URLSessionDataTaskProtocol {
    // MARK: - Dummy: URLSessionDataTaskProtocol
    func resume() {
        // no-op
    }

    func cancel() {
        // no-op
    }
}
