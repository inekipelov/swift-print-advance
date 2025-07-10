# Combine Integration

Debug Combine publishers and data flow with enhanced print operators.

## Overview

PrintAdvance extends Combine publishers with enhanced debugging capabilities, allowing you to trace data flow through your reactive streams with flexible output destinations and formatting.

## Publisher Extensions

### Basic Publisher Printing

Print values as they flow through publishers:

```swift
import Combine
import PrintAdvance

let publisher = Just("Hello, Combine!")
    .print()  // Prints subscription, values, and completion
    .sink { value in
        print("Received: \(value)")
    }
```

### Custom Output Destinations

Direct publisher debug output to specific destinations:

```swift
let fileLogger = try! FilePrintOutput(url: debugLogURL)

URLSession.shared.dataTaskPublisher(for: url)
    .print(prefix: "API", to: fileLogger)  // Log API calls to file
    .map(\.data)
    .print(prefix: "Response", to: fileLogger)  // Log responses to file
    .sink(
        receiveCompletion: { _ in },
        receiveValue: { data in }
    )
```

## Network Request Debugging

Debug API calls and responses:

```swift
class APIService {
    private let networkLogger = try! OSLogPrintOutput(
        subsystem: "com.myapp.network",
        category: "api"
    )
    
    func fetchUser(id: String) -> AnyPublisher<User, Error> {
        URLSession.shared.dataTaskPublisher(for: userURL(id))
            .print(prefix: "Fetching user \(id)", to: networkLogger)
            .map(\.data)
            .print(prefix: "Raw response", to: networkLogger)
            .decode(type: User.self, decoder: JSONDecoder())
            .print(prefix: "Decoded user", to: networkLogger)
            .eraseToAnyPublisher()
    }
}
```

## Data Transformation Debugging

Track data transformations through operator chains:

```swift
let numbers = [1, 2, 3, 4, 5].publisher
    .print(prefix: "Original")
    .filter { $0 % 2 == 0 }
    .print(prefix: "Filtered")
    .map { $0 * 2 }
    .print(prefix: "Mapped")
    .collect()
    .print(prefix: "Collected")
    .sink { result in
        print("Final result: \(result)")
    }
```

## Error Handling Debug

Debug error scenarios and recovery:

```swift
enum NetworkError: Error {
    case invalidURL
    case noData
}

func fetchDataWithRetry() -> AnyPublisher<Data, Error> {
    fetchData()
        .print(prefix: "Initial attempt")
        .catch { error -> AnyPublisher<Data, Error> in
            error.print(prefix: "Error occurred")
            return fetchData()
                .print(prefix: "Retry attempt")
                .eraseToAnyPublisher()
        }
        .print(prefix: "Final result")
        .eraseToAnyPublisher()
}
```

## Timer and Scheduling Debug

Debug time-based operations:

```swift
let timerLogger = try! FilePrintOutput(url: timerLogURL)

Timer.publish(every: 1.0, on: .main, in: .common)
    .autoconnect()
    .print(prefix: "Timer tick", to: timerLogger)
    .map { _ in Date() }
    .print(prefix: "Current time", to: timerLogger)
    .sink { date in
        print("Timer fired at: \(date)")
    }
```

## Subject Debugging

Debug subjects and their subscribers:

```swift
class EventBus {
    private let eventSubject = PassthroughSubject<Event, Never>()
    private let eventLogger = try! OSLogPrintOutput(category: "events")
    
    var events: AnyPublisher<Event, Never> {
        eventSubject
            .print(prefix: "Event bus", to: eventLogger)
            .eraseToAnyPublisher()
    }
    
    func send(_ event: Event) {
        event.print(prefix: "Sending event", to: eventLogger)
        eventSubject.send(event)
    }
}
```

## Memory and Performance Debugging

Debug memory usage and performance issues:

