//
//  LARepositoryTests.swift
//  IPCTests
//
//  Created by Eduardo García González on 13/03/23.
//

@testable import IPC
import XCTest

final class LARepositoryTests: XCTestCase {
    var localContextStub: LAContextStub!
    var localAuthenticationRepository: LARepository!
    
    override func setUp() {
        localContextStub = LAContextStub()
        localAuthenticationRepository = LARepository(context: localContextStub)
    }
    
    func test_local_authentication_failure() {
        localContextStub.stubbedCanEvaluatePolicyResult = true
        localContextStub.stubbedEvaluatePolicyResult = (false, IPCError.unknown)
        localAuthenticationRepository.login { result in
            guard case .failure(let error) = result else {
                XCTFail("Something went wrong")
                return
            }
            
            XCTAssertEqual(error.localizedDescription, IPCError.unknown.localizedDescription)
        }
    }
    
    func test_local_authentication_success() {
        localContextStub.stubbedCanEvaluatePolicyResult = true
        localContextStub.stubbedEvaluatePolicyResult = (true, nil)
        localAuthenticationRepository.login { result in
            guard case .success(let success) = result else {
                XCTFail("Something went wrong")
                return
            }
            
            XCTAssertTrue(success)
        }
    }

}
