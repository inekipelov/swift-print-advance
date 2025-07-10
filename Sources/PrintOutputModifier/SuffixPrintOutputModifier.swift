//
//  SuffixPrintOutputModifier.swift
//

/// A print output modifier that adds a suffix to output strings.
///
/// `SuffixPrintOutputModifier` appends a fixed string suffix to each output string.
/// This is useful for adding line terminators, closing brackets, or any other
/// trailing information to output messages.
///
/// ## Overview
///
/// The modifier simply concatenates each input string with the configured suffix.
/// The suffix is set during initialization and remains constant for the lifetime
/// of the modifier instance.
///
/// ## Example
///
/// ```swift
/// let console = ConsolePrintOutput()
/// let suffixed = console.modified(SuffixPrintOutputModifier(suffix: " [END]"))
/// 
/// "Processing complete".print(to: suffixed)
/// // Output: "Processing complete [END]"
/// ```
///
/// ## Use Cases
///
/// - **Line Terminators**: Add newlines or other terminators
/// - **Closing Markers**: Add closing brackets, tags, or markers
/// - **Decorative Elements**: Add trailing decorations or separators
/// - **Metadata**: Add trailing contextual information
public struct SuffixPrintOutputModifier: PrintOutputModifier {
    /// The suffix string that will be appended to all output.
    let suffix: String
    
    /// Creates a new suffix modifier with the specified suffix string.
    ///
    /// - Parameter suffix: The string to append to all output.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modifier = SuffixPrintOutputModifier(suffix: "\n")
    /// let result = modifier.modify("Log entry")
    /// // Result: "Log entry\n"
    /// ```
    public init(suffix: String) {
        self.suffix = suffix
    }
    
    /// Modifies the input string by appending the configured suffix.
    ///
    /// This method simply concatenates the input string with the suffix,
    /// with no additional formatting or spacing.
    ///
    /// - Parameter string: The original string to modify.
    /// - Returns: The string with the suffix appended.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modifier = SuffixPrintOutputModifier(suffix: " <<<")
    /// let result = modifier.modify("Important message")
    /// // Result: "Important message <<<"
    /// ```
    public func modify(_ string: String) -> String {
        string + suffix
    }
}

/// Extension providing convenience methods for suffix modification.
public extension PrintOutput {
    /// Creates a suffixed version of this print output.
    ///
    /// This method provides a convenient way to add a suffix to any print output
    /// without explicitly creating a modifier instance.
    ///
    /// - Parameter suffix: The string to append to all output.
    /// - Returns: A `ModifiedPrintOutput` that adds the suffix to all output.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let console = ConsolePrintOutput().suffixed(with: "\n")
    /// "Log message".print(to: console)
    /// // Output: "Log message\n"
    /// ```
    func suffixed(with suffix: String) -> ModifiedPrintOutput<Self> {
        modified(SuffixPrintOutputModifier(suffix: suffix))
    }
}
