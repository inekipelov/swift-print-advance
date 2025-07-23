//
//  View+PrintAction.swift
//

#if canImport(SwiftUI)
import SwiftUI

/// Extension providing enhanced print functionality for SwiftUI views.
///
/// This extension adds convenient print methods to SwiftUI views for debugging
/// and development purposes. It provides methods for logging view changes,
/// printing view descriptions, and outputting custom content.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension View {
    
    /// Prints the view's changes to the console for debugging layout issues.
    ///
    /// This method enables SwiftUI's built-in change tracking for the view,
    /// which helps identify what causes view updates and re-renders.
    ///
    /// - Returns: The view with change printing enabled.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Text("Hello, World!")
    ///     .printChanges()
    /// ```
    ///
    /// ## Use Cases
    ///
    /// - **Performance Debugging**: Identify unnecessary view updates
    /// - **Layout Issues**: Understand why views are re-rendering
    /// - **SwiftUI Debugging**: Track view lifecycle changes
    @available(iOS 15.0, macOS 12, watchOS 8.0, tvOS 15.0, *)
    func printChanges() -> some View {
        let _ = Self._printChanges()
        return self
    }
    
    /// Logs the view's changes to the console with detailed information.
    ///
    /// This method provides more detailed change logging than `printChanges()`,
    /// including additional context about what triggered the view update.
    ///
    /// - Returns: The view with detailed change logging enabled.
    ///
    /// ## Example
    ///
    /// ```swift
    /// VStack {
    ///     Text("Dynamic Content")
    ///         .logChanges()
    /// }
    /// ```
    ///
    /// ## Use Cases
    ///
    /// - **Deep Debugging**: Get detailed view update information
    /// - **Performance Analysis**: Understand complex view hierarchies
    /// - **Development**: Temporary debugging during development
    @available(iOS 17.1, macOS 14.1, watchOS 10.1, tvOS 17.1, *)
    func logChanges() -> some View {
        let _ = Self._logChanges()
        return self
    }
    
    func print() -> some View {
        return PrintAction(self)()
    }
    
    func print(
        to output: some PrintOutput,
        with modifiers: (any PrintModifier)...
    ) -> some View {
        return PrintAction(self, to: output, with: modifiers)()
    }
    
    func print(
        to output: some PrintOutput,
        with modifiers: [any PrintModifier] = []
    ) -> some View {
        return PrintAction(self, to: output, with: modifiers)()
    }
    
    func print<T: CustomStringConvertible>(_ item: T) -> some View {
        PrintAction(item)()
        return self
    }
    
    func print<T: CustomStringConvertible>(
        _ item: T,
        to output: some PrintOutput,
        with modifiers: (any PrintModifier)...
    ) -> some View {
        PrintAction(item, to: output, with: modifiers)()
        return self
    }
    
    func print<T: CustomStringConvertible>(
        _ item: T,
        to output: some PrintOutput,
        with modifiers: [any PrintModifier] = []
    ) -> some View {
        PrintAction(item, to: output, with: modifiers)()
        return self
    }
}

#endif
