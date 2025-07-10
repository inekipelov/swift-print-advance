# Tutorial: Building a Logging System

Learn how to build a comprehensive logging system using PrintAdvance.

## Overview

In this tutorial, you'll build a logging system that demonstrates the power and flexibility of PrintAdvance. You'll create different output destinations, apply modifiers, and integrate with SwiftUI and Combine.

## What You'll Build

By the end of this tutorial, you'll have:

- A multi-destination logging system
- Custom log levels and formatting
- SwiftUI integration for debugging views
- Combine integration for debugging data flow
- Performance-optimized logging for production

## Prerequisites

- Xcode 12.0 or later
- Basic knowledge of Swift
- Familiarity with SwiftUI and Combine (for later sections)

## Step 1: Basic Setup

First, add PrintAdvance to your project and create a simple logger:

```swift
import PrintAdvance

// Basic logging
"Application started".print()
```

## Step 2: Create Multiple Output Destinations

Create different outputs for different types of logs:

```swift
// Console output for development
let consoleOutput = ConsolePrintOutput()

// File output for persistent logging
let logFileURL = FileManager.default
    .urls(for: .documentDirectory, in: .userDomainMask)[0]
    .appendingPathComponent("app.log")
let fileOutput = try FilePrintOutput(url: logFileURL)

// System log for production
let systemOutput = OSLogPrintOutput(
    subsystem: "com.yourapp.logging",
    category: "general"
)
```

## Step 3: Add Log Levels

Create a structured logging system with levels:

```swift
enum LogLevel: String, CaseIterable {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    
    var icon: String {
        switch self {
        case .debug: return "🔍"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "❌"
        }
    }
}

class Logger {
    private let outputs: [PrintOutput]
    
    init(outputs: [PrintOutput]) {
        self.outputs = outputs
    }
    
    func log(_ message: String, level: LogLevel) {
        let formattedMessage = "\(level.icon) [\(level.rawValue)] \(message)"
        
        for var output in outputs {
            formattedMessage.print(to: output)
        }
    }
}
```

## Step 4: Apply Modifiers

Enhance your logs with timestamps and formatting:

```swift
// Create modified outputs
let timestampedConsole = TimestampPrintOutputModifier(output: consoleOutput)
let labeledFile = LabelPrintOutputModifier(label: "APP", output: fileOutput)
let filteredSystem = FilterPrintOutputModifier(output: systemOutput) { message in
    !message.contains("DEBUG")  // Filter out debug messages from system log
}

// Create logger with enhanced outputs
let logger = Logger(outputs: [timestampedConsole, labeledFile, filteredSystem])

// Test the logger
logger.log("Application initialized", level: .info)
logger.log("User authenticated", level: .debug)
logger.log("Network error occurred", level: .error)
```

## Step 5: SwiftUI Integration

Add logging to your SwiftUI views:

```swift
struct ContentView: View {
    @State private var username = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .print()  // Debug text field value
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Login") {
                isLoading = true
                username.print()  // Log the username being used
                performLogin()
            }
            .disabled(username.isEmpty)
            
            if isLoading {
                ProgressView("Logging in...")
                    .print()  // Debug loading state
            }
        }
        .padding()
        .onChange(of: username) { newValue in
            "Username changed to: \(newValue)".print()
        }
    }
    
    private func performLogin() {
        // Simulate login
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            logger.log("Login completed for user: \(username)", level: .info)
        }
    }
}
```

## Step 6: Combine Integration

Add logging to your data flow:

```swift
import Combine

class AuthService: ObservableObject {
    @Published var isAuthenticated = false
    private var cancellables = Set<AnyCancellable>()
    
    func login(username: String, password: String) -> AnyPublisher<Bool, Error> {
        URLSession.shared.dataTaskPublisher(for: loginURL)
            .print(prefix: "Auth API")  // Debug API calls
            .map(\.data)
            .print(prefix: "Response Data")  // Debug responses
            .decode(type: AuthResponse.self, decoder: JSONDecoder())
            .print(prefix: "Decoded Response")  // Debug decoded data
            .map { response in
                response.isSuccess
            }
            .handleEvents(
                receiveOutput: { success in
                    if success {
                        logger.log("Authentication successful", level: .info)
                    } else {
                        logger.log("Authentication failed", level: .warning)
                    }
                },
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        logger.log("Authentication error: \(error)", level: .error)
                    }
                }
            )
            .eraseToAnyPublisher()
    }
}
```

