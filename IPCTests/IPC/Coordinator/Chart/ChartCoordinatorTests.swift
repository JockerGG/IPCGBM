//
//  ChartCoordinatorTests.swift
//  IPCTests
//
//  Created by Eduardo García González on 15/03/23.
//

@testable import IPC
import XCTest
import UIKit

final class ChartCoordinatorTests: XCTestCase {
    private var routerSpy: RouterSpy!
    private let dummyLAContext: DummyLAContext = DummyLAContext()
    
    override func setUp() {
        routerSpy = RouterSpy()
    }
    
    func test_start() {
        // Given
        let sut = ChartCoordinator(parentViewController: UINavigationController(),
                                            router: routerSpy)
        
        // When
        sut.start()
        
        // Validate
        XCTAssertTrue(routerSpy.setRootCalled)
        XCTAssertTrue(routerSpy.setRootParameters?.viewController is ChartViewController)
    }
    
}
