//
//  AnyPrintOutput.swift
//

import Foundation

/// A type-erased print output that wraps any PrintOutput implementation.
///
/// `AnyPrintOutput` provides a way to hide the specific type of a print output
/// behind a common interface. This is useful when you need to work with different
/// print output types in a uniform way, or when you want to avoid exposing
/// the concrete type in your API.
///
/// ## Overview
///
/// This struct uses type erasure to wrap any type that conforms to `PrintOutput`,
/// allowing you to treat different print output implementations uniformly.
/// The wrapper forwards all write operations to the underlying print output.
///
/// ## Example
///
/// ```swift
/// let console = ConsolePrintOutput()
/// let anyOutput = AnyPrintOutput(console)
/// 
/// // Now you can use anyOutput without knowing the underlying type
/// "Hello, World!".print(to: anyOutput)
/// ```
///
/// ## Use Cases
///
/// - **API Design**: Hide implementation details from consumers
/// - **Collections**: Store different print output types in the same collection
/// - **Dependency Injection**: Pass print outputs without exposing concrete types
/// - **Testing**: Easily swap implementations in tests
///
/// ## Performance
///
/// Type erasure introduces minimal overhead. The wrapper simply forwards
/// method calls to the underlying implementation.
public struct AnyPrintOutput: PrintOutput {
    /// The type-erased write function that forwards to the underlying output.
    private let _write: (String) -> Void
    
    /// Creates a new type-erased print output wrapping the given output.
    ///
    /// This initializer takes any type that conforms to `PrintOutput` and
    /// wraps it in a type-erased container. The original output's write
    /// method is captured and will be called when this wrapper's write
    /// method is invoked.
    ///
    /// - Parameter output: The print output to wrap.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let fileOutput = try FilePrintOutput(url: logURL)
    /// let anyOutput = AnyPrintOutput(fileOutput)
    /// 
    /// // The concrete type is now hidden
    /// someFunction(output: anyOutput)
    /// ```
    public init<O: PrintOutput>(_ output: O) {
        var output = output
        self._write = { string in output.write(string) }
    }
    
    /// Writes a string to the wrapped print output.
    ///
    /// This method forwards the write operation to the underlying print output
    /// that was provided during initialization.
    ///
    /// - Parameter string: The string to write to the underlying output.
    public mutating func write(_ string: String) { _write(string) }
}

/// Extension providing convenience methods for type erasure.
extension PrintOutput {
    /// Creates a type-erased version of this print output.
    ///
    /// This computed property provides a convenient way to convert any
    /// print output to its type-erased equivalent.
    ///
    /// - Returns: An `AnyPrintOutput` wrapping this print output.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let console = ConsolePrintOutput()
    /// let erased = console.eraseToAnyPrintOutput
    /// 
    /// // erased is now of type AnyPrintOutput
    /// useOutput(erased)
    /// ```
    public var eraseToAnyPrintOutput: AnyPrintOutput {
        AnyPrintOutput(self)
    }
}
