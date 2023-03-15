//
//  AuthenticationCoordinatorTests.swift
//  IPCTests
//
//  Created by Eduardo García González on 15/03/23.
//

@testable import IPC
import XCTest

final class AuthenticationCoordinatorTests: XCTestCase {
    private var routerSpy: RouterSpy!
    private let dummyLAContext: DummyLAContext = DummyLAContext()
    
    override func setUp() {
        routerSpy = RouterSpy()
    }
    
    func test_start() {
        // Given
        let sut = AuthenticationCoordinator(parentViewController: UINavigationController(),
                                            localContext: dummyLAContext,
                                            router: routerSpy)
        
        // When
        sut.start()
        
        // Validate
        XCTAssertTrue(routerSpy.setRootCalled)
        XCTAssertTrue(routerSpy.setRootParameters?.viewController is AuthenticationViewController)
    }
    
}
