//
//  TimerSpy.swift
//  IPCTests
//
//  Created by Eduardo García González on 17/03/23.
//

import Foundation

final class TimerSpy: Timer {
    var invalidateCalledCount: Int = 0
    var invalidateCalled: Bool { invalidateCalledCount > 0 }
    var shceduledTimerCalledCount: Int = 0
    var scheduledTimerCalled: Bool { shceduledTimerCalledCount > 0 }
    
    override class func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        let timer = TimerSpy()
        timer.shceduledTimerCalledCount += 1
        
        return timer
    }
    
    override func invalidate() {
        invalidateCalledCount += 1
    }
}
