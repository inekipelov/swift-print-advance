//
//  CustomStringConvertiblePrintTests.swift
//

import XCTest
import Foundation

@testable import PrintAdvance

// MARK: - CustomStringConvertible Extension Tests

class CustomStringConvertiblePrintTests: XCTestCase {
    
    func testPrintToConsole() {
        let testModel = TestModel(name: "Test", value: 42)
        
        // This should not crash and should return self
        let result = testModel.print()
        XCTAssertEqual(result.name, "Test")
        XCTAssertEqual(result.value, 42)
    }
    
    func testPrintToOutput() {
        let testModel = TestModel(name: "Test", value: 42)
        let mockOutput = MockPrintOutput()
        
        let result = testModel.print(to: mockOutput)
        
        // Should return self
        XCTAssertEqual(result.name, "Test")
        XCTAssertEqual(result.value, 42)
        
        // Should have written to output
        XCTAssertTrue(mockOutput.capturedOutput.contains("TestModel(name: Test, value: 42)"))
    }
    
    func testPrintChaining() {
        let testModel = TestModel(name: "Chain", value: 123)
        let mockOutput = MockPrintOutput()
        
        let result = testModel
            .print(to: mockOutput)
            .print(to: mockOutput)
        
        XCTAssertEqual(result.name, "Chain")
        XCTAssertEqual(result.value, 123)
        
        // Should have written twice
        let outputLines = mockOutput.capturedOutput.components(separatedBy: "\n").filter { !$0.isEmpty }
        XCTAssertEqual(outputLines.count, 2)
    }
    
    func testPrintWithString() {
        let testString = "Hello, World!"
        let mockOutput = MockPrintOutput()
        
        let result = testString.print(to: mockOutput)
        
        XCTAssertEqual(result, "Hello, World!")
        XCTAssertTrue(mockOutput.capturedOutput.contains("Hello, World!"))
    }
    
    func testPrintWithNumbers() {
        let testInt = 42
        let mockOutput = MockPrintOutput()
        
        let result = testInt.print(to: mockOutput)
        
        XCTAssertEqual(result, 42)
        XCTAssertTrue(mockOutput.capturedOutput.contains("42"))
    }
}
