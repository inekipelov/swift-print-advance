//
//  OSLogPrintOutput.swift
//

import Foundation
import os

/// A type alias for ``OSLogPrintOutput`` to provide a shorter name.
@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
typealias OSLogPrint = OSLogPrintOutput

/// A serial queue for thread-safe OSLog operations.
///
/// This queue ensures that all OSLog write operations are performed serially
/// to prevent race conditions and maintain consistent logging behavior.
private let osLogPrintSerialQueue = DispatchQueue(
    label: "com.swift-print-advance.OSLogPrintOutput",
    qos: .utility
)

/// A `PrintOutput` implementation that writes to the unified logging system (OSLog).
///
/// `OSLogPrintOutput` provides a way to output formatted print statements to Apple's
/// unified logging system, which can be viewed in Console.app or through the `log` command.
/// It supports different log levels, privacy settings, and custom subsystems and categories.
///
/// ## Usage
///
/// ```swift
/// // Use the default configuration
/// let output = OSLogPrintOutput.default
/// output.write("Hello, World!")
///
/// // Use predefined configurations
/// let errorOutput = OSLogPrintOutput.error
/// errorOutput.write("An error occurred")
///
/// // Create a custom configuration
/// let customOutput = OSLogPrintOutput(
///     subsystem: "com.myapp",
///     category: "Network",
///     level: .debug,
///     privacy: .private
/// )
/// customOutput.write("Network request completed")
/// ```
///
/// ## Predefined Configurations
///
/// The class provides several predefined static instances:
/// - ``default``: Uses `.default` log level
/// - ``info``: Uses `.info` log level
/// - ``debug``: Uses `.debug` log level
/// - ``error``: Uses `.error` log level
/// - ``fault``: Uses `.fault` log level
@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
public final class OSLogPrintOutput: PrintOutput {
    /// The default OSLog output with `.default` log level.
    public static let `default` = OSLogPrintOutput()
    
    /// An OSLog output configured for informational messages with `.info` log level.
    public static let info = OSLogPrintOutput(level: .info)
    
    /// An OSLog output configured for debug messages with `.debug` log level.
    public static let debug = OSLogPrintOutput(level: .debug)
    
    /// An OSLog output configured for error messages with `.error` log level.
    public static let error = OSLogPrintOutput(level: .error)
    
    /// An OSLog output configured for fault messages with `.fault` log level.
    public static let fault = OSLogPrintOutput(level: .fault)
    
    /// The subsystem identifier for the logger.
    private let subsystem: String
    
    /// The category identifier for the logger.
    private let category: String
    
    /// The log level for messages.
    private let level: OSLogType
    
    /// The privacy setting for logged messages.
    private let privacy: Privacy
    
    /// The logger instance created lazily with the configured subsystem and category.
    private lazy var logger = Logger(subsystem: subsystem, category: category)
    
    /// Creates a new OSLog print output with the specified configuration.
    ///
    /// - Parameters:
    ///   - subsystem: The subsystem identifier for the logger. Defaults to the main bundle identifier
    ///                or "com.swift-print-advance" if no bundle identifier is available.
    ///   - category: The category identifier for the logger. Defaults to "OSLogPrintOutput".
    ///   - level: The log level for messages. Defaults to `.default`.
    ///   - privacy: The privacy setting for logged messages. Defaults to `.public`.
    public init(
        subsystem: String = Bundle.main.bundleIdentifier ?? "com.swift-print-advance",
        category: String = "OSLogPrintOutput",
        level: OSLogType = .default,
        privacy: Privacy = .public
    ) {
        self.subsystem = subsystem
        self.category = category
        self.level = level
        self.privacy = privacy
    }
    
    /// Writes a string to the OSLog system.
    ///
    /// This method asynchronously writes the provided string to the unified logging system
    /// using the configured log level and privacy settings.
    ///
    /// - Parameter string: The string to write to the log.
    public func write(_ string: String) {
        osLogPrintSerialQueue.async { [weak self] in
            guard let self = self else { return }
            self.log(string)
        }
    }
}

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
public extension OSLogPrintOutput {
    /// Privacy levels for OSLog messages.
    ///
    /// This enum defines how sensitive information should be treated in log messages:
    /// - Use ``auto`` to let the system decide the privacy level
    /// - Use ``private`` to redact sensitive information in logs
    /// - Use ``sensitive`` for extremely sensitive information that should always be redacted
    /// - Use ``public`` for information that's safe to display in logs
    enum Privacy: Equatable {
        /// Automatic privacy determination based on the data type.
        case auto
        /// Private data that should be redacted in logs.
        case `private`
        /// Sensitive data that should always be redacted.
        case sensitive
        /// Public data that's safe to display in logs.
        case `public`
    }
}

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
public extension OSLogPrintOutput {
    /// Creates a new OSLog print output with a different category.
    ///
    /// This method returns a new instance with the specified category while
    /// preserving all other configuration settings. If the new category is
    /// the same as the current one, it returns the same instance.
    ///
    /// - Parameter newCategory: The new category identifier for the logger.
    /// - Returns: A new `OSLogPrintOutput` instance with the specified category,
    ///            or the same instance if the category hasn't changed.
    func withCategory(_ newCategory: String) -> OSLogPrintOutput {
        guard newCategory != category else { return self }
        return OSLogPrintOutput(
            subsystem: subsystem,
            category: newCategory,
            level: level,
            privacy: privacy
        )
    }
    
    /// Creates a new OSLog print output with a different log level.
    ///
    /// This method returns a new instance with the specified log level while
    /// preserving all other configuration settings. If the new level is
    /// the same as the current one, it returns the same instance.
    ///
    /// - Parameter newLevel: The new log level for messages.
    /// - Returns: A new `OSLogPrintOutput` instance with the specified log level,
    ///            or the same instance if the level hasn't changed.
    func withLevel(_ newLevel: OSLogType) -> OSLogPrintOutput {
        guard newLevel != level else { return self }
        return OSLogPrintOutput(
            subsystem: subsystem,
            category: category,
            level: newLevel,
            privacy: privacy
        )
    }
    
    /// Creates a new OSLog print output with a different privacy setting.
    ///
    /// This method returns a new instance with the specified privacy setting while
    /// preserving all other configuration settings. If the new privacy setting is
    /// the same as the current one, it returns the same instance.
    ///
    /// - Parameter newPrivacy: The new privacy setting for logged messages.
    /// - Returns: A new `OSLogPrintOutput` instance with the specified privacy setting,
    ///            or the same instance if the privacy setting hasn't changed.
    func withPrivacy(_ newPrivacy: Privacy) -> OSLogPrintOutput {
        guard newPrivacy != privacy else { return self }
        return OSLogPrintOutput(
            subsystem: subsystem,
            category: category,
            level: level,
            privacy: newPrivacy
        )
    }
}

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
private extension OSLogPrintOutput {
    /// Logs a string with the configured privacy level.
    ///
    /// This method applies the configured privacy setting to the log message
    /// and writes it to the unified logging system using the configured log level.
    ///
    /// - Parameter string: The string to log.
    func log(_ string: String) {
        switch privacy {
        case .auto:
            logger.log(level: level, "\(string, privacy: .auto)")
        case .private:
            logger.log(level: level, "\(string, privacy: .private)")
        case .sensitive:
            logger.log(level: level, "\(string, privacy: .sensitive)")
        case .public:
            logger.log(level: level, "\(string, privacy: .public)")
        }
    }
}
