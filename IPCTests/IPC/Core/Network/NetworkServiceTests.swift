//
//  NetworkServiceTests.swift
//  IPCTests
//
//  Created by Eduardo García González on 14/03/23.
//

@testable import IPC
import XCTest

final class NetworkServiceTests: XCTestCase {
    private var urlSessionSpy: URLSessionProtocolSpy!
    private var networkService: NetworkServiceImplementation!
    
    override func setUp() {
        urlSessionSpy = URLSessionProtocolSpy()
        networkService = NetworkServiceImplementation(session: urlSessionSpy)
    }
    
    func test_success_response() throws {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let mockData = try XCTUnwrap(FileManager.getFileData(with: "ipcResponse", type: "json"))
        let url = try XCTUnwrap(URL(string: IPCRequest().url))
        let mockHttpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        
        urlSessionSpy.performTaskCompletionHandlerInput = (mockData, mockHttpResponse, nil)
        urlSessionSpy.performTaskResult = DummyURLSessionDataTask()
        // When
        networkService.request(IPCRequest()) { [weak self] result in
            guard let self = self,
                    case .success(let values) = result else {
                XCTFail("Something went wrong")
                return
            }
            
            XCTAssertTrue(self.urlSessionSpy.performTaskCalled)
            XCTAssertEqual(values.count, 4)
            expectation.fulfill()
        }
    }
    
    func test_failure_response_400_error() throws {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let url = try XCTUnwrap(URL(string: IPCRequest().url))
        let mockHttpResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: "", headerFields: [:])
        
        urlSessionSpy.performTaskCompletionHandlerInput = (nil, mockHttpResponse, nil)
        urlSessionSpy.performTaskResult = DummyURLSessionDataTask()
        // When
        networkService.request(IPCRequest()) { [weak self] result in
            guard let self = self,
                    case .failure(let error) = result else {
                XCTFail("Something went wrong")
                return
            }
            
            XCTAssertTrue(self.urlSessionSpy.performTaskCalled)
            XCTAssertEqual(error.localizedDescription, "Ocurrió un error al tratar de obtener la información, intenta de nuevo.")
            expectation.fulfill()
        }
    }

}
