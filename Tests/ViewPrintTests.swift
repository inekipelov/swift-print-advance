//
//  ViewPrintTests.swift
//

import XCTest
import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif

@testable import PrintAdvance

// MARK: - View Extension Tests

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
class ViewPrintTests: XCTestCase {
    
    struct TestView: View {
        let text: String
        
        var body: some View {
            Text(text)
        }
    }
    
    func testViewPrintToConsole() {
        let testView = TestView(text: "Hello")
        
        // This should not crash and should return a view
        let resultView = testView.print()
        
        // We can't easily test the content, but we can ensure it compiles and doesn't crash
        XCTAssertNotNil(resultView)
    }
    
    func testViewPrintToOutput() {
        let testView = TestView(text: "Hello")
        let mockOutput = MockPrintOutput()
        
        let resultView = testView.print(to: mockOutput)
        
        // Should return a view
        XCTAssertNotNil(resultView)
        
        // Should have written to output
        XCTAssertFalse(mockOutput.capturedOutput.isEmpty)
    }
    
    func testViewPrintWithItems() {
        let testView = TestView(text: "Hello")
        
        let resultView = testView.print("Debug:", "value", "items")
        
        // Should return a view
        XCTAssertNotNil(resultView)
    }
    
    func testViewPrintWithItemsToOutput() {
        let testView = TestView(text: "Hello")
        let mockOutput = MockPrintOutput()
        
        let resultView = testView.print("Debug:", "value", "items", to: mockOutput)
        
        // Should return a view
        XCTAssertNotNil(resultView)
        
        // Should have written to output
        XCTAssertTrue(mockOutput.capturedOutput.contains("Debug:"))
        XCTAssertTrue(mockOutput.capturedOutput.contains("value"))
        XCTAssertTrue(mockOutput.capturedOutput.contains("items"))
    }
    
    func testViewPrintWithCustomSeparatorAndTerminator() {
        let testView = TestView(text: "Hello")
        let mockOutput = MockPrintOutput()
        
        let resultView = testView.print("A", "B", "C", separator: "-", terminator: "END\n", to: mockOutput)
        
        // Should return a view
        XCTAssertNotNil(resultView)
        
        // Should have written to output with custom separator and terminator
        XCTAssertTrue(mockOutput.capturedOutput.contains("A") && mockOutput.capturedOutput.contains("B") && mockOutput.capturedOutput.contains("C"))
        XCTAssertTrue(mockOutput.capturedOutput.contains("END"))
    }
    
    @available(iOS 15.0, macOS 12, watchOS 8.0, tvOS 15.0, *)
    func testViewPrintChanges() {
        let testView = TestView(text: "Hello")
        
        let resultView = testView.printChanges()
        
        // Should return a view
        XCTAssertNotNil(resultView)
    }
    
    @available(iOS 17.1, macOS 14.1, watchOS 10.1, tvOS 17.1, *)
    func testViewLogChanges() {
        let testView = TestView(text: "Hello")
        
        let resultView = testView.logChanges()
        
        // Should return a view
        XCTAssertNotNil(resultView)
    }
}
#endif
