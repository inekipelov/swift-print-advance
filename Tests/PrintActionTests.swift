//
//  PrintActionTests.swift
//

import XCTest
import Foundation

@testable import PrintAdvance

// MARK: - PrintAction Tests via Public API

class PrintActionTests: XCTestCase {
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Internal PrintAction Tests (Direct Access)
    
    func testPrintActionInitWithArrayModifiers() {
        let model = TestModel(name: "Test", value: 42)
        let modifiers: [any PrintModifier] = [TestModifier(prefix: "PREFIX")]
        let mockOutput = MockPrintOutput()
        
        // Internal access to PrintAction initializer
        let printAction = PrintAction(model, to: mockOutput, with: modifiers)
        
        XCTAssertEqual(printAction.subject.name, "Test")
        XCTAssertEqual(printAction.subject.value, 42)
        XCTAssertNotNil(printAction.output)
    }
    
    func testPrintActionInitWithVariadicModifiers() {
        let model = TestModel(name: "Test", value: 42)
        let mockOutput = MockPrintOutput()
        
        // Internal access to PrintAction initializer
        let printAction = PrintAction(
            model, 
            to: mockOutput, 
            with: TestModifier(prefix: "PREFIX1"), 
            TestModifier(prefix: "PREFIX2")
        )
        
        XCTAssertEqual(printAction.subject.name, "Test")
        XCTAssertEqual(printAction.subject.value, 42)
        XCTAssertNotNil(printAction.output)
    }
    
    func testPrintActionInitWithoutOutput() {
        let model = TestModel(name: "Test", value: 42)
        
        // Internal access to PrintAction initializer
        let printAction = PrintAction(model)
        
        XCTAssertEqual(printAction.subject.name, "Test")
        XCTAssertEqual(printAction.subject.value, 42)
        XCTAssertNil(printAction.output)
    }
    
    func testPrintActionInitWithoutModifiers() {
        let model = TestModel(name: "Test", value: 42)
        let mockOutput = MockPrintOutput()
        
        // Internal access to PrintAction initializer
        let printAction = PrintAction(model, to: mockOutput)
        
        XCTAssertEqual(printAction.subject.name, "Test")
        XCTAssertEqual(printAction.subject.value, 42)
        XCTAssertNotNil(printAction.output)
    }
    
    // MARK: - Dynamic Member Lookup Tests
    
    func testPrintActionDynamicMemberLookup() {
        let model = TestModel(name: "TestName", value: 123)
        let printAction = PrintAction(model)
        
        // Access properties through dynamic member lookup
        XCTAssertEqual(printAction.name, "TestName")
        XCTAssertEqual(printAction.value, 123)
    }
    
    func testPrintActionDynamicMemberLookupWithComplexModel() {
        let customModel = TestModel(name: "Complex", value: 999)
        let printAction = PrintAction(customModel)
        
        XCTAssertEqual(printAction.name, "Complex")
        XCTAssertEqual(printAction.value, 999)
    }
    
    // MARK: - PrintAction CallAsFunction Tests
    
    func testPrintActionCallAsFunctionWithOutput() {
        let model = TestModel(name: "Test", value: 42)
        let mockOutput = MockPrintOutput()
        let printAction = PrintAction(model, to: mockOutput)
        
        let result = printAction()
        
        // Should return the original subject
        XCTAssertEqual(result.name, "Test")
        XCTAssertEqual(result.value, 42)
        
        // Should write to the provided output
        XCTAssertFalse(mockOutput.capturedOutput.isEmpty)
        XCTAssertTrue(mockOutput.capturedOutput.contains("TestModel"))
        XCTAssertTrue(mockOutput.capturedOutput.contains("Test"))
        XCTAssertTrue(mockOutput.capturedOutput.contains("42"))
    }
    
    func testPrintActionCallAsFunctionWithoutOutput() {
        let model = TestModel(name: "Test", value: 42)
        let printAction = PrintAction(model) // No output provided
        
        // This should not crash and should use Swift.print
        let result = printAction()
        
        XCTAssertEqual(result.name, "Test")
        XCTAssertEqual(result.value, 42)
    }
    
