# SwiftUI Integration

Use PrintAdvance with SwiftUI for debugging views and state changes.

## Overview

PrintAdvance provides seamless integration with SwiftUI, allowing you to debug view hierarchies, state changes, and data flow without disrupting your UI code.

## View Extensions

### Basic View Printing

Print information about any view in your hierarchy:

```swift
import SwiftUI
import PrintAdvance

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .print()  // Prints view description
            .foregroundColor(.blue)
            .print()  // Prints modified view
    }
}
```

### State Change Debugging

Monitor state changes in your views:

```swift
struct CounterView: View {
    @State private var count = 0
    
    var body: some View {
        VStack {
            Text("Count: \(count)")
                .print()  // Prints whenever count changes
            
            Button("Increment") {
                count += 1
            }
        }
        .printChanges()  // iOS 15+ - prints when view updates
    }
}
```

## Custom Output for Views

Direct view debug information to specific outputs:

```swift
struct DebugView: View {
    let debugOutput = try! FilePrintOutput(url: debugLogURL)
    
    var body: some View {
        Text("Production view")
            .print(to: debugOutput)  // Debug info goes to file
    }
}
```

## ObservableObject Debugging

Debug state objects and their changes:

```swift
class UserStore: ObservableObject {
    @Published var users: [User] = [] {
        didSet {
            users.print()  // Print when users array changes
        }
    }
    
    func addUser(_ user: User) {
        user.print()  // Print the user being added
        users.append(user)
    }
}

struct UserListView: View {
    @StateObject private var store = UserStore()
    
    var body: some View {
        List(store.users, id: \.id) { user in
            Text(user.name)
                .print()  // Print each user as rendered
        }
    }
}
```

## Environment Values

Debug environment values:

```swift
struct ThemeAwareView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Text("Themed content")
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .print()  // Will show different output for light/dark mode
    }
}
```

## Navigation Debugging

Track navigation changes:

```swift
struct NavigationView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button("Go to Detail") {
                    path.append("detail")
                    path.print()  // Print navigation path changes
                }
            }
        }
    }
}
```

## Animation and Transition Debugging

Debug animations and view transitions:

```swift
struct AnimatedView: View {
    @State private var isExpanded = false
    
    var body: some View {
        VStack {
            if isExpanded {
                Text("Expanded content")
                    .print()  // Prints when view appears
                    .transition(.slide)
            }
            
            Button("Toggle") {
                withAnimation {
                    isExpanded.toggle()
                    isExpanded.print()  // Print state changes
                }
            }
        }
    }
}
```

## Performance Debugging

Monitor view performance:

```swift
struct PerformanceView: View {
    let performanceLogger = try! OSLogPrintOutput(
        subsystem: "com.myapp.performance",
        category: "views"
    )
    
    var body: some View {
        LazyVStack {
            ForEach(0..<1000, id: \.self) { index in
                Text("Item \(index)")
                    .print(to: performanceLogger)  // Log heavy view creation
            }
        }
    }
}
```

## Conditional Debug Printing

Use SwiftUI's conditional compilation:

```swift
struct ProductionView: View {
    var body: some View {
        Text("Production content")
            #if DEBUG
            .print()  // Only prints in debug builds
            #endif
    }
}
```

## Custom Debug Views

Create reusable debug components:

```swift
struct DebugView<Content: View>: View {
    let content: Content
    let label: String
    
    init(label: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }
    
    var body: some View {
        content
            .print()  // Print the wrapped content
            .overlay(
                Text(label)
                    .print()  // Print the debug label
                    .font(.caption)
                    .foregroundColor(.red)
                    .opacity(0.7),
                alignment: .topTrailing
            )
    }
}

// Usage
DebugView(label: "Main Content") {
    VStack {
        Text("Hello")
        Button("Tap me") { }
    }
}
```

## Best Practices

### Organized Debug Output

Structure your debug output:

```swift
struct OrganizedDebugView: View {
    let viewLogger = try! FilePrintOutput(url: viewLogURL)
    let stateLogger = try! FilePrintOutput(url: stateLogURL)
    
    @State private var text = ""
    
    var body: some View {
        TextField("Enter text", text: $text)
            .print(to: viewLogger)  // View changes to view log
            .onChange(of: text) { newValue in
                newValue.print(to: stateLogger)  // State changes to state log
            }
    }
}
```

### Performance Considerations

Be mindful of print frequency in high-performance scenarios:

```swift
struct HighPerformanceView: View {
    @State private var dragOffset = CGSize.zero
    
    var body: some View {
        Rectangle()
            .offset(dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                        // Don't print every drag update in production
                        #if DEBUG
                        if Int(value.translation.x) % 10 == 0 {
                            dragOffset.print()  // Only print every 10 pixels
                        }
                        #endif
                    }
            )
    }
}
```
