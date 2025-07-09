//
//  ConsolePrintOutput.swift
//

typealias ConsolePrint = ConsolePrintOutput

public struct ConsolePrintOutput: PrintOutput {
    public mutating func write(_ string: String) {
        Swift.print(string, terminator: "")
    }
}
