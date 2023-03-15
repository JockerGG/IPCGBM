//
//  ChartUIModelBuilder.swift
//  IPC
//
//  Created by Eduardo García González on 15/03/23.
//

import Foundation

struct ChartUIModelBuilder {
    func assemble(with data: [ChartModel]) -> ChartView.UIModel {
        let dateFormatter = DateFormatter.formatter(with: DateFormatter.Formats.simple.rawValue)
        let chartData = data.map { value in
            return ChartData(y: value.ipc, x: dateFormatter.string(from: value.date))
        }
        return .init(data: chartData)
    }
}
