//
//  PublisherPrintTests.swift
//

import XCTest
import Foundation
#if canImport(Combine)
import Combine
#endif

@testable import PrintAdvance

// MARK: - Publisher Extension Tests

#if canImport(Combine)
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
class PublisherPrintTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testPublisherPrintToOutput() {
        let expectation = self.expectation(description: "Publisher completion")
        let mockOutput = MockPrintOutput()
        
        let publisher = Just("Test Value")
            .print(prefix: "DEBUG", to: mockOutput)
        
        publisher
            .sink(
                receiveCompletion: { _ in
                    expectation.fulfill()
                },
                receiveValue: { value in
                    XCTAssertEqual(value, "Test Value")
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testPublisherPrintWithCustomStringConvertible() {
        let expectation = self.expectation(description: "Publisher completion")
        let mockOutput = MockPrintOutput()
        
        let testModel = TestModel(name: "Publisher Test", value: 999)
        let publisher = Just(testModel)
            .print(prefix: "MODEL", to: mockOutput)
        
        publisher
            .sink(
                receiveCompletion: { _ in
                    expectation.fulfill()
                },
                receiveValue: { value in
                    XCTAssertEqual(value.name, "Publisher Test")
                    XCTAssertEqual(value.value, 999)
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testPublisherPrintWithSequence() {
        let expectation = self.expectation(description: "Publisher completion")
        let mockOutput = MockPrintOutput()
        
        let values = ["First", "Second", "Third"]
        let publisher = values.publisher
            .print(prefix: "SEQUENCE", to: mockOutput)
        
        var receivedValues: [String] = []
        
        publisher
            .sink(
                receiveCompletion: { _ in
                    expectation.fulfill()
                },
                receiveValue: { value in
                    receivedValues.append(value)
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(receivedValues, ["First", "Second", "Third"])
    }
    
    func testPublisherPrintWithError() {
        let expectation = self.expectation(description: "Publisher completion")
        let mockOutput = MockPrintOutput()
        
        let publisher = Fail<String, TestError>(error: .testFailure("Publisher error"))
            .print(prefix: "ERROR", to: mockOutput)
        
        publisher
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        if case .testFailure(let message) = error {
                            XCTAssertEqual(message, "Publisher error")
                        }
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail("Should not receive value")
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
}
#endif
