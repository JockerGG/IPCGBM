//
//  LARepositorySpy.swift
//  IPCTests
//
//  Created by Eduardo García González on 13/03/23.
//

@testable import IPC

final class LARepositorySpy: LARepositorable {
    // MARK: - Spy: LARepositorable
    var loginCalled: Bool { loginCallCount > 0 }
    var loginCallCount: Int = 0
    var loginParameters: (completion: ((Result<Bool, Error>) -> Void), Void)?
    var loginParameterList: [(completion: ((Result<Bool, Error>) -> Void), Void)] = []
    var loginCompletionInput: (Result<Bool, Error>)?
    
    func login(completion: @escaping ((Result<Bool, Error>) -> Void)) {
        loginCallCount += 1
        // `completion` transformed to be able to append to parameter list when function has generics
        let transformedCompletion = loginCompletionTransformer(completion)
        
        loginParameters = (transformedCompletion, ())
        loginParameterList.append((transformedCompletion, ()))
        if let input = loginCompletionInput {
            completion(input)
        }
    }

    // These transformers are required to support escaping closures within the parameter/list assignment when function has generics
    private func loginCompletionTransformer(
        _ handler: @escaping ((Result<Bool, Error>) -> Void)
    ) -> ((Result<Bool, Error>) -> Void) {
        return { _ in }
    }
}
