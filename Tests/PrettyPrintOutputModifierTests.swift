//
//  PrettyPrintOutputModifierTests.swift
//

import XCTest
@testable import PrintAdvance

final class PrettyPrintOutputModifierTests: XCTestCase {
    
    func testJSONFormatting() {
        // Given
        let modifier = PrettyPrintOutputModifier(format: .json)
        let jsonString = """
        {"name":"John","age":30,"city":"New York","hobbies":["reading","gaming"],"address":{"street":"123 Main St","zip":"10001"}}
        """
        
        // When
        let result = modifier.modify(jsonString)
        
        // Then
        Swift.print("Original JSON:")
        Swift.print(jsonString)
        Swift.print("\nPretty printed JSON:")
        Swift.print(result)
        
        // Verify it contains proper formatting
        XCTAssertTrue(result.contains("{\n"))
        XCTAssertTrue(result.contains("  \"name\" : \"John\""))
        XCTAssertTrue(result.contains("  \"hobbies\" : ["))
        XCTAssertTrue(result.contains("    \"reading\""))
    }
    
    func testStructuredFormatting() {
        // Given
        let modifier = PrettyPrintOutputModifier(
            spacing: .spaces(4),
            format: .structured
        )
        let input = "{key1:value1,key2:{nested:value,array:[item1,item2]}}"
        
        // When
        let result = modifier.modify(input)
        
        // Then
        Swift.print("Original structured data:")
        Swift.print(input)
        Swift.print("\nPretty printed structured:")
        Swift.print(result)
        
        // Verify formatting
        XCTAssertTrue(result.contains("{\n"))
        XCTAssertTrue(result.contains("    key1: value1"))
        XCTAssertTrue(result.contains("        nested: value"))
    }
    
    func testTabIndentation() {
        // Given
        let modifier = PrettyPrintOutputModifier(
            spacing: .tabs,
            format: .structured
        )
        let input = "{level1:{level2:{level3:value}}}"
        
        // When
        let result = modifier.modify(input)
        
        // Then
        Swift.print("Original nested data:")
        Swift.print(input)
        Swift.print("\nPretty printed with tabs:")
        Swift.print(result)
        
        // Verify tab indentation
        XCTAssertTrue(result.contains("\t"))
        XCTAssertTrue(result.contains("\t\t"))
        XCTAssertTrue(result.contains("\t\t\t"))
    }
    
    func testMinimalFormatting() {
        // Given
        let modifier = PrettyPrintOutputModifier(
            format: .minimal
        )
        let input = "  This   is    a   string   with    extra    spaces  \n\n"
        
        // When
        let result = modifier.modify(input)
        
        // Then
        Swift.print("Original with extra spaces:")
        Swift.print("'\(input)'")
        Swift.print("\nMinimal formatted:")
        Swift.print("'\(result)'")
        
        // Verify minimal formatting
        XCTAssertEqual(result, "This is a string with extra spaces")
    }
    
    func testComplexJSONExample() {
        // Given
        let modifier = PrettyPrintOutputModifier()
        let complexJSON = """
        {"users":[{"id":1,"profile":{"name":"Alice","preferences":{"theme":"dark","notifications":true}}},{"id":2,"profile":{"name":"Bob","preferences":{"theme":"light","notifications":false}}}],"metadata":{"version":"1.0","timestamp":"2025-07-11"}}
        """
        
        // When
        let result = modifier.modify(complexJSON)
        
        // Then
        Swift.print("Complex JSON example:")
        Swift.print("Original:")
        Swift.print(complexJSON)
        Swift.print("\nPretty printed:")
        Swift.print(result)
        
        // Basic verification
        XCTAssertTrue(result.count > complexJSON.count) // Should be longer due to formatting
        XCTAssertTrue(result.contains("\n")) // Should contain line breaks
    }
    
    func testInvalidJSON() {
        // Given
        let modifier = PrettyPrintOutputModifier(format: .json)
        let invalidJSON = "{name:John,age:30}" // Missing quotes
        
        // When
        let result = modifier.modify(invalidJSON)
        
        // Then
        Swift.print("Invalid JSON fallback test:")
        Swift.print("Original:")
        Swift.print(invalidJSON)
        Swift.print("\nFormatted (fallback to structured):")
        Swift.print(result)
        
        // Should fallback to structured formatting
        XCTAssertTrue(result.contains("\n"))
        XCTAssertTrue(result.contains("name: John"))
    }
    
    func testPrintOutputExtension() {
        // Given
        let mockOutput = MockPrintOutput()
        let prettyOutput = mockOutput.prettyPrinted()
        let testJSON = """
        {"message":"Hello","data":{"items":[1,2,3]}}
        """
        
        // When
        testJSON.print(to: prettyOutput)
        
        // Then
        Swift.print("Extension test:")
        Swift.print("Original:")
        Swift.print(testJSON)
        Swift.print("\nOutput received by mock:")
        let capturedOutput = mockOutput.capturedOutput
        Swift.print(capturedOutput)
        XCTAssertTrue(capturedOutput.contains("  \"message\" : \"Hello\""))
    }
}
