//
//  URLSessionProtocolSpy.swift
//  IPCTests
//
//  Created by Eduardo García González on 14/03/23.
//

import Foundation

@testable import IPC

final class URLSessionProtocolSpy: URLSessionProtocol {
    // MARK: - Spy: URLSessionProtocol
    var performTaskCalled: Bool { performTaskCallCount > 0 }
    var performTaskCallCount: Int = 0
    var performTaskParameters: (request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> Void)?
    var performTaskParameterList: [(request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> Void)] = []
    var performTaskResult: URLSessionDataTaskProtocol!
    var performTaskCompletionHandlerInput: (Data?, URLResponse?, Error?)?

    func performTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        performTaskCallCount += 1
        // `completionHandler` transformed to be able to append to parameter list when function has generics
        let transformedCompletionHandler = performTaskCompletionHandlerTransformer(completionHandler)
        performTaskParameters = (request, transformedCompletionHandler)
        performTaskParameterList.append((request, transformedCompletionHandler))
        if let input = performTaskCompletionHandlerInput {
            completionHandler(input.0, input.1, input.2)
        }
        return performTaskResult
    }

    // These transformers are required to support escaping closures within the parameter/list assignment when function has generics
    private func performTaskCompletionHandlerTransformer(
        _ handler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> (Data?, URLResponse?, Error?) -> Void {
        return { input0, input1, input2 in
            return
        }
    }
}
