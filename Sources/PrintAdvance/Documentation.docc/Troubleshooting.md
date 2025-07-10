# Troubleshooting

Common issues and solutions when using PrintAdvance.

## Overview

This guide covers common problems you might encounter when using PrintAdvance and provides solutions to resolve them.

## Installation Issues

### Swift Package Manager Resolution

**Problem**: Package resolution fails or takes too long.

**Solution**:
```bash
# Clear package cache
rm -rf ~/Library/Caches/org.swift.swiftpm
rm -rf .build

# Re-resolve packages
swift package resolve
```

### Xcode Integration

**Problem**: PrintAdvance doesn't appear in Xcode autocomplete.

**Solution**:
1. Clean build folder: **Product** → **Clean Build Folder**
2. Restart Xcode
3. Ensure import statement is correct: `import PrintAdvance`

## Runtime Issues

### File Output Problems

**Problem**: `FilePrintOutput` fails with permission errors.

**Solution**:
```swift
// Use app's documents directory
let documentsURL = FileManager.default
    .urls(for: .documentDirectory, in: .userDomainMask)[0]
let logURL = documentsURL.appendingPathComponent("app.log")

do {
    let fileOutput = try FilePrintOutput(url: logURL)
    "Test message".print(to: fileOutput)
} catch {
    print("File output error: \(error)")
    // Fallback to console
    "Test message".print()
}
```

**Problem**: Log files grow too large.

**Solution**: Implement log rotation:
```swift
class RotatingFileOutput: PrintOutput {
    private let maxFileSize: Int
    private let maxFiles: Int
    private var currentOutput: FilePrintOutput
    private let baseURL: URL
    
    init(baseURL: URL, maxFileSize: Int = 10_000_000, maxFiles: Int = 5) throws {
        self.baseURL = baseURL
        self.maxFileSize = maxFileSize
        self.maxFiles = maxFiles
        self.currentOutput = try FilePrintOutput(url: baseURL)
    }
    
    mutating func write(_ string: String) {
        // Check file size and rotate if needed
        if let attributes = try? FileManager.default.attributesOfItem(atPath: baseURL.path),
           let fileSize = attributes[.size] as? Int,
           fileSize > maxFileSize {
            rotateFiles()
        }
        
        currentOutput.write(string)
    }
    
    private mutating func rotateFiles() {
        // Implement rotation logic
    }
}
```

### OSLog Output Issues

**Problem**: OSLog messages don't appear in Console.app.

**Solution**:
1. Ensure correct subsystem and category:
```swift
let osLog = OSLogPrintOutput(
    subsystem: Bundle.main.bundleIdentifier ?? "com.yourapp",
    category: "debug"
)
```

2. Use Console.app filters:
   - Open Console.app
   - Filter by your app's bundle identifier
   - Check log level settings

### Memory Issues

**Problem**: High memory usage with frequent printing.

**Solution**: Use buffered output:
```swift
let bufferedOutput = BufferPrintOutput(
    bufferSize: 1000,
    flushInterval: 5.0,
    underlyingOutput: fileOutput
)

// For high-frequency logging
for i in 0..<10000 {
    "Message \(i)".print(to: bufferedOutput)
}
```

## Performance Issues

### Slow Print Operations

**Problem**: Print operations block the main thread.

**Solution**: Use background queues for file operations:
```swift
struct AsyncOutput: PrintOutput {
    private let queue = DispatchQueue(label: "logging", qos: .utility)
    private var underlyingOutput: PrintOutput
    
    init(output: PrintOutput) {
        self.underlyingOutput = output
    }
    
    mutating func write(_ string: String) {
        queue.async {
            self.underlyingOutput.write(string)
        }
    }
}
```

### High CPU Usage

**Problem**: Too many print operations consuming CPU.

