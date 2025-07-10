//
//  MockPrintOutput.swift
//

import PrintAdvance

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
