//
//  CustomStringConvertible+Print.swift
//

/// Extension providing print functionality for any type that conforms to CustomStringConvertible.
///
/// This extension adds convenient print methods to all types that can be converted to a string.
/// It provides a fluent interface that allows chaining operations after printing.
public extension CustomStringConvertible {
    /// Prints this object to the standard output and returns self for chaining.
    ///
    /// This method prints the object's string representation to the standard output
    /// using Swift's built-in `print` function. The return value allows for method chaining.
    ///
    /// - Returns: This object for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let value = 42
    /// let result = value.print().description
    /// // Prints "42" to console and continues with the chain
    /// ```
    ///
    /// ## Use Cases
    ///
    /// - **Debugging**: Quick debugging output in method chains
    /// - **Logging**: Simple logging without breaking the flow
    /// - **Development**: Temporary print statements during development
    @discardableResult
    func print() -> Self {
        Swift.print(self)
        return self
    }
    
    /// Prints this object to the specified print output and returns self for chaining.
    ///
    /// This method prints the object's string representation to the provided print output.
    /// The print output can be any type that conforms to the `PrintOutput` protocol,
    /// allowing for flexible output destinations.
    ///
    /// - Parameter output: The print output destination to write to.
    /// - Returns: This object for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let console = ConsolePrintOutput()
    /// let fileOutput = try FilePrintOutput(url: logURL)
    /// 
    /// "Important message"
    ///     .print(to: console)
    ///     .print(to: fileOutput)
    /// // Prints to both console and file
    /// ```
    ///
    /// ## Use Cases
    ///
    /// - **Multi-destination Logging**: Send output to multiple destinations
    /// - **Custom Formatting**: Use modified print outputs for formatting
    /// - **Testing**: Capture output in test environments
    /// - **File Logging**: Direct output to files or other destinations
    @discardableResult
    func print(to output: some PrintOutput) -> Self {
        var output = output
        Swift.print(self, to: &output)
        return self
    }
}
