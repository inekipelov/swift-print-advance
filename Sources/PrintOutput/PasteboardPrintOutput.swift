//
//  PasteboardPrintOutput.swift
//

#if os(iOS) || os(tvOS)
import UIKit
/// Type alias for the system pasteboard, unified across platforms.
public typealias SystemPasteboard = UIPasteboard
#elseif os(macOS)
import AppKit
/// Type alias for the system pasteboard, unified across platforms.
public typealias SystemPasteboard = NSPasteboard
#endif

/// Type alias for `PasteboardPrintOutput` for convenience.
public typealias PasteboardPrint = PasteboardPrintOutput

/// A serial queue used for thread-safe pasteboard operations.
///
/// This queue ensures that all pasteboard operations are serialized to prevent
/// data races when multiple threads are writing simultaneously.
private let pasteboardPrintSerialQueue = DispatchQueue(
    label: "com.swift-print-advance.PasteboardPrintOutput",
    qos: .utility
)

/// A print output that writes content to the system pasteboard (clipboard).
///
/// `PasteboardPrintOutput` provides a thread-safe way to write output to the
/// system pasteboard. All write operations are serialized and updates to the
/// pasteboard are debounced to prevent excessive clipboard updates.
///
/// This class maintains an internal buffer that accumulates all written content
/// and periodically updates the system pasteboard. Updates are debounced with
/// a 0.1 second delay to prevent excessive clipboard updates when multiple
/// writes occur in quick succession.
///
/// ## Platform Availability
///
/// - **iOS**: Available from iOS 9.0+
/// - **macOS**: Available from macOS 10.13+
/// - **tvOS**: Not available (pasteboard operations not practical)
/// - **watchOS**: Not available (pasteboard operations not supported)
/// - **iOS Extensions**: Not available (pasteboard access restricted)
///
/// ## Thread Safety
///
/// This class is thread-safe. All write and clear operations are automatically
/// serialized using an internal dispatch queue.
///
/// ## Example
///
/// ```swift
/// "Hello, ".print(terminator: "", to: PasteboardPrint.general)
/// "World!".print(to: PasteboardPrint.general)
/// // After 0.1 seconds, "Hello, World!" will be available in the system clipboard
/// ```
///
/// ## Performance Considerations
///
/// Pasteboard updates are debounced and performed on the main queue to ensure
/// compatibility with system clipboard operations. Excessive writes may cause
/// a slight delay in clipboard updates.
@available(iOS 9, macOS 10.13, *)
@available(watchOS, unavailable, message: "Pasteboard operations are not supported on watchOS")
@available(tvOS, unavailable, message: "Pasteboard operations are not practical on tvOS")
@available(iOSApplicationExtension, unavailable, message: "Pasteboard access is restricted in iOS Extensions")
public final class PasteboardPrintOutput: PrintOutput {
    /// A convenient static instance that uses the general system pasteboard.
    ///
    /// This static property provides a ready-to-use pasteboard output that writes
    /// to the system's general pasteboard (clipboard).
    static let general = PasteboardPrint(pasteboard: .general)
    
    /// The internal string buffer containing all accumulated output.
    ///
    /// This property contains all the text that has been written to this pasteboard
    /// output. It's read-only from external classes but can be modified internally.
    private(set) var buffer: String = ""
    
    /// The system pasteboard instance used for clipboard operations.
    ///
    /// This property holds a reference to the pasteboard that will receive
    /// the accumulated output content.
    let pasteboard: SystemPasteboard
    
    /// Creates a new pasteboard print output with the specified pasteboard.
    ///
    /// - Parameter pasteboard: The system pasteboard to write to. Defaults to the general pasteboard.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Using the default general pasteboard
    /// let output1 = PasteboardPrintOutput()
    /// 
    /// // Using a custom pasteboard (iOS)
    /// let output2 = PasteboardPrintOutput(pasteboard: .withUniqueName())
    /// ```
    public init(pasteboard: SystemPasteboard = .general) {
        self.pasteboard = pasteboard
    }
    
    /// Writes a string to the internal buffer and schedules a pasteboard update.
    ///
    /// This method appends the provided string to the internal buffer and schedules
    /// a debounced update to the system pasteboard. The pasteboard update occurs
    /// after a 0.1 second delay to prevent excessive clipboard updates.
    ///
    /// - Parameter string: The string to append to the buffer and eventually copy to the pasteboard.
    ///
    /// ## Implementation Details
    ///
    /// - The write operation is performed asynchronously
    /// - The string is appended to the existing buffer content
    /// - Pasteboard updates are debounced with a 0.1 second delay
    /// - Multiple concurrent calls are serialized automatically
    /// - Uses weak self to prevent retain cycles
    public func write(_ string: String) {
        pasteboardPrintSerialQueue.async { [weak self] in
            guard let self = self else { return }
            self.buffer.append(string)
            self.pendingUpdatePasteboard(with: self.buffer)
        }
    }
    
    /// Clears the internal buffer and pasteboard content.
    ///
    /// This method removes all content from the internal buffer and clears
    /// the system pasteboard. The clear operation is performed asynchronously
    /// on a dedicated serial queue to ensure thread safety.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let pasteboard = PasteboardPrintOutput.general
    /// pasteboard.write("Some content")
    /// pasteboard.clear()
    /// // Both buffer and system clipboard are now empty
    /// ```
    public func clear() {
        pasteboardPrintSerialQueue.async { [weak self] in
            guard let self = self else { return }
            self.buffer = ""
            self.pendingUpdatePasteboard()
        }
    }

    /// The currently pending pasteboard update work item.
    ///
    /// This property tracks the current debounced pasteboard update operation.
    /// It's used to cancel pending updates when new content is written.
    private var pendingPasteboardUpdate: DispatchWorkItem?
}

/// Private extension containing pasteboard update implementation details.
private extension PasteboardPrintOutput {
    /// Schedules a debounced pasteboard update with the provided content.
    ///
    /// This method cancels any pending pasteboard update and schedules a new one
    /// with a 0.1 second delay. This prevents excessive clipboard updates when
    /// multiple writes occur in quick succession.
    ///
    /// - Parameter content: The content to write to the pasteboard. Defaults to empty string.
    func pendingUpdatePasteboard(with content: String = "") {
        self.pendingPasteboardUpdate?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.updatePasteboard(with: content)
        }
        self.pendingPasteboardUpdate = workItem
        DispatchQueue.main
            .asyncAfter(deadline: .now() + 0.1, execute: workItem)
    }
    
    /// Updates the system pasteboard with the provided content.
    ///
    /// This method performs the actual pasteboard update operation. The implementation
    /// varies by platform to accommodate different pasteboard APIs.
    ///
    /// - Parameter content: The content to write to the pasteboard. Defaults to empty string.
    func updatePasteboard(with content: String = "") {
#if os(iOS)
        pasteboard.string = content
#elseif os(macOS)
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
#endif
    }
}

/// Extension providing convenience methods for PasteboardPrintOutput.
public extension PasteboardPrintOutput {
    /// Clears the buffer and pasteboard, then returns self for method chaining.
    ///
    /// This computed property provides a fluent interface for clearing the pasteboard.
    /// It calls the `clear()` method and returns self, allowing for method chaining.
    ///
    /// - Returns: This PasteboardPrintOutput instance for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let pasteboard = PasteboardPrintOutput.general.cleared
    /// // Buffer and clipboard are now empty and ready for new content
    /// ```
    var cleared: PasteboardPrintOutput {
        self.clear()
        return self
    }
}
