//
//  IPCRepositoryRealTimeSpy.swift
//  IPCTests
//
//  Created by Eduardo García González on 17/03/23.
//

import Foundation

@testable import IPC

final class IPCRepositoryRealTimeSpy: IPCRealTimeRepositorable {
    // MARK: - Spy: IPCRealTimeRepositorable

    var timerGetterCalled: Bool { timerGetterCallCount > 0 }
    var timerGetterCallCount: Int = 0
    var stubbedTimerType: Timer.Type!
    var timer: Timer.Type {
        timerGetterCallCount += 1
        return stubbedTimerType
    }
    
    lazy var stubbedTimer: Timer = {
        stubbedTimerType.init()
    }()
    
    var simulateCalled: Bool { simulateCallCount > 0 }
    var simulateCallCount: Int = 0
    var simulateParameters: (data: [ChartUIData], updater: (([ChartUIData]) -> Void)?, completion: ([ChartUIData]) -> Void)?
    var simulateParameterList: [(data: [ChartUIData], updater: (([ChartUIData]) -> Void)?, completion: ([ChartUIData]) -> Void)] = []
    var simulateUpdaterInput: ([ChartUIData])?
    var simulateCompletionInput: ([ChartUIData])?

    func simulate(with data: [ChartUIData], updater: (([ChartUIData]) -> Void)?, completion: @escaping ([ChartUIData]) -> Void) -> Timer {
        simulateCallCount += 1
        simulateParameters = (data, updater, completion)
        simulateParameterList.append((data, updater, completion))
        if let input = simulateUpdaterInput {
            updater?(input)
        }
        if let input = simulateCompletionInput {
            completion(input)
        }
        return stubbedTimer
    }
}
