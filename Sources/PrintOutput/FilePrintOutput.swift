//
//  FilePrintOutput.swift
//

import Foundation

/// Type alias for `FilePrintOutput` for convenience.
public typealias FilePrint = FilePrintOutput

/// A serial queue used for thread-safe file output operations.
///
/// This queue ensures that all file writes are serialized to prevent
/// data corruption when multiple threads are writing simultaneously.
private let filePrintSerialQueue = DispatchQueue(
    label: "com.swift-print-advance.FilePrintOutput",
    qos: .utility
)

/// A print output that writes to a file on disk.
///
/// `FilePrintOutput` provides a thread-safe way to write output to a file.
/// All write operations are serialized using a dedicated dispatch queue to prevent
/// data corruption when multiple threads are writing simultaneously.
///
/// This class manages a file handle and writes all output to the specified file.
/// It automatically creates the file if it doesn't exist and appends to existing files.
/// The file is properly closed when the instance is deallocated.
///
/// ## Platform Availability
///
/// - **iOS**: Available from iOS 10.0+
/// - **macOS**: Available from macOS 10.12+
/// - **tvOS**: Available from tvOS 10.0+
/// - **watchOS**: Not available (file operations not supported)
/// - **iOS Extensions**: Not available (document directory access restricted)
///
/// ## Thread Safety
///
/// This class is thread-safe. All write operations are automatically serialized
/// using an internal dispatch queue.
///
/// ## Example
///
/// ```swift
/// let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
/// let logFileURL = documentsURL.appendingPathComponent("app.log")
/// 
/// do {
///     let fileOutput = try FilePrint(url: logFileURL)
///     "Application started".print(to: fileOutput)
/// } catch {
///     print("Failed to create file output: \(error)")
/// }
/// ```
///
/// ## Error Handling
///
/// The initializer can throw errors if:
/// - The file cannot be created
/// - The file handle cannot be opened for writing
/// - The URL is invalid or points to a directory
@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
@available(watchOS, unavailable, message: "File operations are not supported on watchOS")
@available(iOSApplicationExtension, unavailable, message: "Document directory access is restricted in iOS Extensions")
public final class FilePrintOutput: PrintOutput {
    /// A convenient static instance that writes to a timestamped file in the documents directory.
    ///
    /// This static property provides a ready-to-use file output that writes to a file
    /// in the documents directory. The filename includes a timestamp to ensure uniqueness.
    ///
    /// - Note: This instance is created lazily on first access.
    /// - Warning: This will crash the application if the file cannot be created.
    public static let documentsFile: FilePrintOutput = {
        let timestamp: String = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
            return formatter.string(from: Date())
        }()
        
        let fileURL: URL = {
            URL.directory(.documentDirectory)
                .appendingPathComponent(timestamp)
                .appendingPathExtension("txt")
        }()
        
        do {
            return try FilePrintOutput(url: fileURL)
        } catch {
            fatalError("Failed to create FilePrintOutput at \(fileURL): \(error)")
        }
    }()
    
    /// The file handle used for writing operations.
    private let fileHandle: FileHandle
    
    /// The URL of the file being written to.
    ///
    /// This property provides access to the file URL for informational purposes.
    /// It can be useful for logging, debugging, or displaying the file location to users.
    let fileURL: URL
    
    /// Creates a new file print output that writes to the specified file.
    ///
    /// This initializer creates a new file output instance that will write to the file
    /// at the specified URL. If the file doesn't exist, it will be created. If it does
    /// exist, new content will be appended to the end of the file.
    ///
    /// - Parameter url: The URL of the file to write to.
    ///
    /// - Throws: 
    ///   - `URLError.badURL` if the URL is invalid
    ///   - `URLError.fileIsDirectory` if the URL points to a directory
    ///   - `URLError.cannotCreateFile` if the file cannot be created
    ///   - `URLError.resourceUnavailable` if the file handle cannot be opened
    ///
    /// ## Example
    ///
    /// ```swift
    /// let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    /// let logFileURL = documentsURL.appendingPathComponent("debug.log")
    /// 
    /// do {
    ///     let fileOutput = try FilePrintOutput(url: logFileURL)
    ///     // File is ready for writing
    /// } catch {
    ///     print("Failed to create file output: \(error)")
    /// }
    /// ```
    public init(url: URL) throws {
        try url.createFileIfNeeded()
        guard let fileHandle = try? FileHandle(forWritingTo: url) else {
            throw URLError(.resourceUnavailable)
        }
        self.fileURL = url
        self.fileHandle = fileHandle
    }
    
    /// Writes a string to the file.
    ///
    /// This method writes the provided string to the file. The write operation
    /// is performed asynchronously on a dedicated serial queue to ensure thread
    /// safety and prevent data corruption.
    ///
    /// - Parameter string: The string to write to the file.
    ///
    /// ## Implementation Details
    ///
    /// - The write operation is performed asynchronously
    /// - The file handle seeks to the end of the file before writing (append mode)
    /// - The string is converted to UTF-8 data before writing
    /// - Multiple concurrent calls are serialized automatically
    ///
    /// ## Example
    ///
    /// ```swift
    /// let fileOutput = try FilePrintOutput(url: logFileURL)
    /// fileOutput.write("Log entry: Application started\n")
    /// ```
    public func write(_ string: String) {
        filePrintSerialQueue.async { [fileHandle] in
            let data = Data(string.utf8)
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
        }
    }
    
    /// Cleans up resources when the instance is deallocated.
    ///
    /// This method ensures that the file handle is properly closed when the
    /// FilePrintOutput instance is deallocated, preventing resource leaks.
    deinit {
        fileHandle.closeFile()
    }
}

/// Private extension providing file management utilities.
///
/// This extension contains helper methods for file operations that are used
/// internally by FilePrint.
private extension URL {
    /// Returns the URL for the specified directory.
    ///
    /// - Parameter directory: The directory to get the URL for.
    /// - Returns: The URL for the specified directory.
    static func directory(_ directory: FileManager.SearchPathDirectory) -> URL {
        return FileManager.default.urls(for: directory, in: .userDomainMask)[0]
    }

    /// Checks if the file or directory exists at this URL.
    ///
    /// - Returns: `true` if the file or directory exists, `false` otherwise.
    var isExist: Bool {
        FileManager.default.fileExists(atPath: self.path)
    }
    
    /// Checks if this URL points to a directory.
    ///
    /// - Returns: `true` if this URL points to a directory, `false` otherwise.
    var isDirectory: Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: self.path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    
    /// Creates a file at this URL if it doesn't already exist.
    ///
    /// This method performs various checks before creating the file:
    /// - Ensures the URL is a file URL
    /// - Ensures the URL doesn't point to a directory
    /// - Creates the file only if it doesn't already exist
    ///
    /// - Throws:
    ///   - `URLError.badURL` if the URL is not a file URL
    ///   - `URLError.fileIsDirectory` if the URL points to a directory
    ///   - `URLError.cannotCreateFile` if the file cannot be created
    func createFileIfNeeded() throws {
        guard self.isFileURL else { throw URLError(.badURL) }
        guard !self.isDirectory else { throw URLError(.fileIsDirectory) }
        guard !self.isExist else { return }
        let isCreated = FileManager.default.createFile(
            atPath: self.path,
            contents: nil
        )
        guard isCreated else { throw URLError(.cannotCreateFile) }
    }
}

