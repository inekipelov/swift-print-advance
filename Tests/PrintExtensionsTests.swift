import XCTest
import Foundation
#if canImport(Combine)
import Combine
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif

@testable import PrintAdvance

// MARK: - Mock PrintOutput Implementation

class MockPrintOutput: PrintOutput {
    private var buffer = ""
    
    /// Captured output for testing
    var capturedOutput: String {
        return buffer
    }
    
    /// Clear the captured output
    func clear() {
        buffer = ""
    }
    
    /// Write to the mock output
    func write(_ string: String) {
        buffer += string
    }
}

// MARK: - Test Models

struct TestModel: CustomStringConvertible {
    let name: String
    let value: Int
    
    var description: String {
        return "TestModel(name: \(name), value: \(value))"
    }
}

enum TestError: Error, CustomStringConvertible {
    case testFailure(String)
    
    var description: String {
        switch self {
        case .testFailure(let message):
            return "TestError: \(message)"
        }
    }
}

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
    
    func testMockPrintOutputFunctionality() {
        let mockOutput = MockPrintOutput()
        
        // Test writing
        mockOutput.write("Hello")
        mockOutput.write(" ")
        mockOutput.write("World")
        
        XCTAssertEqual(mockOutput.capturedOutput, "Hello World")
        
        // Test clearing
        mockOutput.clear()
        XCTAssertEqual(mockOutput.capturedOutput, "")
        
        // Test writing after clear
        mockOutput.write("New content")
        XCTAssertEqual(mockOutput.capturedOutput, "New content")
    }
}
