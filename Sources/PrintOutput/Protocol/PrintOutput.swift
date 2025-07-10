import Foundation

/// A protocol for objects that can output text strings.
///
/// `PrintOutput` extends `TextOutputStream` to provide a standardized way to output text
/// to various destinations such as console, files, or custom outputs.
///
/// ## Overview
///
/// This protocol is the foundation of the print output system, allowing you to create
/// custom output destinations that can be used with the enhanced printing functionality.
///
/// ## Example
///
/// ```swift
/// struct MyCustomOutput: PrintOutput {
///     mutating func write(_ string: String) {
///         // Custom output logic here
///         print("Custom: \(string)")
///     }
/// }
/// ```
public protocol PrintOutput: TextOutputStream {
    /// Writes a string to the output destination.
    /// - Parameter string: The string to write to the output.
    mutating func write(_ string: String)
}

public extension PrintOutput {
    /// Default implementation that must be overridden by conforming types.
    /// 
    /// This implementation throws a fatal error to ensure that conforming types
    /// provide their own implementation of the `write(_:)` method.
    /// 
    /// - Parameter string: The string to write to the output.
    /// - Warning: This method must be overridden in conforming types.
    mutating func write(_ string: String) {
        fatalError("This method must be overridden in conforming types.")
    }
}
