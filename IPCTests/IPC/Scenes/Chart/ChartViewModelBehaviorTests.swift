//
//  ChartViewModelBehaviorTests.swift
//  IPCTests
//
//  Created by Eduardo García González on 17/03/23.
//

@testable import IPC
import XCTest

final class ChartViewModelBehaviorTests: XCTestCase {
    private var ipcRepositorySpy: IPCRepositorySpy!
    private var ipcRealTimeRepositorySpy: IPCRepositoryRealTimeSpy!
    private var ipcRealTimeRepository: IPCRealTimeRepositorable!

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(
            DateFormatter.formatter(with: DateFormatter.Formats.iso08601.rawValue)
        )
        
        return decoder
    }()
    override func setUp() {
        self.ipcRepositorySpy = IPCRepositorySpy()
        self.ipcRealTimeRepositorySpy = IPCRepositoryRealTimeSpy()
        self.ipcRealTimeRepository = IPCRealTimeRepository(timer: TimerSpy.self)
    }
    
    func test_update_initial_data() throws {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let data = try XCTUnwrap(FileManager.getFileData(with: "ipcResponse", type: "json"))
        let model = try XCTUnwrap(decoder.decode([IPCData].self, from: data))
        ipcRepositorySpy.getIPCDataCompletionInput = .success(model)
        let sut = ChartViewModel(ipcRepository: ipcRepositorySpy, ipcRealTimeRepository: DummyIPCRepositoryRealTime())
        
        sut.notifier = { [weak self] notification in
            guard case .didUpdate(let data) = notification else {
                return XCTFail("Something went wrong")
            }
            
            XCTAssertEqual(self?.ipcRepositorySpy.getIPCDataCalled, true)
            XCTAssertEqual(data.count, 4)
            expectation.fulfill()
        }
        
        // When
        sut.loadData()
    }
    
    func test_update_real_time_simulation_data() throws {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let model = ChartDataMother.chartData
        ipcRealTimeRepositorySpy.simulateUpdaterInput = [model[0]]
        ipcRealTimeRepositorySpy.stubbedTimerType = DummyTimer.self
        
        let sut = ChartViewModel(ipcRepository: DummyIPCRepository(), ipcRealTimeRepository: ipcRealTimeRepositorySpy)
        
        sut.notifier = { [weak self] notification in
            // Validate
            guard case .didUpdateFromSimulation(let data, let complete) = notification else {
                return XCTFail("Something went wrong")
            }
            
            XCTAssertEqual(self?.ipcRealTimeRepositorySpy.simulateCalled, true)
            XCTAssertFalse(complete)
            XCTAssertEqual(data.count, 1)
            expectation.fulfill()
        }
        
        // When
        sut.simulateRealTime()
    }
    
    func test_complete_real_time_simulation_data() throws {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let model = ChartDataMother.chartData
        ipcRealTimeRepositorySpy.simulateCompletionInput = model
        ipcRealTimeRepositorySpy.stubbedTimerType = TimerSpy.self
        
        let sut = ChartViewModel(ipcRepository: DummyIPCRepository(), ipcRealTimeRepository: ipcRealTimeRepositorySpy)
        
        sut.notifier = { [weak self] notification in
            // Validate
            guard case .didUpdateFromSimulation(let data, let complete) = notification else {
                return XCTFail("Something went wrong")
            }
            
            XCTAssertEqual(self?.ipcRealTimeRepositorySpy.simulateCalled, true)
            XCTAssertTrue(complete)
            XCTAssertEqual(data.count, 17)
            expectation.fulfill()
        }
        
        // When
        sut.simulateRealTime()
        
    }
    
    func test_stop_real_time_simulation_data() throws {
        // Given
        let model = ChartDataMother.chartData
        ipcRealTimeRepositorySpy.simulateCompletionInput = model
        ipcRealTimeRepositorySpy.stubbedTimerType = TimerSpy.self
        
        let sut = ChartViewModel(ipcRepository: DummyIPCRepository(), ipcRealTimeRepository: ipcRealTimeRepositorySpy)

        // When
        sut.simulateRealTime()
        sut.stopRealTimeSimulation()
        
        // Validate
        let timer = try XCTUnwrap(ipcRealTimeRepositorySpy.stubbedTimer as? TimerSpy)
        XCTAssertTrue(timer.invalidateCalled)
    }

}

