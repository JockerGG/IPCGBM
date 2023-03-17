//
//  DummyIPCRepository.swift
//  IPCTests
//
//  Created by Eduardo García González on 17/03/23.
//

import Foundation
@testable import IPC

final class DummyIPCRepository: IPCRepositorable {
    // MARK: - Dummy: IPCRepositorable
    func getIPCData(completion: @escaping ((Result<[IPCData], Error>) -> Void)) {
        // no-op
    }
}
