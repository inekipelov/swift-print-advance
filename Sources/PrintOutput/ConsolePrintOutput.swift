//
//  ConsolePrintOutput.swift
//

import Dispatch

typealias ConsolePrint = ConsolePrintOutput

private let consolePrintSerialQueue = DispatchQueue(
    label: "com.swift-print-advance.ConsolePrintOutput",
    qos: .utility
)

public struct ConsolePrintOutput: PrintOutput {
    public mutating func write(_ string: String) {
        consolePrintSerialQueue.async {
            Swift.print(string, terminator: "")
        }
    }
}
