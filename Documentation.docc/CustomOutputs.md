# Creating Custom Outputs

Learn how to create custom print output destinations.

## Overview

PrintAdvance allows you to create custom output destinations by conforming to the ``PrintOutput`` protocol. This enables you to send print output anywhere you need.

## The PrintOutput Protocol

The ``PrintOutput`` protocol extends `TextOutputStream` and requires implementing a single method:

```swift
public protocol PrintOutput: TextOutputStream {
    mutating func write(_ string: String)
}
```

## Creating a Simple Custom Output

Here's a basic example of a custom output that adds a prefix to all messages:

```swift
struct PrefixedOutput: PrintOutput {
    private let prefix: String
    
    init(prefix: String) {
        self.prefix = prefix
    }
    
    mutating func write(_ string: String) {
        print("[\(prefix)] \(string)")
    }
}

// Usage
let customOutput = PrefixedOutput(prefix: "DEBUG")
"Hello, World!".print(to: customOutput)
// Output: [DEBUG] Hello, World!
```

## Advanced Custom Output Example

Here's a more sophisticated example that writes to multiple destinations:

```swift
struct MultiDestinationOutput: PrintOutput {
    private var fileHandle: FileHandle?
    private let includeTimestamp: Bool
    
    init(fileURL: URL, includeTimestamp: Bool = true) throws {
        self.includeTimestamp = includeTimestamp
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil)
        }
        
        self.fileHandle = try FileHandle(forWritingTo: fileURL)
        self.fileHandle?.seekToEndOfFile()
    }
    
    mutating func write(_ string: String) {
        var message = string
        
        if includeTimestamp {
            let timestamp = DateFormatter.iso8601.string(from: Date())
            message = "[\(timestamp)] \(string)"
        }
        
        // Write to console
        print(message)
        
        // Write to file
        if let data = (message + "\n").data(using: .utf8) {
            fileHandle?.write(data)
        }
    }
}
```

## Thread-Safe Custom Output

For concurrent environments, consider thread safety:

```swift
import Foundation

struct ThreadSafeOutput: PrintOutput {
    private let queue = DispatchQueue(label: "com.yourapp.print", qos: .utility)
    private var underlyingOutput: ConsolePrintOutput
    
    init() {
        self.underlyingOutput = ConsolePrintOutput()
    }
    
    mutating func write(_ string: String) {
        queue.sync {
            underlyingOutput.write(string)
        }
    }
}
```

## Best Practices

### Error Handling

Always handle potential errors gracefully:

```swift
struct SafeFileOutput: PrintOutput {
    private var fileHandle: FileHandle?
    
    mutating func write(_ string: String) {
        do {
            guard let data = string.data(using: .utf8) else { return }
            try fileHandle?.write(contentsOf: data)
        } catch {
            // Fallback to console on file write error
            print("File write error: \(error). Message: \(string)")
        }
    }
}
```

### Resource Management

Implement proper cleanup for resources:

```swift
struct ManagedFileOutput: PrintOutput {
    private var fileHandle: FileHandle?
    
    init(fileURL: URL) throws {
        self.fileHandle = try FileHandle(forWritingTo: fileURL)
    }
    
    mutating func write(_ string: String) {
        // Write implementation
    }
    
    func close() {
        fileHandle?.closeFile()
    }
}
```

### Performance Considerations

For high-frequency logging, consider buffering:

```swift
struct BufferedOutput: PrintOutput {
    private var buffer: [String] = []
    private let bufferSize: Int
    private var underlyingOutput: PrintOutput
    
    init(bufferSize: Int = 100, output: PrintOutput) {
        self.bufferSize = bufferSize
        self.underlyingOutput = output
    }
    
    mutating func write(_ string: String) {
        buffer.append(string)
        
        if buffer.count >= bufferSize {
            flush()
        }
    }
    
    mutating func flush() {
        for message in buffer {
            underlyingOutput.write(message)
        }
        buffer.removeAll()
    }
}
```

## Integration with Output Modifiers

Your custom outputs work seamlessly with built-in modifiers:

```swift
let customOutput = PrefixedOutput(prefix: "API")
let timestampedOutput = TimestampPrintOutputModifier(output: customOutput)

"Request started".print(to: timestampedOutput)
// Output: [API] 2024-01-01 12:00:00 Request started
```
