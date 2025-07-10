# Result Utilities

Debug Result types and error handling with enhanced printing.

## Overview

PrintAdvance provides specialized extensions for Swift's `Result` type, making it easier to debug success and failure cases in your error handling code.

## Basic Result Printing

Print Result values while preserving the Result for further processing:

```swift
import PrintAdvance

func fetchData() -> Result<String, Error> {
    // Simulate API call
    return .success("API Data")
}

let result = fetchData()
    .print()  // Prints: success("API Data") or failure(error)
```

## Success and Failure Debugging

Debug specific cases with custom formatting:

```swift
enum NetworkError: Error, CustomStringConvertible {
    case invalidURL
    case noConnection
    case serverError(Int)
    
    var description: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noConnection: return "No network connection"
        case .serverError(let code): return "Server error: \(code)"
        }
    }
}

func processAPIResult() {
    let result: Result<User, NetworkError> = fetchUser()
    
    result
        .print()  // Print the entire result
        .map { user in
            user.name.uppercased()
        }
        .print()  // Print the transformed result
}
```

## Custom Output Destinations

Direct Result debugging to specific outputs:

```swift
let successLogger = try! FilePrintOutput(url: successLogURL)
let errorLogger = try! FilePrintOutput(url: errorLogURL)

func handleResult<T, E>(_ result: Result<T, E>) {
    switch result {
    case .success(let value):
        value.print(to: successLogger)
    case .failure(let error):
        error.print(to: errorLogger)
    }
}
```

## Chain Debugging

Debug Result transformations through method chains:

```swift
func processUserData(id: String) -> Result<String, Error> {
    return fetchUser(id: id)
        .print()  // Debug initial fetch
        .map { user in
            user.name
        }
        .print()  // Debug name extraction
        .flatMap { name in
            validateName(name)
        }
        .print()  // Debug validation result
}
```

## Async Result Debugging

Debug Results in async contexts:

```swift
func fetchUserAsync(id: String) async -> Result<User, Error> {
    do {
        let user = try await APIService.fetchUser(id: id)
        return .success(user).print()  // Debug successful fetch
    } catch {
        return .failure(error).print()  // Debug error
    }
}
```

## Error Recovery Debugging

Debug error recovery patterns:

```swift
func fetchWithFallback() -> Result<Data, Error> {
    return fetchFromPrimaryAPI()
        .print(prefix: "Primary API")
        .flatMapError { primaryError in
            primaryError.print(prefix: "Primary failed")
            return fetchFromSecondaryAPI()
                .print(prefix: "Secondary API")
                .mapError { secondaryError in
                    "Both APIs failed: \(primaryError), \(secondaryError)".print()
                    return secondaryError
                }
        }
}
```

## Validation Chain Debugging

Debug validation pipelines:

```swift
struct ValidationError: Error, CustomStringConvertible {
    let message: String
    var description: String { message }
}

func validateUser(_ user: User) -> Result<User, ValidationError> {
    return Result.success(user)
        .print(prefix: "Input user")
        .flatMap { user in
            guard !user.name.isEmpty else {
                return .failure(ValidationError(message: "Name cannot be empty"))
                    .print(prefix: "Name validation failed")
            }
            return .success(user).print(prefix: "Name validation passed")
        }
        .flatMap { user in
            guard user.email.contains("@") else {
                return .failure(ValidationError(message: "Invalid email format"))
                    .print(prefix: "Email validation failed")
            }
            return .success(user).print(prefix: "Email validation passed")
        }
        .print(prefix: "Final validation result")
}
```

## Performance Metrics

Track success/failure rates:

```swift
class ResultMetrics {
    private var successCount = 0
    private var failureCount = 0
    private let metricsLogger = try! OSLogPrintOutput(category: "metrics")
    
    func trackResult<T, E>(_ result: Result<T, E>) -> Result<T, E> {
        switch result {
        case .success:
            successCount += 1
            "Success count: \(successCount)".print(to: metricsLogger)
        case .failure:
            failureCount += 1
            "Failure count: \(failureCount)".print(to: metricsLogger)
        }
        
        let total = successCount + failureCount
        let successRate = Double(successCount) / Double(total) * 100
        "Success rate: \(String(format: "%.1f", successRate))%".print(to: metricsLogger)
        
        return result.print(to: metricsLogger)
    }
}

// Usage
let metrics = ResultMetrics()
fetchData()
    .flatMap(metrics.trackResult)
    .sink { result in
        // Handle result
    }
```

