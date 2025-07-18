//
//  ConsolePrintOutput.swift
//

import Dispatch

/// Type alias for `ConsolePrintOutput` for convenience.
public typealias ConsolePrint = ConsolePrintOutput

/// A serial queue used for thread-safe console output operations.
///
/// This queue ensures that all console writes are serialized to prevent
/// interleaved output when multiple threads are writing simultaneously.
private let consolePrintSerialQueue = DispatchQueue(
    label: "com.swift-print-advance.ConsolePrintOutput",
    qos: .utility
)

/// A print output that writes to the standard output (console).
///
/// `ConsolePrintOutput` provides a thread-safe way to write output to the console.
/// All write operations are serialized using a dedicated dispatch queue to prevent
/// interleaved output when multiple threads are writing simultaneously.
///
/// This is one of the most commonly used print outputs. It writes directly to
/// the standard output stream, which typically displays in the console, terminal,
/// or Xcode debug area.
///
/// ## Thread Safety
///
/// This struct is thread-safe. All write operations are automatically serialized
/// using an internal dispatch queue.
///
/// ## Example
///
/// ```swift
/// "Hello, World!".print(to: ConsolePrint())
/// ```
///
/// ## Performance
///
/// Console output operations are performed asynchronously on a utility queue,
/// so the calling thread is not blocked. However, be aware that excessive
/// console output can impact performance.
public struct ConsolePrintOutput: PrintOutput {

    public init() {}

    /// Writes a string to the console.
    ///
    /// This method writes the provided string to the standard output stream.
    /// The write operation is performed asynchronously on a dedicated serial
    /// queue to ensure thread safety.
    ///
    /// - Parameter string: The string to write to the console.
    ///
    /// ## Implementation Details
    ///
    /// - The write operation is performed asynchronously
    /// - No terminator is added to the string (it's written as-is)
    /// - Multiple concurrent calls are serialized automatically
    public mutating func write(_ string: String) {
        consolePrintSerialQueue.async {
            Swift.print(string, terminator: "")
        }
    }
}
