//
//  AnyPrintOutput.swift
//

import Foundation

public struct AnyPrintOutput: PrintOutput {
    private let _write: (String) -> Void
    public init<O: PrintOutput>(_ output: O) {
        var output = output
        self._write = { string in output.write(string) }
    }
    public mutating func write(_ string: String) { _write(string) }
}

extension PrintOutput {
    public var eraseToAnyPrintOutput: AnyPrintOutput {
        AnyPrintOutput(self)
    }
}
