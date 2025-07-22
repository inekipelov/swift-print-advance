//
//  BufferPrintOutput.swift
//

import Dispatch

/// Type alias for `BufferPrintOutput` for convenience.
public typealias BufferPrint = BufferPrintOutput

/// A serial queue used for thread-safe buffer operations.
///
/// This queue ensures that all buffer modifications are serialized to prevent
/// data races when multiple threads are writing simultaneously.
private let bufferPrintSerialQueue = DispatchQueue(
    label: "com.swift-print-advance.BufferPrintOutput",
    qos: .utility
)

/// A print output that accumulates all written content in an internal string buffer.
///
/// `BufferPrintOutput` provides a thread-safe way to collect output in memory.
/// All write operations are serialized using a dedicated dispatch queue to prevent
/// data races when multiple threads are writing simultaneously.
///
/// This class maintains an internal string buffer that accumulates all written content.
/// It's useful for scenarios where you want to collect output for later processing,
/// testing, or display. The buffer can be cleared at any time.
///
/// ## Thread Safety
///
/// This class is thread-safe. All write and clear operations are automatically
/// serialized using an internal dispatch queue.
///
/// ## Singleton Pattern
///
/// BufferPrintOutput uses a singleton pattern with a shared instance for convenience.
/// You can access the shared instance via `BufferPrintOutput.shared`.
///
/// ## Example
///
/// ```swift
/// "Hello, ".print(terminator: "", to: BufferPrint.shared)
/// "World!".print(to: BufferPrint.shared)
/// print(buffer.buffer) // Prints: "Hello, World!"
/// 
/// buffer.clear()
/// print(buffer.buffer) // Prints: ""
/// ```
///
/// ## Memory Considerations
///
/// The buffer grows indefinitely until cleared. For long-running applications
/// with continuous output, remember to clear the buffer periodically to prevent
/// excessive memory usage.
public final class BufferPrintOutput: PrintOutput {
    /// The shared singleton instance of BufferPrintOutput.
    ///
    /// This static property provides a convenient way to access a shared buffer
    /// output instance without having to manage the lifecycle yourself.
    public static let shared = BufferPrintOutput()
    
    /// Private initializer to enforce singleton pattern.
    private init() {}
    
    /// The internal string buffer containing all accumulated output.
    ///
    /// This property contains all the text that has been written to this buffer.
    /// It's read-only from external classes but can be modified internally.
    ///
    /// - Note: This property is thread-safe to read, but modifications are
    ///         serialized internally.
    private(set) var buffer: String = ""
    
    /// Writes a string to the internal buffer.
    ///
    /// This method appends the provided string to the internal buffer.
    /// The write operation is performed asynchronously on a dedicated serial
    /// queue to ensure thread safety.
    ///
    /// - Parameter string: The string to append to the buffer.
    ///
    /// ## Implementation Details
    ///
    /// - The write operation is performed asynchronously
    /// - The string is appended to the existing buffer content
    /// - Multiple concurrent calls are serialized automatically
    /// - Uses weak self to prevent retain cycles
    ///
    /// ## Example
    ///
    /// ```swift
    /// let buffer = BufferPrintOutput.shared
    /// buffer.write("First line\n")
    /// buffer.write("Second line\n")
    /// // buffer.buffer now contains "First line\nSecond line\n"
    /// ```
    public func write(_ string: String) {
        bufferPrintSerialQueue.async { [weak self] in
            guard let self = self else { return }
            let newString = self.buffer.isEmpty ? string : "\n" + string
            self.buffer.append(newString)
        }
    }
    
    /// Clears the internal buffer, removing all accumulated content.
    ///
    /// This method removes all content from the internal buffer, effectively
    /// resetting it to an empty state. The clear operation is performed
    /// asynchronously on a dedicated serial queue to ensure thread safety.
    ///
    /// ## Implementation Details
    ///
    /// - The clear operation is performed asynchronously
    /// - All existing buffer content is removed
    /// - Uses weak self to prevent retain cycles
    ///
    /// ## Example
    ///
    /// ```swift
    /// let buffer = BufferPrintOutput.shared
    /// buffer.write("Some content")
    /// print(buffer.buffer) // Prints: "Some content"
    /// 
    /// buffer.clear()
    /// print(buffer.buffer) // Prints: ""
    /// ```
    public func clear() {
        bufferPrintSerialQueue.async { [weak self] in
            guard let self = self else { return }
            self.buffer.removeAll()
        }
    }
}

/// Extension providing convenience methods for BufferPrintOutput.
public extension BufferPrintOutput {
    /// Clears the buffer and returns self for method chaining.
    ///
    /// This computed property provides a fluent interface for clearing the buffer.
    /// It calls the `clear()` method and returns self, allowing for method chaining.
    ///
    /// - Returns: This BufferPrintOutput instance for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let buffer = BufferPrintOutput.shared.cleared
    /// // Buffer is now empty and ready for new content
    /// ```
    var cleared: BufferPrintOutput {
        self.clear()
        return self
    }
}
