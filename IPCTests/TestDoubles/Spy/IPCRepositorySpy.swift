//
//  IPCRepositorySpy.swift
//  IPCTests
//
//  Created by Eduardo García González on 17/03/23.
//

import Foundation

@testable import IPC

final class IPCRepositorySpy: IPCRepositorable {
    // MARK: - Spy: IPCRepositorable
    var getIPCDataCalled: Bool { getIPCDataCallCount > 0 }
    var getIPCDataCallCount: Int = 0
    var getIPCDataParameters: (completion: ((Result<[IPCData], Error>) -> Void), Void)?
    var getIPCDataParameterList: [(completion: ((Result<[IPCData], Error>) -> Void), Void)] = []
    var getIPCDataCompletionInput: Result<[IPCData], Error>!

    func getIPCData(completion: @escaping ((Result<[IPCData], Error>) -> Void)) {
        getIPCDataCallCount += 1
        // `completion` transformed to be able to append to parameter list when function has generics
        getIPCDataParameters = (completion, ())
        getIPCDataParameterList.append((completion, ()))
        completion(getIPCDataCompletionInput)
    }
}
