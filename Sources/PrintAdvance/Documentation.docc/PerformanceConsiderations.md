# Performance Considerations

Optimize your print output for performance in production environments.

## Overview

While PrintAdvance is designed to be lightweight, understanding performance implications is crucial for production applications, especially those with high-frequency logging.

## Performance Best Practices

### Use Conditional Compilation

Exclude debug prints from release builds:

```swift
#if DEBUG
"Debug information".print()
#endif

// Or create a conditional wrapper
func debugPrint<T: CustomStringConvertible>(_ value: T) {
    #if DEBUG
    value.print()
    #endif
}
```

### Lazy String Evaluation

Avoid expensive string operations when they might not be used:

```swift
// Instead of this:
let expensiveString = computeExpensiveDebugInfo()
expensiveString.print()

// Do this:
#if DEBUG
let expensiveString = computeExpensiveDebugInfo()
expensiveString.print()
#endif
```

### Buffer Output for High-Frequency Logging

Use ``BufferPrintOutput`` for frequent logging:

```swift
let bufferedOutput = BufferPrintOutput(
    bufferSize: 100,
    flushInterval: 5.0,  // Flush every 5 seconds
    underlyingOutput: FilePrintOutput(url: logFileURL)
)

// High-frequency logging
for i in 0..<1000 {
    "Processing item \(i)".print(to: bufferedOutput)
}
```

### Asynchronous Logging

For I/O-heavy outputs, consider async processing:

```swift
struct AsyncFileOutput: PrintOutput {
    private let queue = DispatchQueue(label: "logging", qos: .utility)
    private let fileURL: URL
    
    init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    mutating func write(_ string: String) {
        queue.async {
            // Perform file I/O on background queue
            try? string.appendToFile(at: self.fileURL)
        }
    }
}
```

## Memory Management

### Avoid Retain Cycles

Be careful with closures in custom outputs:

```swift
class LoggingManager {
    private var output: PrintOutput
    
    init() {
        // Potential retain cycle - avoid this
        self.output = FilterPrintOutputModifier(
            output: ConsolePrintOutput()
        ) { [weak self] message in
            return self?.shouldLog(message) ?? false
        }
    }
    
    private func shouldLog(_ message: String) -> Bool {
        // Logging logic
        return true
    }
}
```

### Release Resources

Implement proper cleanup for file handles and other resources:

```swift
struct ManagedOutput: PrintOutput {
    private var fileHandle: FileHandle?
    
    init(fileURL: URL) throws {
        self.fileHandle = try FileHandle(forWritingTo: fileURL)
    }
    
    mutating func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        fileHandle?.write(data)
    }
    
    func close() {
        fileHandle?.closeFile()
        fileHandle = nil
    }
}
```

## Benchmarking

### Measure Impact

Profile your printing operations:

```swift
import os.signpost

let log = OSLog(subsystem: "com.yourapp.performance", category: "printing")

func measurePrintPerformance() {
    os_signpost(.begin, log: log, name: "print_operation")
    
    for i in 0..<1000 {
        "Message \(i)".print()
    }
    
    os_signpost(.end, log: log, name: "print_operation")
}
```

### Compare Outputs

Benchmark different output strategies:

```swift
func benchmarkOutputs() {
    let iterations = 10000
    let message = "Test message for benchmarking"
    
    // Console output
    let startTime = CFAbsoluteTimeGetCurrent()
    for _ in 0..<iterations {
        message.print()
    }
    let consoleTime = CFAbsoluteTimeGetCurrent() - startTime
    
    // File output
    let fileOutput = try! FilePrintOutput(url: tempFileURL)
    let fileStartTime = CFAbsoluteTimeGetCurrent()
    for _ in 0..<iterations {
        message.print(to: fileOutput)
    }
    let fileTime = CFAbsoluteTimeGetCurrent() - fileStartTime
    
    print("Console: \(consoleTime)s, File: \(fileTime)s")
}
```

## Production Optimizations

### Disable Debug Outputs

Create production-safe wrappers:

```swift
struct ProductionSafePrint {
    static func debug<T: CustomStringConvertible>(_ value: T) {
        #if DEBUG
        value.print()
        #endif
    }
    
    static func info<T: CustomStringConvertible>(_ value: T, to output: PrintOutput? = nil) {
        if let output = output {
            value.print(to: output)
        } else {
            value.print()
        }
    }
    
    static func error<T: CustomStringConvertible>(_ value: T, to output: PrintOutput? = nil) {
        // Always log errors, even in production
        if let output = output {
            value.print(to: output)
        } else {
            value.print()
        }
    }
}
```

### Log Levels

Implement configurable log levels:

```swift
enum LogLevel: Int, CaseIterable {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
    
    static var current: LogLevel = .info
}

extension CustomStringConvertible {
    func print(level: LogLevel, to output: PrintOutput? = nil) {
        guard level.rawValue >= LogLevel.current.rawValue else { return }
        
        let message = "[\(level)] \(self)"
        if let output = output {
            message.print(to: output)
        } else {
            message.print()
        }
    }
}

// Usage
"Debug info".print(level: .debug)  // Won't print if current level is .info
"Important error".print(level: .error)  // Always prints
```

### Resource Monitoring

Monitor resource usage in production:

```swift
struct MonitoredOutput: PrintOutput {
    private var output: PrintOutput
    private var messageCount = 0
    private var totalBytes = 0
    
    init(output: PrintOutput) {
        self.output = output
    }
    
    mutating func write(_ string: String) {
        messageCount += 1
        totalBytes += string.utf8.count
        
        // Alert if thresholds exceeded
        if messageCount % 1000 == 0 {
            print("Logging stats: \(messageCount) messages, \(totalBytes) bytes")
        }
        
        output.write(string)
    }
}
```

## Platform-Specific Considerations

### iOS/tvOS/watchOS

- Use ``OSLogPrintOutput`` for system integration
- Consider memory constraints on watchOS
- Be mindful of app backgrounding

### macOS

- Take advantage of larger memory and storage
- Consider user preferences for log verbosity
- Use system logging frameworks

### Server-Side Swift

- Implement structured logging
- Use async outputs for high throughput
- Monitor log file sizes and rotation

## Measurement Tools

Use these tools to measure performance:

- **Instruments**: Profile time and memory usage
- **os_signpost**: Measure specific operations
- **CFAbsoluteTimeGetCurrent()**: Simple timing measurements
- **Unit tests**: Automated performance regression testing

```swift
func testPrintPerformance() {
    measure {
        for i in 0..<1000 {
            "Message \(i)".print()
        }
    }
}
```
