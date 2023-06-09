//
//  ChartUIModelBuilder.swift
//  IPC
//
//  Created by Eduardo García González on 15/03/23.
//

import Foundation

struct ChartUIModelBuilder {
    func assemble(with data: [ChartUIData], simulationEnabled: Bool = false) -> ChartView.UIModel {
        return .init(data: data, simulationEnabled: simulationEnabled)
    }
}
