# Quick Start

Get up and running with PrintAdvance in minutes.

## Overview

PrintAdvance makes debugging and logging more convenient by providing chainable print methods and flexible output destinations. This guide will help you get started quickly.

## Installation

### Swift Package Manager

Add PrintAdvance to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/inekipelov/swift-print-advance.git", from: "1.0.0")
]
```

Then add it to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["PrintAdvance"]
)
```

## Basic Usage

### Chainable Printing

The most basic feature is chainable printing that doesn't break your method chains:

```swift
import PrintAdvance

let result = "Hello, World!"
    .print()  // Prints to console
    .uppercased()
    .print()  // Prints "HELLO, WORLD!"
```

### Custom Output Destinations

Print to different destinations:

```swift
// Print to console (default)
"Debug message".print()

// Print to a file
let fileOutput = try FilePrintOutput(url: logFileURL)
"Log entry".print(to: fileOutput)

// Print to system log
let osLog = OSLogPrintOutput(category: "MyApp")
"System message".print(to: osLog)
```

### SwiftUI Integration

Debug your SwiftUI views:

```swift
struct ContentView: View {
    @State private var counter = 0
    
    var body: some View {
        VStack {
            Text("Counter: \(counter)")
                .print()  // Debug the text value
            
            Button("Increment") {
                counter += 1
            }
        }
        .printChanges()  // Print when view updates (iOS 15+)
    }
}
```

### Combine Publishers

Debug your publishers:

```swift
import Combine

publisher
    .print(prefix: "API Response")
    .print(to: fileOutput)
    .sink { completion in
        // Handle completion
    } receiveValue: { value in
        // Handle value
    }
```

## Next Steps

- Learn about <doc:CustomOutputs>
- Explore <doc:ModifyingOutputs>
- Check out <doc:PerformanceConsiderations>
