//
//  IPCData.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//
import Foundation

struct IPCData: Codable {
    let date: Date
    let price: CGFloat
    let percentageChange: CGFloat
    let change: CGFloat
    let volume: Double
}
