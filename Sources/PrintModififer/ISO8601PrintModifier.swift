//
//  ISO8601PrintModifier.swift
//

import Foundation

public struct ISO8601PrintModifier: PrintModifier {
    let date: Date
    public init(date: Date = Date()) {
        self.date = date
    }
    /// A static ISO 8601 date formatter instance.
    ///
    /// This formatter is shared across all instances of `TimestampPrintOutputModifier`
    /// to avoid the performance overhead of creating multiple formatter instances.
    /// It uses the ISO 8601 standard format for consistent timestamp representation.
    static private let formatter = ISO8601DateFormatter()
    
    public func callAsFunction(input string: String) -> String {
        let ts = Self.formatter.string(from: date)
        return "[\(ts)] \(string)"
    }
}

