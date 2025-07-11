//
//  Publisher+Print.swift
//

#if canImport(Combine)
import Combine

/// Extension providing enhanced print functionality for Combine publishers.
///
/// This extension adds convenient print methods to publishers whose output
/// conforms to `CustomStringConvertible`, allowing for flexible output
/// destinations beyond the standard console.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension Publisher where Output: CustomStringConvertible {
    
    /// Prints the elements of the publisher to the specified output destination.
    ///
    /// This method provides a way to redirect publisher output to any print output
    /// destination, such as files, buffers, or custom outputs. It's particularly
    /// useful for debugging reactive streams and logging publisher events.
    ///
    /// - Parameters:
    ///   - prefix: A string to prepend to each printed element. Defaults to empty string.
    ///   - output: The print output destination to write to.
    /// - Returns: A `Publishers.Print` publisher that forwards elements while printing them.
    ///
    /// ## Example
    ///
    /// ```swift
    /// 
    /// Just("Hello, Combine!")
    ///     .print(prefix: "[STREAM] ", to: FilePrint.documentsFile)
    ///     .print(to: ConsolePrint())
    ///     .sink { _ in }
    /// ```
    ///
    /// ## Use Cases
    ///
    /// - **Stream Debugging**: Monitor publisher values during development
    /// - **Logging**: Capture publisher output for analysis
    /// - **Multi-destination Output**: Send stream data to multiple outputs
    /// - **Custom Formatting**: Use modified outputs for formatted stream logging
    func print(prefix: String = "", to output: some PrintOutput) -> Publishers.Print<Self> {
        return self.print(prefix, to: output)
    }
}

#endif
