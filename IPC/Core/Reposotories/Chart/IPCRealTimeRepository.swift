//
//  IPCRealTimeRepository.swift
//  IPC
//
//  Created by Eduardo García González on 15/03/23.
//

import Foundation

protocol IPCRealTimeRepositorable {
    func simulate(with data: [ChartUIData],
                  updater: (([ChartUIData]) -> Void)?,
                  completion: @escaping ([ChartUIData]) -> Void) -> Timer
}

final class IPCRealTimeRepository: IPCRealTimeRepositorable {
    
    func simulate(with data: [ChartUIData],
                  updater: (([ChartUIData]) -> Void)?,
                  completion: @escaping ([ChartUIData]) -> Void) -> Timer {
        var count: Int = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            guard count < data.count else {
                timer.invalidate()
                completion(data)
                return
            }
            updater?(Array(data[0..<count]))
            count+=1
        }
        
        RunLoop.current.add(timer, forMode: .common)
        
        return timer
    }
}
