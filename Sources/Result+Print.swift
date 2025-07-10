//
//  Result+Print.swift
//

/// Extension providing print functionality for Result types.
///
/// This extension adds convenient print methods to Swift's `Result` type,
/// allowing for easy debugging and logging of operation results. It provides
/// a fluent interface that allows chaining operations after printing.
public extension Result {
    /// Prints this result to the standard output and returns self for chaining.
    ///
    /// This method prints the result's string representation to the standard output
    /// using Swift's built-in `print` function. The return value allows for method chaining.
    ///
    /// - Returns: This result for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result: Result<String, Error> = .success("Operation completed")
    /// let value = result.print().get()
    /// // Prints "success("Operation completed")" to console
    /// ```
    ///
    /// ## Use Cases
    ///
    /// - **Error Debugging**: Quickly see success/failure states
    /// - **Operation Tracing**: Track the flow of operations
    /// - **Development**: Temporary debugging during development
    /// - **Testing**: Verify expected result states
    @discardableResult
    func print() -> Self {
        Swift.print(self)
        return self
    }
    
    /// Prints this result to the specified print output and returns self for chaining.
    ///
    /// This method prints the result's string representation to the provided print output.
    /// The print output can be any type that conforms to the `PrintOutput` protocol,
    /// allowing for flexible output destinations.
    ///
    /// - Parameter output: The print output destination to write to.
    /// - Returns: This result for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let fileOutput = try FilePrintOutput(url: logURL)
    /// let result: Result<Int, Error> = .failure(MyError.invalidInput)
    /// 
    /// result
    ///     .print(to: fileOutput)
    ///     .mapError { error in
    ///         // Handle error
    ///         return error
    ///     }
    /// // Prints failure state to file and continues processing
    /// ```
    ///
    /// ## Use Cases
    ///
    /// - **Error Logging**: Log failures to files or external systems
    /// - **Success Tracking**: Record successful operations
    /// - **Multi-destination Logging**: Send results to multiple outputs
    /// - **Conditional Logging**: Use filtered outputs for specific result types
    @discardableResult
    func print(to output: some PrintOutput) -> Self {
        var output = output
        Swift.print(self, to: &output)
        return self
    }
}
