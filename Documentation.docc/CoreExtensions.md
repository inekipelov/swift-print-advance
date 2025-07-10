# Core Extensions

Learn about the core printing extensions for Swift types.

## Overview

PrintAdvance extends Swift's built-in types with convenient printing methods that support method chaining and custom output destinations.

## CustomStringConvertible Extensions

Any type that conforms to `CustomStringConvertible` automatically gets access to enhanced printing methods:

```swift
import PrintAdvance

// Basic printing with chaining
let result = "Hello, World!"
    .print()  // Prints to console
    .uppercased()
    .print()  // Prints "HELLO, WORLD!"

// Custom output destinations
let fileOutput = try FilePrintOutput(url: logFileURL)
"Log message".print(to: fileOutput)
```

### Available Methods

#### print()

Prints the object to standard output and returns itself for chaining:

```swift
@discardableResult
func print() -> Self
```

#### print(to:)

Prints the object to a specified output destination:

```swift
@discardableResult
func print(to output: PrintOutput) -> Self
```

## String Extensions

Strings have all the `CustomStringConvertible` functionality plus additional features for common logging scenarios:

```swift
// Multiple output destinations
"Important message"
    .print()  // Console
    .print(to: fileLogger)  // File
    .print(to: osLogger)  // System log
```

## Numeric Type Extensions

Numbers benefit from the same printing capabilities:

```swift
let calculation = 42
    .print()  // Prints "42"
    * 2
    .print()  // Prints "84"

let pi = 3.14159
    .print()  // Prints "3.14159"
```

## Collection Extensions

Arrays, sets, and dictionaries can be printed directly:

```swift
let numbers = [1, 2, 3, 4, 5]
    .print()  // Prints "[1, 2, 3, 4, 5]"
    .map { $0 * 2 }
    .print()  // Prints "[2, 4, 6, 8, 10]"

let userInfo = ["name": "John", "age": "30"]
    .print()  // Prints the dictionary
```

## Optional Extensions

Even optionals can be printed safely:

```swift
let optionalValue: String? = "Hello"
optionalValue.print()  // Prints "Optional("Hello")"

let nilValue: String? = nil
nilValue.print()  // Prints "nil"
```

## Best Practices

### Production Code

Use conditional compilation for debug prints:

```swift
#if DEBUG
"Debug information".print()
#endif
```

### Method Chaining

Take advantage of the chainable nature:

```swift
let processedData = rawData
    .print()  // Debug input
    .filter { $0.isValid }
    .print()  // Debug filtered
    .map { $0.transform() }
    .print()  // Debug final result
```

### Custom Types

Make your custom types work with print extensions:

```swift
struct User: CustomStringConvertible {
    let name: String
    let email: String
    
    var description: String {
        return "User(name: \(name), email: \(email))"
    }
}

let user = User(name: "John", email: "john@example.com")
user.print()  // Prints "User(name: John, email: john@example.com)"
```