```swift
class PerformanceDebugger {
    private let performanceLogger = try! OSLogPrintOutput(
        subsystem: "com.myapp.performance",
        category: "combine"
    )
    
    func debugPublisher<T, E>(_ publisher: AnyPublisher<T, E>) -> AnyPublisher<T, E> {
        publisher
            .handleEvents(
                receiveSubscription: { _ in
                    "Subscription started".print(to: self.performanceLogger)
                },
                receiveOutput: { _ in
                    "Value received".print(to: self.performanceLogger)
                },
                receiveCompletion: { _ in
                    "Publisher completed".print(to: self.performanceLogger)
                },
                receiveCancel: {
                    "Subscription cancelled".print(to: self.performanceLogger)
                }
            )
            .print(prefix: "Performance", to: performanceLogger)
    }
}
```

## Backpressure Debugging

Monitor backpressure and demand:

```swift
let backpressureLogger = try! FilePrintOutput(url: backpressureLogURL)

let slowConsumer = [1, 2, 3, 4, 5].publisher
    .print(prefix: "Fast producer", to: backpressureLogger)
    .delay(for: .milliseconds(100), scheduler: DispatchQueue.main)
    .print(prefix: "Delayed values", to: backpressureLogger)
    .buffer(size: 2, prefetch: .keepFull)
    .print(prefix: "Buffered values", to: backpressureLogger)
    .sink { value in
        Thread.sleep(forTimeInterval: 1)  // Slow consumer
        print("Processed: \(value)")
    }
```

## Custom Print Operators

Create specialized print operators for your use cases:

```swift
extension Publisher {
    func printAPIRequest(to output: PrintOutput? = nil) -> Publishers.HandleEvents<Self> {
        let logger = output ?? ConsolePrintOutput()
        
        return handleEvents(
            receiveSubscription: { _ in
                "🌐 API Request started".print(to: logger)
            },
            receiveOutput: { value in
                "📥 API Response: \(value)".print(to: logger)
            },
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    "✅ API Request completed".print(to: logger)
                case .failure(let error):
                    "❌ API Request failed: \(error)".print(to: logger)
                }
            }
        )
    }
    
    func printWithTimestamp(prefix: String = "", to output: PrintOutput? = nil) -> Publishers.HandleEvents<Self> {
        let timestampedOutput = TimestampPrintOutputModifier(
            output: output ?? ConsolePrintOutput()
        )
        
        return handleEvents(receiveOutput: { value in
            "\(prefix) \(value)".print(to: timestampedOutput)
        })
    }
}

// Usage
fetchUser(id: "123")
    .printAPIRequest(to: apiLogger)
    .printWithTimestamp(prefix: "User data:", to: timestampLogger)
    .sink { user in
        // Handle user
    }
```

## Conditional Debugging

Debug only in specific environments:

```swift
extension Publisher {
    func debugPrint(prefix: String = "") -> Publishers.HandleEvents<Self> {
        #if DEBUG
        return print(prefix: prefix)
        #else
        return handleEvents()  // No-op in release
        #endif
    }
}

// Usage
publisher
    .debugPrint(prefix: "Debug mode")  // Only prints in debug builds
    .sink { value in }
```

## Best Practices

### Structured Logging

Organize your Combine debugging output:

```swift
class CombineLogger {
    static let network = try! OSLogPrintOutput(category: "network")
    static let dataFlow = try! OSLogPrintOutput(category: "dataflow")
    static let errors = try! OSLogPrintOutput(category: "errors")
    
    static func logNetworkRequest<T, E>(_ publisher: AnyPublisher<T, E>) -> AnyPublisher<T, E> {
        publisher.print(prefix: "Network", to: network)
    }
    
    static func logDataFlow<T, E>(_ publisher: AnyPublisher<T, E>) -> AnyPublisher<T, E> {
        publisher.print(prefix: "Data", to: dataFlow)
    }
}
```

### Performance Considerations

Use sampling for high-frequency publishers:

```swift
extension Publisher {
    func samplePrint(every interval: Int, prefix: String = "") -> Publishers.HandleEvents<Self> {
        var count = 0
        return handleEvents(receiveOutput: { value in
            count += 1
            if count % interval == 0 {
                "\(prefix) Sample \(count): \(value)".print()
            }
        })
    }
}

// Print every 100th value instead of every value
highFrequencyPublisher
    .samplePrint(every: 100, prefix: "High freq")
    .sink { _ in }
```
