//
//  ManyPrintOutputTests.swift
//

import XCTest
import Foundation

@testable import PrintAdvance

// MARK: - ManyPrintOutput Tests

class ManyPrintOutputTests: XCTestCase {
    
    func testManyPrintOutputWithMultipleOutputs() {
        let mockOutput1 = MockPrintOutput()
        let mockOutput2 = MockPrintOutput()
        let mockOutput3 = MockPrintOutput()
        
        let manyOutput = ManyPrintOutput(mockOutput1, mockOutput2, mockOutput3)
        
        let testString = "Hello, World!".print(to: manyOutput)
        
        XCTAssertEqual(mockOutput1.capturedOutput, testString)
        XCTAssertEqual(mockOutput2.capturedOutput, testString)
        XCTAssertEqual(mockOutput3.capturedOutput, testString)
        XCTAssertEqual(manyOutput.count, 3)
    }
    
    func testManyPrintOutputWithArrayInit() {
        let mockOutput1 = MockPrintOutput()
        let mockOutput2 = MockPrintOutput()
        let outputs: [any PrintOutput] = [mockOutput1, mockOutput2]
        
        let manyOutput = ManyPrintOutput(outputs)
        
        let testString = "Test with array".print(to: manyOutput)
        
        XCTAssertEqual(mockOutput1.capturedOutput, testString)
        XCTAssertEqual(mockOutput2.capturedOutput, testString)
        XCTAssertEqual(manyOutput.count, 2)
    }
    
    func testManyPrintOutputStaticFactoryMethods() {
        let mockOutput1 = MockPrintOutput()
        let mockOutput2 = MockPrintOutput()
        
        let manyOutput = ManyPrintOutput.with(mockOutput1, mockOutput2)
        
        let testString = "Factory method test".print(to: manyOutput)
        
        XCTAssertEqual(mockOutput1.capturedOutput, testString)
        XCTAssertEqual(mockOutput2.capturedOutput, testString)
        XCTAssertEqual(manyOutput.count, 2)
    }
    
    func testManyPrintOutputAddMethod() {
        let mockOutput1 = MockPrintOutput()
        let mockOutput2 = MockPrintOutput()
        
        let manyOutput = ManyPrintOutput(mockOutput1)
        XCTAssertEqual(manyOutput.count, 1)
        
        manyOutput.add(mockOutput2)
        XCTAssertEqual(manyOutput.count, 2)
        
        let testString = "Added output test".print(to: manyOutput)
        
        XCTAssertEqual(mockOutput1.capturedOutput, testString)
        XCTAssertEqual(mockOutput2.capturedOutput, testString)
    }
    
    func testManyPrintOutputClear() {
        let mockOutput1 = MockPrintOutput()
        let mockOutput2 = MockPrintOutput()
        
        let manyOutput = ManyPrintOutput(mockOutput1, mockOutput2)
        XCTAssertEqual(manyOutput.count, 2)
        
        manyOutput.clear()
        XCTAssertEqual(manyOutput.count, 0)
        
        // Writing after clear should not affect the original outputs
        "After clear".print(to: manyOutput)
        
        XCTAssertEqual(mockOutput1.capturedOutput, "")
        XCTAssertEqual(mockOutput2.capturedOutput, "")
    }
    
    func testManyPrintOutputWithMixedTypes() {
        let mockOutput = MockPrintOutput()
        let bufferOutput = BufferPrint.shared
        
        // Clear buffer to start fresh
        bufferOutput.clear()
        
        let manyOutput = ManyPrintOutput(mockOutput, bufferOutput)
        
        let testString = "Mixed types test".print(to: manyOutput)
        
        XCTAssertEqual(mockOutput.capturedOutput, testString)
        XCTAssertEqual(manyOutput.count, 2)
        
        // Wait for async buffer update to complete
        let expectation = XCTestExpectation(description: "Buffer update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(bufferOutput.buffer, testString)
    }
}
