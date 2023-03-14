//
//  AuthenticationViewModelBehaviorTests.swift
//  IPCTests
//
//  Created by Eduardo García González on 13/03/23.
//

@testable import IPC
import LocalAuthentication
import XCTest

final class AuthenticationViewModelBehaviorTests: XCTestCase {
    private var localRepositorySpy: LARepositorySpy!
    private var localPermissionsValidatorRepositorySpy: LAPermissionsValidatoryRepositorySpy!
    private var stubbedLocalContext: LAContextStub!

    override func setUp() {
        localRepositorySpy = LARepositorySpy()
        localPermissionsValidatorRepositorySpy = LAPermissionsValidatoryRepositorySpy()
        stubbedLocalContext = LAContextStub()
    }
    
    func test_login_success() throws {
        // Given
        let expectation = XCTestExpectation(description: #function)
        stubbedLocalContext.stubbedCanEvaluatePolicyResult = true
        stubbedLocalContext.stubbedEvaluatePolicyResult = (true, nil)
        localPermissionsValidatorRepositorySpy.stubbedContext = stubbedLocalContext
        localPermissionsValidatorRepositorySpy.validateResult = .granted
        localRepositorySpy.loginCompletionInput = .success(true)
        let sut = AuthenticationViewModel(localAuthenticationValidatorRepository: localPermissionsValidatorRepositorySpy,
                                          localAuthenticationRepository: localRepositorySpy,
                                          localContext: stubbedLocalContext)
        
        sut.notifier = { [weak self] action in
            guard case .didLoginSuccess = action,
                let self = self else {
                XCTFail("Something went wrong")
                return
            }
            
            // Validate
            XCTAssertTrue(self.localPermissionsValidatorRepositorySpy.validateCalled)
            XCTAssertTrue(self.localRepositorySpy.loginCalled)
            expectation.fulfill()
        }
        
        // When
        sut.didTapLogin()
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_login_failure() {
        let expectation = XCTestExpectation(description: #function)
        stubbedLocalContext.stubbedCanEvaluatePolicyResult = true
        stubbedLocalContext.stubbedEvaluatePolicyResult = (false, IPCError.error(reason: "stubbed error"))
        localPermissionsValidatorRepositorySpy.stubbedContext = stubbedLocalContext
        localPermissionsValidatorRepositorySpy.validateResult = .granted
        localRepositorySpy.loginCompletionInput = .failure(IPCError.error(reason: "stubbed error"))
        let sut = AuthenticationViewModel(localAuthenticationValidatorRepository: localPermissionsValidatorRepositorySpy,
                                          localAuthenticationRepository: localRepositorySpy,
                                          localContext: stubbedLocalContext)
        
        sut.notifier = { [weak self] action in
            guard case .didShowAlert(let title, let message, let actions) = action,
                let self = self else {
                XCTFail("Something went wrong")
                return
            }
            
            // Validate
            XCTAssertTrue(self.localPermissionsValidatorRepositorySpy.validateCalled)
            XCTAssertTrue(self.localRepositorySpy.loginCalled)
            XCTAssertEqual(title, "authentication-login-error-title".localized)
            XCTAssertEqual(message, "stubbed error")
            XCTAssertEqual(actions.count, 1)
            expectation.fulfill()
        }
        
        // When
        sut.didTapLogin()
        wait(for: [expectation], timeout: 0.1)
    }
    
}
