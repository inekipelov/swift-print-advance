# Modifying Outputs

Transform your print output with built-in modifiers.

## Overview

PrintAdvance provides several output modifiers that can transform your print output without changing your original print statements. These modifiers can be chained together for powerful output customization.

## Available Modifiers

### Timestamp Modifier

Add timestamps to your output:

```swift
let console = ConsolePrintOutput()
let timestamped = TimestampPrintOutputModifier(output: console)

"User logged in".print(to: timestamped)
// Output: 2024-01-01 12:00:00.123 User logged in
```

### Prefix and Suffix Modifiers

Add consistent prefixes or suffixes:

```swift
let prefixed = PrefixPrintOutputModifier(prefix: "[DEBUG]", output: console)
let suffixed = SuffixPrintOutputModifier(suffix: " ✓", output: console)

"Operation completed".print(to: prefixed)
// Output: [DEBUG] Operation completed

"Task finished".print(to: suffixed)
// Output: Task finished ✓
```

### Label Modifier

Add contextual labels:

```swift
let labeled = LabelPrintOutputModifier(label: "API", output: console)

"Request successful".print(to: labeled)
// Output: API: Request successful
```

### Filter Modifier

Filter output based on conditions:

```swift
let filtered = FilterPrintOutputModifier(output: console) { message in
    return message.contains("ERROR") || message.contains("WARN")
}

"INFO: Everything is fine".print(to: filtered)  // Not printed
"ERROR: Something went wrong".print(to: filtered)  // Printed
```

### Replace Modifier

Replace text patterns in output:

```swift
let sanitized = ReplacePrintOutputModifier(
    pattern: "password=\\w+",
    replacement: "password=***",
    output: console
)

"Login attempt: password=secret123".print(to: sanitized)
// Output: Login attempt: password=***
```

### Trace Modifier

Add source location information:

```swift
let traced = TracePrintOutputModifier(output: console)

"Debug message".print(to: traced)
// Output: [MyFile.swift:42] Debug message
```

### Uppercase Modifier

Transform output to uppercase:

```swift
let uppercase = UppercasePrintOutputModifier(output: console)

"hello world".print(to: uppercase)
// Output: HELLO WORLD
```

## Chaining Modifiers

Modifiers can be chained together to create powerful output transformations:

```swift
let console = ConsolePrintOutput()
let complex = TimestampPrintOutputModifier(
    output: PrefixPrintOutputModifier(
        prefix: "[API]",
        output: FilterPrintOutputModifier(
            output: console
        ) { message in
            !message.contains("DEBUG")
        }
    )
)

"DEBUG: Trace message".print(to: complex)  // Not printed (filtered out)
"INFO: API call successful".print(to: complex)
// Output: 2024-01-01 12:00:00.123 [API] INFO: API call successful
```

## Creating Custom Modifiers

You can create your own modifiers by conforming to ``PrintOutputModifier``:

```swift
struct JSONFormatModifier: PrintOutputModifier {
    var output: PrintOutput
    
    init(output: PrintOutput) {
        self.output = output
    }
    
    mutating func write(_ string: String) {
        let jsonMessage = [
            "timestamp": ISO8601DateFormatter().string(from: Date()),
            "level": "INFO",
            "message": string
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonMessage),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            output.write(jsonString)
        } else {
            output.write(string)  // Fallback to original
        }
    }
}

// Usage
let jsonOutput = JSONFormatModifier(output: console)
"User action completed".print(to: jsonOutput)
// Output: {"timestamp":"2024-01-01T12:00:00Z","level":"INFO","message":"User action completed"}
```

## Conditional Modifiers

Create modifiers that only apply under certain conditions:

```swift
struct ConditionalModifier: PrintOutputModifier {
    var output: PrintOutput
    private let condition: () -> Bool
    private let modifier: (String) -> String
    
    init(output: PrintOutput, when condition: @escaping () -> Bool, apply modifier: @escaping (String) -> String) {
        self.output = output
        self.condition = condition
        self.modifier = modifier
    }
    
    mutating func write(_ string: String) {
        let finalString = condition() ? modifier(string) : string
        output.write(finalString)
    }
}

// Only add timestamps in debug builds
let conditionalTimestamp = ConditionalModifier(
    output: console,
    when: { 
        #if DEBUG
        return true
        #else
        return false
        #endif
    },
    apply: { message in
        "\(Date()) \(message)"
    }
)
```

## Performance Tips

### Lazy Evaluation

For expensive transformations, consider lazy evaluation:

```swift
struct LazyModifier: PrintOutputModifier {
    var output: PrintOutput
    private let transform: (String) -> String
    
    mutating func write(_ string: String) {
        // Only apply transformation if output is actually used
        let transformed = transform(string)
        output.write(transformed)
    }
}
```

### Caching

Cache expensive computations:

```swift
struct CachedModifier: PrintOutputModifier {
    var output: PrintOutput
    private var cache: [String: String] = [:]
    
    mutating func write(_ string: String) {
        if let cached = cache[string] {
            output.write(cached)
        } else {
            let transformed = expensiveTransform(string)
            cache[string] = transformed
            output.write(transformed)
        }
    }
    
    private func expensiveTransform(_ string: String) -> String {
        // Expensive transformation here
        return string.uppercased()
    }
}
```

## Built-in Combinations

PrintAdvance provides some common modifier combinations:

```swift
// Development logging with timestamp and trace
let devLogger = TracePrintOutputModifier(
    output: TimestampPrintOutputModifier(
        output: ConsolePrintOutput()
    )
)

// Production logging with filtering and JSON format
let prodLogger = FilterPrintOutputModifier(
    output: JSONFormatModifier(
        output: FilePrintOutput(url: logFileURL)
    )
) { message in
    !message.contains("DEBUG")
}
```
