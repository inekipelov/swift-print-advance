//
//  IntegrationTests.swift
//

import XCTest
import Foundation

@testable import PrintAdvance

// MARK: - Integration Tests

class IntegrationTests: XCTestCase {
    
    func testAllExtensionsWorkTogether() {
        let testModel = TestModel(name: "Integration", value: 123)
        let result: Result<TestModel, TestError> = .success(testModel)
        let mockOutput = MockPrintOutput()
        
        let finalResult = result
            .print(to: mockOutput)
            .map { $0.print(to: mockOutput) }
        
        switch finalResult {
        case .success(let value):
            XCTAssertEqual(value.name, "Integration")
            XCTAssertEqual(value.value, 123)
        case .failure:
            XCTFail("Expected success result")
        }
        
        // Should have written twice
        let outputLines = mockOutput.capturedOutput.components(separatedBy: "\n").filter { !$0.isEmpty }
        XCTAssertEqual(outputLines.count, 2)
    }
}