    func testPrintActionCallAsFunctionDiscardableResult() {
        let model = TestModel(name: "Test", value: 42)
        let mockOutput = MockPrintOutput()
        let printAction = PrintAction(model, to: mockOutput)
        
        // Should be able to discard the result without warnings
        printAction()
        
        XCTAssertFalse(mockOutput.capturedOutput.isEmpty)
    }
    
    // MARK: - Modifier Tests (Internal)
    
    func testPrintActionSingleModifier() {
        let model = TestModel(name: "Test", value: 42)
        let mockOutput = MockPrintOutput()
        let modifier = TestModifier(prefix: "LOG")
        let printAction = PrintAction(model, to: mockOutput, with: modifier)
        
        let result = printAction()
        
        XCTAssertEqual(result.name, "Test")
        XCTAssertEqual(result.value, 42)
        XCTAssertEqual(mockOutput.capturedOutput, "LOG: TestModel(name: Test, value: 42)")
    }
    
    func testPrintActionMultipleModifiers() {
        let model = TestModel(name: "Test", value: 42)
        let mockOutput = MockPrintOutput()
        let modifier1 = TestModifier(prefix: "LEVEL1")
        let modifier2 = TestModifier(prefix: "LEVEL2")
        let printAction = PrintAction(model, to: mockOutput, with: [modifier1, modifier2])
        
        let result = printAction()
        
        XCTAssertEqual(result.name, "Test")
        XCTAssertEqual(result.value, 42)
        // Modifiers should be applied in reverse order (LEVEL2 first, then LEVEL1)
        XCTAssertEqual(mockOutput.capturedOutput, "LEVEL1: LEVEL2: TestModel(name: Test, value: 42)")
    }
    
    func testPrintActionNoModifiers() {
        let model = TestModel(name: "Test", value: 42)
        let mockOutput = MockPrintOutput()
        let printAction = PrintAction(model, to: mockOutput, with: [])
        
        let result = printAction()
        
        XCTAssertEqual(result.name, "Test")
        XCTAssertEqual(result.value, 42)
        XCTAssertEqual(mockOutput.capturedOutput, "TestModel(name: Test, value: 42)")
    }
    
    // MARK: - Edge Cases
    
    func testPrintActionEmptyStringSubject() {
        let emptyString = ""
        let mockOutput = MockPrintOutput()
        let modifier = TestModifier(prefix: "EMPTY")
        let printAction = PrintAction(emptyString, to: mockOutput, with: modifier)
        
        let result = printAction()
        
        XCTAssertEqual(result, "")
        XCTAssertEqual(mockOutput.capturedOutput, "EMPTY: ")
    }
    
    func testPrintActionNilOptionalSubject() {
        let nilValue: String? = nil
        let mockOutput = MockPrintOutput()
        let printAction = PrintAction(nilValue, to: mockOutput)
        
        let result = printAction()
        
        XCTAssertNil(result)
        XCTAssertTrue(mockOutput.capturedOutput.contains("nil"))
    }
    
    // MARK: - Performance Tests
    
    func testPrintActionPerformanceWithManyModifiers() {
        let model = TestModel(name: "Performance", value: 1000)
        let mockOutput = MockPrintOutput()
        
        var modifiers: [any PrintModifier] = []
        for i in 0..<100 {
            modifiers.append(TestModifier(prefix: "MOD\(i)"))
        }
        
        let printAction = PrintAction(model, to: mockOutput, with: modifiers)
        
        measure {
            _ = printAction()
            mockOutput.clear()
        }
    }
    
    func testPrintActionPerformanceWithLargeString() {
        let largeString = String(repeating: "A", count: 10000)
        let mockOutput = MockPrintOutput()
        let modifier = TestModifier(prefix: "Performance")
        let printAction = PrintAction(largeString, to: mockOutput, with: modifier)
        
        measure {
            _ = printAction()
            mockOutput.clear()
        }
    }
}
