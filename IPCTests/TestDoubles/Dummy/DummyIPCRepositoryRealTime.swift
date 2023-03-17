//
//  DummyIPCRepositoryRealTime.swift
//  IPCTests
//
//  Created by Eduardo García González on 17/03/23.
//

import Foundation

@testable import IPC

final class DummyIPCRepositoryRealTime: IPCRealTimeRepositorable {
    // MARK: - Dummy: IPCRealTimeRepositorable
    var timer: Timer.Type {
        return TimerSpy.self
    }
    func simulate(with data: [ChartUIData], updater: (([ChartUIData]) -> Void)?, completion: @escaping ([ChartUIData]) -> Void) -> Timer {
        TimerSpy()
    }
}
