//
//  FilterPrintOutputModifier.swift
//

/// A print output modifier that filters output strings based on a predicate.
///
/// `FilterPrintOutputModifier` allows you to conditionally include or exclude
/// output strings based on custom criteria. Strings that don't match the filter
/// criteria are replaced with empty strings, effectively suppressing them.
///
/// ## Overview
///
/// The modifier uses a closure-based predicate to determine whether each string
/// should be included in the output. If the predicate returns `true`, the string
/// is passed through unchanged. If it returns `false`, the string is replaced
/// with an empty string.
///
/// ## Example
///
/// ```swift
/// let console = ConsolePrint().filtered { string in
///     !string.contains("DEBUG")
/// }
/// 
/// "INFO: Application started".print(to: console)  // Prints
/// "DEBUG: Variable value = 42".print(to: console) // Suppressed
/// ```
///
/// ## Use Cases
///
/// - **Log Level Filtering**: Show only specific log levels
/// - **Content Filtering**: Suppress sensitive or unwanted content
/// - **Conditional Logging**: Enable/disable logging based on conditions
/// - **Debug Control**: Filter debug output in production builds
public struct FilterPrintOutputModifier: PrintOutputModifier {
    /// The predicate function that determines whether a string should be printed.
    let shouldPrint: (String) -> Bool
    
    /// Creates a new filter modifier with the specified predicate.
    ///
    /// - Parameter shouldPrint: A closure that takes a string and returns `true` if it should be printed, `false` otherwise.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modifier = FilterPrintOutputModifier { string in
    ///     string.hasPrefix("[ERROR]")
    /// }
    /// // Only strings starting with "[ERROR]" will be printed
    /// ```
    public init(shouldPrint: @escaping (String) -> Bool) {
        self.shouldPrint = shouldPrint
    }
    
    /// Modifies the input string by applying the filter predicate.
    ///
    /// This method evaluates the predicate against the input string. If the
    /// predicate returns `true`, the original string is returned unchanged.
    /// If the predicate returns `false`, an empty string is returned.
    ///
    /// - Parameter string: The original string to evaluate.
    /// - Returns: The original string if it passes the filter, otherwise an empty string.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modifier = FilterPrintOutputModifier { $0.count > 5 }
    /// let result1 = modifier.modify("Hello, World!")  // Returns "Hello, World!"
    /// let result2 = modifier.modify("Hi")              // Returns ""
    /// ```
    public func modify(_ string: String) -> String {
        shouldPrint(string) ? string : ""
    }
}

/// Extension providing convenience methods for filter modification.
public extension PrintOutput {
    /// Creates a filtered version of this print output.
    ///
    /// This method provides a convenient way to apply filtering to any print output
    /// without explicitly creating a modifier instance.
    ///
    /// - Parameter shouldPrint: A closure that determines whether each string should be printed.
    /// - Returns: A `ModifiedPrintOutput` that filters output based on the predicate.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let console = ConsolePrint().filtered { !$0.isEmpty }
    /// "Valid message".print(to: console)  // Prints
    /// "".print(to: console)               // Suppressed
    /// ```
    func filtered(using shouldPrint: @escaping (String) -> Bool) -> ModifiedPrintOutput<Self> {
        modified(FilterPrintOutputModifier(shouldPrint: shouldPrint))
    }
}
