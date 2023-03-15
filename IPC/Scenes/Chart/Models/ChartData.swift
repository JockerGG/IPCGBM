//
//  ChartData.swift
//  IPC
//
//  Created by Eduardo García González on 14/03/23.
//

import Foundation
import SwiftUI

final class ChartData: ObservableObject, Identifiable {
    var id = UUID()
    @Published var y: CGFloat = 0.0
    @Published var x: String = ""
    
    init(y: CGFloat, x: String) {
        self.x = x
        self.y = y
    }
}
