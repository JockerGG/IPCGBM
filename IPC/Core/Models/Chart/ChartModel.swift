//
//  ChartModel.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//
import Foundation

struct ChartModel: Codable {
    let date: Date
    let price: CGFloat
    let percentageChange: CGFloat
    
    var ipc: CGFloat {
        price - (price * percentageChange)
    }
}
