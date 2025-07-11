//
//  PrefixPrintOutputModifier.swift
//

/// A print output modifier that adds a prefix to output strings.
///
/// `PrefixPrintOutputModifier` prepends a fixed string prefix to each output string.
/// This is useful for adding categories, log levels, or any other contextual
/// information to output messages.
///
/// ## Overview
///
/// The modifier simply concatenates the configured prefix with each input string.
/// The prefix is set during initialization and remains constant for the lifetime
/// of the modifier instance.
///
/// ## Example
///
/// ```swift
/// 
/// "Something went wrong".print(to: ConsolePrint().prefixed(with: "[ERROR] "))
/// // Output: "[ERROR] Something went wrong"
/// ```
///
/// ## Use Cases
///
/// - **Log Levels**: Add severity levels like `[INFO]`, `[WARNING]`, `[ERROR]`
/// - **Categories**: Add functional categories like `[AUTH]`, `[DB]`, `[NETWORK]`
/// - **Contexts**: Add contextual information like `[UserID: 123]`
/// - **Formatting**: Add visual separators or decorative elements
public struct PrefixPrintOutputModifier: PrintOutputModifier {
    /// The prefix string that will be prepended to all output.
    let prefix: String
    
    /// Creates a new prefix modifier with the specified prefix string.
    ///
    /// - Parameter prefix: The string to prepend to all output.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modifier = PrefixPrintOutputModifier(prefix: "[DEBUG] ")
    /// let result = modifier.modify("Variable value: 42")
    /// // Result: "[DEBUG] Variable value: 42"
    /// ```
    public init(prefix: String) {
        self.prefix = prefix
    }
    
    /// Modifies the input string by prepending the configured prefix.
    ///
    /// This method simply concatenates the prefix with the input string,
    /// with no additional formatting or spacing.
    ///
    /// - Parameter string: The original string to modify.
    /// - Returns: The string with the prefix prepended.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modifier = PrefixPrintOutputModifier(prefix: ">>> ")
    /// let result = modifier.modify("Important message")
    /// // Result: ">>> Important message"
    /// ```
    public func modify(_ string: String) -> String {
        prefix + string
    }
}

/// Extension providing convenience methods for prefix modification.
public extension PrintOutput {
    /// Creates a prefixed version of this print output.
    ///
    /// This method provides a convenient way to add a prefix to any print output
    /// without explicitly creating a modifier instance.
    ///
    /// - Parameter prefix: The string to prepend to all output.
    /// - Returns: A `ModifiedPrintOutput` that adds the prefix to all output.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let console = ConsolePrint().prefixed(with: "[LOG] ")
    /// "Application started".print(to: console)
    /// // Output: "[LOG] Application started"
    /// ```
    func prefixed(with prefix: String) -> ModifiedPrintOutput<Self> {
        modified(PrefixPrintOutputModifier(prefix: prefix))
    }
}
