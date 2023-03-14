//
//  AuthenticationViewSnapshotTests.swift
//  IPCTests
//
//  Created by Eduardo García González on 13/03/23.
//

@testable import IPC
import XCTest
import SnapshotTesting

final class AuthenticationViewSnapshotTests: XCTestCase {
    let isRecording = false
    
    func test_authentication_view_touch_id_render() {
        // Given
        let sut = AuthenticationView(uiModel: .init(biometricType: .touchID), actionHandler: nil)
        
        // When
        let vc = UIViewController()
        vc.view = sut
        vc.loadViewIfNeeded()
        
        // Validate
        assertSnapshot(matching: vc, as: .image(on: .iPhoneSe), record: isRecording)
    }
}