## Conditional Result Debugging

Debug Results based on conditions:

```swift
extension Result {
    func debugPrint(when condition: Bool = true, prefix: String = "") -> Self {
        guard condition else { return self }
        return self.print(prefix: prefix)
    }
    
    func debugPrintFailures(prefix: String = "") -> Self {
        switch self {
        case .success:
            return self
        case .failure:
            return self.print(prefix: prefix)
        }
    }
}

// Usage
#if DEBUG
let debugMode = true
#else
let debugMode = false
#endif

result
    .debugPrint(when: debugMode, prefix: "Debug")
    .debugPrintFailures(prefix: "Error")
```

## Result Builders with Debugging

Debug complex Result-based computations:

```swift
@resultBuilder
struct ResultBuilder<Error> {
    static func buildBlock<T>(_ result: Result<T, Error>) -> Result<T, Error> {
        result.print(prefix: "Step")
    }
    
    static func buildBlock<T1, T2>(
        _ r1: Result<T1, Error>,
        _ r2: Result<T2, Error>
    ) -> Result<(T1, T2), Error> {
        r1.print(prefix: "Step 1")
            .flatMap { v1 in
                r2.print(prefix: "Step 2")
                    .map { v2 in (v1, v2) }
            }
            .print(prefix: "Combined")
    }
}

func buildResults<Error>(@ResultBuilder<Error> _ builder: () -> Result<String, Error>) -> Result<String, Error> {
    builder()
}

// Usage
let combined = buildResults {
    fetchName()
    fetchEmail()
}
```

## Testing Result Scenarios

Debug Results in unit tests:

```swift
func testResultChaining() {
    let testLogger = BufferPrintOutput()
    
    let result = Result<Int, Error>.success(42)
        .print(to: testLogger)
        .map { $0 * 2 }
        .print(to: testLogger)
    
    // Verify the logged output
    let logs = testLogger.buffer
    XCTAssertTrue(logs.contains("success(42)"))
    XCTAssertTrue(logs.contains("success(84)"))
}
```

## Custom Result Extensions

Create domain-specific Result debugging:

```swift
extension Result where Success: User, Failure: NetworkError {
    func debugUser(prefix: String = "") -> Self {
        switch self {
        case .success(let user):
            "User: \(user.name) (\(user.email))".print(prefix: prefix)
        case .failure(let error):
            "User fetch failed: \(error)".print(prefix: prefix)
        }
        return self
    }
}

// Usage
fetchUser(id: "123")
    .debugUser(prefix: "Auth")
    .map { user in
        // Process user
    }
```

## Best Practices

### Structured Error Logging

Organize your Result debugging:

```swift
class ResultLogger {
    static let api = try! OSLogPrintOutput(category: "api-results")
    static let validation = try! OSLogPrintOutput(category: "validation-results")
    static let business = try! OSLogPrintOutput(category: "business-results")
}

extension Result {
    func logAPI() -> Self {
        self.print(to: ResultLogger.api)
    }
    
    func logValidation() -> Self {
        self.print(to: ResultLogger.validation)
    }
    
    func logBusiness() -> Self {
        self.print(to: ResultLogger.business)
    }
}
```

### Error Context

Provide meaningful context in error debugging:

```swift
extension Result {
    func printWithContext(_ context: String) -> Self {
        switch self {
        case .success(let value):
            "✅ \(context): \(value)".print()
        case .failure(let error):
            "❌ \(context): \(error)".print()
        }
        return self
    }
}

// Usage
fetchUser(id: userID)
    .printWithContext("Fetching user profile")
    .flatMap { user in
        validateUser(user)
            .printWithContext("Validating user data")
    }
```

### Performance Monitoring

Track Result performance:

```swift
extension Result {
    func timeExecution(label: String) -> Self {
        let startTime = CFAbsoluteTimeGetCurrent()
        defer {
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            "\(label) took \(timeElapsed * 1000)ms".print()
        }
        return self.print(prefix: label)
    }
}
```
