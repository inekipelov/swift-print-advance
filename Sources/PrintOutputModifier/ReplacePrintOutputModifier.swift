//
//  ReplacePrintOutputModifier.swift
//

import Foundation

/// A print output modifier that replaces occurrences of a target string with a replacement string.
///
/// `ReplacePrintOutputModifier` performs string replacement operations on all output,
/// substituting every occurrence of a target string with a replacement string.
/// This is useful for content sanitization, format transformation, or text processing.
///
/// ## Overview
///
/// The modifier uses Swift's `replacingOccurrences(of:with:)` method to perform
/// the replacement operation. All occurrences of the target string are replaced
/// with the replacement string in each output string.
///
/// ## Example
///
/// ```swift
/// 
/// "User password is secret123".print(to: ConsolePrint().replacingOccurrences(of: "password", with: "***"))
/// // Output: "User *** is secret123"
/// ```
///
/// ## Use Cases
///
/// - **Content Sanitization**: Remove or mask sensitive information
/// - **Format Transformation**: Convert between different text formats
/// - **Text Processing**: Apply consistent text transformations
/// - **Debugging**: Replace debug tokens with readable text
public struct ReplacePrintOutputModifier: PrintOutputModifier {
    /// The target string to be replaced in all output.
    let target: String
    
    /// The replacement string to substitute for the target.
    let replacement: String
    
    /// Creates a new replace modifier with the specified target and replacement strings.
    ///
    /// - Parameters:
    ///   - target: The string to search for and replace.
    ///   - replacement: The string to substitute for each occurrence of the target.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modifier = ReplacePrintOutputModifier(
    ///     target: "localhost",
    ///     replacement: "production-server"
    /// )
    /// let result = modifier.modify("Connecting to localhost:8080")
    /// // Result: "Connecting to production-server:8080"
    /// ```
    public init(target: String, replacement: String) {
        self.target = target
        self.replacement = replacement
    }
    
    /// Modifies the input string by replacing all occurrences of the target string.
    ///
    /// This method performs a global string replacement, substituting every
    /// occurrence of the target string with the replacement string.
    ///
    /// - Parameter string: The original string to modify.
    /// - Returns: The string with all occurrences of the target replaced.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modifier = ReplacePrintOutputModifier(target: "foo", replacement: "bar")
    /// let result = modifier.modify("foo is not foo but foo")
    /// // Result: "bar is not bar but bar"
    /// ```
    public func modify(_ string: String) -> String {
        string.replacingOccurrences(of: target, with: replacement)
    }
}

/// Extension providing convenience methods for replacement modification.
public extension PrintOutput {
    /// Creates a version of this print output that replaces occurrences of a target string.
    ///
    /// This method provides a convenient way to apply string replacement to any print output
    /// without explicitly creating a modifier instance.
    ///
    /// - Parameters:
    ///   - target: The string to search for and replace.
    ///   - replacement: The string to substitute for each occurrence of the target.
    /// - Returns: A `ModifiedPrintOutput` that performs string replacement on all output.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let console = ConsolePrint().replacingOccurrences(of: "ERROR", with: "⚠️")
    /// "ERROR: File not found".print(to: console)
    /// // Output: "⚠️: File not found"
    /// ```
    func replacingOccurrences(of target: String, with replacement: String) -> ModifiedPrintOutput<Self> {
        modified(ReplacePrintOutputModifier(target: target, replacement: replacement))
    }
}