**Solution**: Implement sampling or throttling:
```swift
class ThrottledOutput: PrintOutput {
    private var lastPrintTime: TimeInterval = 0
    private let minInterval: TimeInterval
    private var underlyingOutput: PrintOutput
    
    init(minInterval: TimeInterval = 0.1, output: PrintOutput) {
        self.minInterval = minInterval
        self.underlyingOutput = output
    }
    
    mutating func write(_ string: String) {
        let now = Date().timeIntervalSince1970
        if now - lastPrintTime >= minInterval {
            underlyingOutput.write(string)
            lastPrintTime = now
        }
    }
}
```

## SwiftUI Integration Issues

### View Not Updating

**Problem**: SwiftUI views don't update after print operations.

**Solution**: Ensure prints don't interfere with view updates:
```swift
struct DebugView: View {
    @State private var counter = 0
    
    var body: some View {
        Text("Counter: \(counter)")
            .print()  // This is safe
            .onTapGesture {
                counter += 1
                // Print after state change, not during
                DispatchQueue.main.async {
                    counter.print()
                }
            }
    }
}
```

### Performance in Lists

**Problem**: Slow scrolling in lists with print statements.

**Solution**: Conditional printing:
```swift
struct ListItemView: View {
    let item: Item
    
    var body: some View {
        Text(item.name)
            #if DEBUG
            .print()  // Only in debug builds
            #endif
    }
}
```

## Combine Integration Issues

### Memory Leaks

**Problem**: Publishers with print operators causing memory leaks.

**Solution**: Ensure proper subscription management:
```swift
class DataService {
    private var cancellables = Set<AnyCancellable>()
    
    func fetchData() {
        URLSession.shared.dataTaskPublisher(for: url)
            .print(prefix: "API")
            .sink { _ in }
            .store(in: &cancellables)  // Important: store cancellable
    }
    
    deinit {
        cancellables.removeAll()  // Clean up on deinit
    }
}
```

### Publisher Not Printing

**Problem**: Publisher print operations don't appear.

**Solution**: Check publisher lifecycle:
```swift
// Ensure publisher is actually subscribed to
let publisher = Just("Hello")
    .print()  // This won't print without subscription

let cancellable = publisher
    .sink { value in
        print("Received: \(value)")
    }
```

## Debugging PrintAdvance Itself

### Enable Verbose Logging

For debugging PrintAdvance internals:
```swift
// Set environment variable
ProcessInfo.processInfo.environment["PRINT_ADVANCE_DEBUG"] = "1"

// Or use debug output
let debugOutput = ConsolePrintOutput()
"Debug message".print(to: debugOutput)
```

### Check Output Destinations

Verify your outputs are working:
```swift
func testOutputs() {
    let outputs: [PrintOutput] = [
        ConsolePrintOutput(),
        try! FilePrintOutput(url: testFileURL),
        OSLogPrintOutput(category: "test")
    ]
    
    for (index, var output) in outputs.enumerated() {
        "Test message from output \(index)".print(to: output)
    }
}
```

## Getting Help

### Debug Information

When reporting issues, include:
1. PrintAdvance version
2. Swift version
3. Platform and OS version
4. Code example that reproduces the issue
5. Expected vs actual behavior

### Common Solutions Checklist

Before reporting issues, try:
- [ ] Clean build folder
- [ ] Update to latest PrintAdvance version
- [ ] Check file permissions for file outputs
- [ ] Verify import statements
- [ ] Test with basic console output first
- [ ] Check for retain cycles in custom outputs

### Performance Profiling

Use Instruments to profile print operations:
```swift
import os.signpost

let log = OSLog(subsystem: "com.yourapp.performance", category: "printing")

os_signpost(.begin, log: log, name: "print_operation")
"Heavy operation result".print()
os_signpost(.end, log: log, name: "print_operation")
```

## Best Practices Summary

To avoid common issues:

1. **Use appropriate output types** for your use case
2. **Implement error handling** for file operations
3. **Consider performance** in high-frequency scenarios
4. **Use conditional compilation** for debug prints
5. **Manage memory properly** in reactive streams
6. **Test thoroughly** on target platforms
7. **Monitor resource usage** in production
