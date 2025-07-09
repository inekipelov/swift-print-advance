//
//  TimestampPrintOutputModifier.swift
//

import Foundation

public struct TimestampPrintOutputModifier: PrintOutputModifier {
    public func modify(_ string: String) -> String {
        let ts = Self.formatter.string(from: Date())
        return "[\(ts)] \(string)"
    }
    
    static private let formatter = ISO8601DateFormatter()
}

public extension PrintOutput {
    var timestamped: ModifiedPrintOutput<Self> {
        modified(TimestampPrintOutputModifier())
    }
}
