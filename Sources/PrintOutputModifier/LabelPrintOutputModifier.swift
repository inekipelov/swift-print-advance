//
//  LabelPrintOutputModifier.swift
//

/// A print output modifier that adds a label to output strings in key-value format.
///
/// `LabelPrintOutputModifier` formats output strings as key-value pairs with a
/// specified label. The label is converted to lowercase and combined with the
/// string using an equals sign, creating a consistent labeling format.
///
/// ## Overview
///
/// The modifier transforms input strings into the format `label = string` where
/// the label is automatically converted to lowercase for consistency. This is
/// particularly useful for debugging, logging, and displaying variable values.
///
/// ## Example
///
/// ```swift
/// let console = ConsolePrintOutput()
/// let labeled = console.modified(LabelPrintOutputModifier(label: "UserID"))
/// 
/// "12345".print(to: labeled)
/// // Output: "userid = 12345"
/// ```
///
/// ## Use Cases
///
/// - **Variable Debugging**: Display variable names with their values
/// - **Structured Logging**: Create consistent log entry formats
/// - **Configuration Display**: Show settings in key-value format
/// - **Data Inspection**: Label data fields for clarity
public struct LabelPrintOutputModifier: PrintOutputModifier {
    /// The label that will be prepended to all output in key-value format.
    let label: String
    
    /// Creates a new label modifier with the specified label.
    ///
    /// - Parameter label: The label to use for key-value formatting.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modifier = LabelPrintOutputModifier(label: "Temperature")
    /// let result = modifier.modify("25.5°C")
    /// // Result: "temperature = 25.5°C"
    /// ```
    public init(label: String) {
        self.label = label
    }
    
    /// Modifies the input string by formatting it as a labeled key-value pair.
    ///
    /// This method converts the label to lowercase and combines it with the
    /// input string using the format `label = string`.
    ///
    /// - Parameter string: The original string to modify.
    /// - Returns: The string formatted as a key-value pair.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modifier = LabelPrintOutputModifier(label: "Status")
    /// let result = modifier.modify("Active")
    /// // Result: "status = Active"
    /// ```
    public func modify(_ string: String) -> String {
        "\(label.lowercased()) = \(string)"
    }
}

/// Extension providing convenience methods for label modification.
public extension PrintOutput {
    /// Creates a labeled version of this print output.
    ///
    /// This method provides a convenient way to add labels to any print output
    /// without explicitly creating a modifier instance.
    ///
    /// - Parameter label: The label to use for key-value formatting.
    /// - Returns: A `ModifiedPrintOutput` that formats output as labeled key-value pairs.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let console = ConsolePrintOutput().labeled("Counter")
    /// "42".print(to: console)
    /// // Output: "counter = 42"
    /// ```
    func labeled(_ label: String) -> ModifiedPrintOutput<Self> {
        modified(LabelPrintOutputModifier(label: label))
    }
}
