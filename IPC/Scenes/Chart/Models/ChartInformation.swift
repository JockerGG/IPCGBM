//
//  ChartInformation.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//

import Foundation
import SwiftUI

final class ChartInformation: ObservableObject {
    @Published var values: [ChartData] = []
    
    init(values: [ChartData]) {
        self.values = values
    }
}
