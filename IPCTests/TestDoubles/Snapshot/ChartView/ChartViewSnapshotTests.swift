//
//  ChartViewSnapshotTests.swift
//  IPCTests
//
//  Created by Eduardo García González on 14/03/23.
//

@testable import IPC
import XCTest
import SnapshotTesting

final class ChartViewSnapshotTests: XCTestCase {
    let isRecording = false
    
    func test_chart_view_render() {
        // Given
        let sut = ChartView(uiModel: .init(data: ChartDataMother.chartData, simulationEnabled: false), actionHandler: nil)
        
        // When
        let vc = UIViewController()
        vc.view = sut
        vc.loadViewIfNeeded()
        
        // Validate
        assertSnapshot(matching: vc, as: .image(on: .iPhoneSe), record: isRecording)
    }
}