## Step 7: Performance Optimization

Optimize logging for production:

```swift
class ProductionLogger {
    private let bufferOutput: BufferPrintOutput
    private let backgroundQueue = DispatchQueue(label: "logging", qos: .utility)
    
    init(fileURL: URL) throws {
        // Buffer logs and flush periodically
        self.bufferOutput = BufferPrintOutput(
            bufferSize: 100,
            flushInterval: 10.0,
            underlyingOutput: try FilePrintOutput(url: fileURL)
        )
    }
    
    func log(_ message: String, level: LogLevel) {
        // Only log important messages in production
        guard level != .debug || isDebugMode else { return }
        
        backgroundQueue.async {
            let timestamp = ISO8601DateFormatter().string(from: Date())
            let formattedMessage = "[\(timestamp)] \(level.rawValue): \(message)"
            formattedMessage.print(to: self.bufferOutput)
        }
    }
    
    private var isDebugMode: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
```

## Step 8: Error Handling and Recovery

Add robust error handling to your logging system:

```swift
extension Logger {
    func logError<T>(_ result: Result<T, Error>, context: String) {
        switch result {
        case .success(let value):
            log("✅ \(context): Success - \(value)", level: .info)
        case .failure(let error):
            log("❌ \(context): Error - \(error.localizedDescription)", level: .error)
        }
    }
    
    func logPerformance<T>(operation: String, block: () throws -> T) rethrows -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        defer {
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            log("⏱️ \(operation) took \(String(format: "%.3f", timeElapsed))s", level: .debug)
        }
        
        log("🚀 Starting \(operation)", level: .debug)
        return try block()
    }
}
```

## Next Steps

Now that you have a comprehensive logging system, you can:

- Add log rotation for file outputs
- Implement remote logging capabilities
- Create custom output modifiers for your specific needs
- Add log analysis and alerting
- Integrate with crash reporting systems

## Complete Example

Here's the complete logging system you've built:

```swift
import PrintAdvance
import SwiftUI
import Combine

// Production-ready logging system
class AppLogger {
    static let shared = AppLogger()
    
    private let logger: Logger
    private let productionLogger: ProductionLogger?
    
    private init() {
        var outputs: [PrintOutput] = []
        
        #if DEBUG
        // Development outputs
        let console = TimestampPrintOutputModifier(
            output: ConsolePrintOutput()
        )
        outputs.append(console)
        #endif
        
        // File output for all builds
        if let documentsURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask).first {
            let logURL = documentsURL.appendingPathComponent("app.log")
            
            do {
                let fileOutput = try FilePrintOutput(url: logURL)
                let labeledOutput = LabelPrintOutputModifier(
                    label: "APP",
                    output: fileOutput
                )
                outputs.append(labeledOutput)
                
                // Production logger with buffering
                self.productionLogger = try ProductionLogger(fileURL: logURL)
            } catch {
                print("Failed to create file logger: \(error)")
                self.productionLogger = nil
            }
        } else {
            self.productionLogger = nil
        }
        
        // System logger for production
        #if !DEBUG
        let systemOutput = OSLogPrintOutput(
            subsystem: Bundle.main.bundleIdentifier ?? "com.app",
            category: "general"
        )
        outputs.append(systemOutput)
        #endif
        
        self.logger = Logger(outputs: outputs)
    }
    
    func debug(_ message: String) {
        logger.log(message, level: .debug)
    }
    
    func info(_ message: String) {
        logger.log(message, level: .info)
    }
    
    func warning(_ message: String) {
        logger.log(message, level: .warning)
    }
    
    func error(_ message: String) {
        logger.log(message, level: .error)
    }
}

// Usage throughout your app
AppLogger.shared.info("Application launched")
AppLogger.shared.debug("Debug information")
AppLogger.shared.error("Something went wrong")
```

This tutorial showed you how to build a production-ready logging system using PrintAdvance. The system handles multiple output destinations, includes performance optimizations, and integrates seamlessly with SwiftUI and Combine.
