//
//  ResultPrintTests.swift
//

import XCTest
import Foundation

@testable import PrintAdvance

// MARK: - Result Extension Tests

class ResultPrintTests: XCTestCase {
    
    func testPrintSuccessResult() {
        let successResult: Result<String, TestError> = .success("Success Value")
        let mockOutput = MockPrintOutput()
        
        let result = successResult.print(to: mockOutput)
        
        // Should return self
        switch result {
        case .success(let value):
            XCTAssertEqual(value, "Success Value")
        case .failure:
            XCTFail("Expected success result")
        }
        
        // Should have written to output
        XCTAssertTrue(mockOutput.capturedOutput.contains("success"))
        XCTAssertTrue(mockOutput.capturedOutput.contains("Success Value"))
    }
    
    func testPrintFailureResult() {
        let failureResult: Result<String, TestError> = .failure(.testFailure("Test failed"))
        let mockOutput = MockPrintOutput()
        
        let result = failureResult.print(to: mockOutput)
        
        // Should return self
        switch result {
        case .success:
            XCTFail("Expected failure result")
        case .failure(let error):
            if case .testFailure(let message) = error {
                XCTAssertEqual(message, "Test failed")
            } else {
                XCTFail("Unexpected error type")
            }
        }
        
        // Should have written to output
        XCTAssertTrue(mockOutput.capturedOutput.contains("failure"))
        XCTAssertTrue(mockOutput.capturedOutput.contains("Test failed"))
    }
    
    func testPrintResultToConsole() {
        let result: Result<Int, TestError> = .success(100)
        
        // This should not crash and should return self
        let returnedResult = result.print()
        
        switch returnedResult {
        case .success(let value):
            XCTAssertEqual(value, 100)
        case .failure:
            XCTFail("Expected success result")
        }
    }
    
    func testPrintResultChaining() {
        let result: Result<String, TestError> = .success("Chain Test")
        let mockOutput = MockPrintOutput()
        
        let chainedResult = result
            .print(to: mockOutput)
            .print(to: mockOutput)
        
        switch chainedResult {
        case .success(let value):
            XCTAssertEqual(value, "Chain Test")
        case .failure:
            XCTFail("Expected success result")
        }
        
        // Should have written twice
        let outputLines = mockOutput.capturedOutput.components(separatedBy: "\n").filter { !$0.isEmpty }
        XCTAssertEqual(outputLines.count, 2)
    }
}
