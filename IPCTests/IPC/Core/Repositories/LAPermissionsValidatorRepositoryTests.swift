//
//  LAPermissionsValidatorRepositoryTests.swift
//  IPCTests
//
//  Created by Eduardo García González on 13/03/23.
//

@testable import IPC
import XCTest

final class LAPermissionsValidatorRepositoryTests: XCTestCase {
    private var localContextStub: LAContextStub!
    private var localPermissionRepository: LAPermissionsValidatorRepository!
    
    override func setUp() {
        localContextStub = LAContextStub()
        localPermissionRepository = LAPermissionsValidatorRepository(context: localContextStub)
    }
    
    func test_local_authentication_failure_permission_not_granted() throws {
        // Given
        localContextStub.stubbedCanEvaluatePolicyResult = false
        localContextStub.stubbedPermissionsError = IPCError.unknown
        
        // When
        let result = localPermissionRepository.validate()
        
        // Validate
        guard case .configuration(let error) = result else {
            XCTFail("Something went wrong")
            return
        }
        let unwrappedError = try XCTUnwrap(error)
        XCTAssertEqual(unwrappedError.localizedDescription, IPCError.unknown.localizedDescription)
    }
    
    func test_local_authentication_failure_permission_granted() throws {
        // Given
        localContextStub.stubbedCanEvaluatePolicyResult = true
        
        // When
        let result = localPermissionRepository.validate()
        
        // Validate
        guard case .granted = result else {
            XCTFail("Something went wrong")
            return
        }
        
        XCTAssertTrue(true)
    }
}
