# Print Advance

[![Swift Version](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Swift Tests](https://github.com/inekipelov/swift-print-advance/actions/workflows/swift.yml/badge.svg)](https://github.com/inekipelov/swift-print-advance/actions/workflows/swift.yml)  
[![iOS](https://img.shields.io/badge/iOS-9.0+-blue.svg)](https://developer.apple.com/ios/)
[![macOS](https://img.shields.io/badge/macOS-10.13+-white.svg)](https://developer.apple.com/macos/)
[![tvOS](https://img.shields.io/badge/tvOS-9.0+-black.svg)](https://developer.apple.com/tvos/)
[![watchOS](https://img.shields.io/badge/watchOS-2.0+-orange.svg)](https://developer.apple.com/watchos/)

Advanced print utilities for Swift with chainable extensions and flexible output destinations.

## Usage

### Basic Extensions

```swift
import PrintAdvance

// Chain print calls
let result = "Hello, World!"
    .print()
    .print(to: FilePrint.documentsFile)

// Print Results
let result: Result<String, Error> = .success("Success!").print()

// Print in SwiftUI Views
struct ContentView: View {
    var body: some View {
        Text("Hello")
            .print()
            .printChanges() // iOS 15+
    }
}
```

### Print Outputs

```swift
// Console output (default)
"Message".print(to: ConsolePrint())

// File output
"Log entry".print(to: FilePrint.documentsFile)

// Buffer output
"Buffered message".print(to: BufferPrint.shared)
print(buffer.content) // Retrieve buffered content

// Pasteboard output (macOS/iOS/tvOS)
"Copy to clipboard".print(to: PasteboardPrint.general)

// Combine multiple outputs using 'with' extension
"Critical event".print(to: ConsolePrint()
    .with(FilePrint.documentsFile)
    .with(BufferPrint.shared)
)
```
## Custom Implementations

### Custom PrintOutput

```swift
import PrintAdvance

struct NetworkPrintOutput: PrintOutput {
    let endpoint: URL
    
    mutating func write(_ string: String) {
        // Send to network endpoint
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.httpBody = string.data(using: .utf8)
        URLSession.shared.dataTask(with: request).resume()
    }
}
```

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/inekipelov/swift-print-advance", from: "0.2.0")
]
```
