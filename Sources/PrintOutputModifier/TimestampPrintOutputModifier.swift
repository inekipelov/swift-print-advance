//
//  TimestampPrintOutputModifier.swift
//

import Foundation

/// A print output modifier that adds timestamps to output strings.
///
/// `TimestampPrintOutputModifier` prepends each output string with a timestamp
/// in ISO 8601 format (e.g., "2023-12-25T10:30:45Z"). This is useful for
/// logging and debugging to track when specific output was generated.
///
/// ## Overview
///
/// The modifier uses `ISO8601DateFormatter` to format timestamps consistently.
/// Each string is prefixed with the timestamp enclosed in square brackets,
/// followed by a space and the original string.
///
/// ## Format
///
/// The timestamp format is: `[YYYY-MM-DDTHH:MM:SSZ] original_string`
///
/// ## Example
///
/// ```swift
/// 
/// "Hello, World!".print(to: ConsolePrint().timestamped)
/// // Output: "[2023-12-25T10:30:45Z] Hello, World!"
/// ```
///
/// ## Performance
///
/// The modifier uses a static `ISO8601DateFormatter` instance to avoid
/// the overhead of creating new formatters for each timestamp. This makes
/// it efficient for frequent logging operations.
public struct TimestampPrintOutputModifier: PrintOutputModifier {
    /// Modifies the input string by prepending a timestamp.
    ///
    /// This method generates a timestamp using the current date and time,
    /// formats it using ISO 8601 format, and prepends it to the input string.
    ///
    /// - Parameter string: The original string to modify.
    /// - Returns: The string with a timestamp prepended in the format `[timestamp] string`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modifier = TimestampPrintOutputModifier()
    /// let result = modifier.modify("Application started")
    /// // Result: "[2023-12-25T10:30:45Z] Application started"
    /// ```
    public func modify(_ string: String) -> String {
        let ts = Self.formatter.string(from: Date())
        return "[\(ts)] \(string)"
    }
    
    /// A static ISO 8601 date formatter instance.
    ///
    /// This formatter is shared across all instances of `TimestampPrintOutputModifier`
    /// to avoid the performance overhead of creating multiple formatter instances.
    /// It uses the ISO 8601 standard format for consistent timestamp representation.
    static private let formatter = ISO8601DateFormatter()
}

/// Extension providing convenience methods for timestamp modification.
public extension PrintOutput {
    /// Creates a timestamped version of this print output.
    ///
    /// This computed property provides a convenient way to add timestamps
    /// to any print output without explicitly creating a modifier.
    ///
    /// - Returns: A `ModifiedPrintOutput` that adds timestamps to all output.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let console = ConsolePrint().timestamped
    /// "Debug message".print(to: console)
    /// // Output: "[2023-12-25T10:30:45Z] Debug message"
    /// ```
    var timestamped: ModifiedPrintOutput<Self> {
        modified(TimestampPrintOutputModifier())
    }
}
