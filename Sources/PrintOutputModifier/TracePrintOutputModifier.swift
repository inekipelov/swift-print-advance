//
//  TracePrintOutputModifier.swift
//

import Foundation

/// A print output modifier that adds source code location information to output strings.
///
/// `TracePrintOutputModifier` adds debugging information including the filename,
/// line number, and function name to each output string. This is invaluable for
/// debugging and tracing code execution flow.
///
/// ## Overview
///
/// The modifier captures source code location information and formats it as
/// `[filename -> line:function] string`. This helps developers quickly identify
/// where output is coming from in their codebase.
///
/// ## Example
///
/// ```swift
/// let console = ConsolePrintOutput()
/// let traced = console.trace()
/// 
/// "Debug message".print(to: traced)
/// // Output: "[MyFile.swift -> 42:debugFunction()] Debug message"
/// ```
///
/// ## Use Cases
///
/// - **Debugging**: Track where output is generated in code
/// - **Error Tracing**: Identify the source of error messages
/// - **Performance Monitoring**: Track execution flow through functions
/// - **Development**: Temporary debugging aids during development
public struct TracePrintOutputModifier: PrintOutputModifier {
    /// The function name where the modifier was created.
    let function: String
    
    /// The file path where the modifier was created.
    let file: String
    
    /// The line number where the modifier was created.
    let line: Int

    /// Creates a new trace modifier with the specified source location information.
    ///
    /// - Parameters:
    ///   - function: The function name where the modifier is created.
    ///   - file: The file path where the modifier is created.
    ///   - line: The line number where the modifier is created.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modifier = TracePrintOutputModifier(
    ///     function: "myFunction()",
    ///     file: "/path/to/MyFile.swift",
    ///     line: 42
    /// )
    /// ```
    public init(function: String, file: String, line: Int) {
        self.function = function
        self.file = file
        self.line = line
    }

    /// Modifies the input string by prepending source location information.
    ///
    /// This method extracts the filename from the full file path and formats
    /// the trace information as `[filename -> line:function] string`.
    ///
    /// - Parameter string: The original string to modify.
    /// - Returns: The string with source location information prepended.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let modifier = TracePrintOutputModifier(
    ///     function: "calculate()",
    ///     file: "/Users/dev/MyApp/Calculator.swift",
    ///     line: 25
    /// )
    /// let result = modifier.modify("Result: 42")
    /// // Result: "[Calculator.swift -> 25:calculate()] Result: 42"
    /// ```
    public func modify(_ string: String) -> String {
        let fileName = (file as NSString).lastPathComponent
        return "[\(fileName) -> \(line):\(function)] \(string)"
    }
}

/// Extension providing convenience methods for trace modification.
public extension PrintOutput {
    /// Creates a traced version of this print output with automatic source location capture.
    ///
    /// This method provides a convenient way to add source location tracing to any
    /// print output. It automatically captures the current source location using
    /// Swift's `#function`, `#file`, and `#line` compiler directives.
    ///
    /// - Parameters:
    ///   - function: The function name. Defaults to the current function via `#function`.
    ///   - file: The file path. Defaults to the current file via `#file`.
    ///   - line: The line number. Defaults to the current line via `#line`.
    /// - Returns: A `ModifiedPrintOutput` that adds source location information to all output.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func debugFunction() {
    ///     let console = ConsolePrintOutput().trace()
    ///     "Debug info".print(to: console)
    ///     // Output: "[MyFile.swift -> 15:debugFunction()] Debug info"
    /// }
    /// ```
    func trace(
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) -> ModifiedPrintOutput<Self> {
        self.modified(
            TracePrintOutputModifier(
                function: function,
                file: file,
                line: line
            )
        )
    }
}
