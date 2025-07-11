//
//  UppercasePrintOutputModifier.swift
//

/// A print output modifier that converts output strings to uppercase.
///
/// `UppercasePrintOutputModifier` transforms all output strings to uppercase letters.
/// This is useful for emphasizing output, creating uniform formatting, or meeting
/// specific display requirements.
///
/// The modifier uses Swift's `uppercased()` method to convert all alphabetic
/// characters in the input string to their uppercase equivalents. Non-alphabetic
/// characters remain unchanged.
///
/// ## Example
///
/// ```swift
/// 
/// "Hello, World!".print(to: ConsolePrint().uppercased)
/// // Output: "HELLO, WORLD!"
/// ```
///
/// ## Use Cases
///
/// - **Emphasis**: Make important messages stand out
/// - **Consistency**: Ensure uniform case formatting
/// - **Legacy Systems**: Interface with systems that expect uppercase
/// - **Display Requirements**: Meet specific UI or output formatting needs
public struct UppercasePrintOutputModifier: PrintOutputModifier {
    /// Creates a new uppercase modifier.
    ///
    /// This initializer creates a modifier that will convert all input strings
    /// to uppercase using Swift's built-in string uppercasing functionality.
    public init() {}
    
    /// Modifies the input string by converting it to uppercase.
    ///
    /// This method converts all alphabetic characters in the input string
    /// to their uppercase equivalents. Non-alphabetic characters such as
    /// numbers, punctuation, and symbols remain unchanged.
    ///
    /// - Parameter string: The original string to modify.
    /// - Returns: The string converted to uppercase.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modifier = UppercasePrintOutputModifier()
    /// let result = modifier.modify("Hello, World! 123")
    /// // Result: "HELLO, WORLD! 123"
    /// ```
    public func modify(_ string: String) -> String {
        string.uppercased()
    }
}

/// Extension providing convenience methods for uppercase modification.
public extension PrintOutput {
    /// Creates an uppercased version of this print output.
    ///
    /// This computed property provides a convenient way to convert all output
    /// to uppercase without explicitly creating a modifier instance.
    ///
    /// - Returns: A `ModifiedPrintOutput` that converts all output to uppercase.
    ///
    /// ## Example
    ///
    /// ```swift
    /// "debug message".print(to: ConsolePrint().uppercased)
    /// // Output: "DEBUG MESSAGE"
    /// ```
    var uppercased: ModifiedPrintOutput<Self> {
        modified(UppercasePrintOutputModifier())
    }
}
