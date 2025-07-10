//
//  View+Print.swift
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
    
    /// Prints the view's description to the console and returns the view.
    ///
    /// This method prints the view's string representation to the standard output.
    /// It's useful for quick debugging and understanding view structure.
    ///
    /// - Returns: The view unchanged for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Text("Debug me")
    ///     .print()
    ///     .foregroundColor(.blue)
    /// ```
    func print() -> some View {
        Swift.print(self)
        return self
    }
    
    /// Prints the view's description to the specified output and returns the view.
    ///
    /// This method prints the view's string representation to the provided print output,
    /// allowing for flexible output destinations.
    ///
    /// - Parameter output: The print output destination to write to.
    /// - Returns: The view unchanged for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let fileOutput = try FilePrintOutput(url: logURL)
    /// 
    /// Text("Log this view")
    ///     .print(to: fileOutput)
    ///     .padding()
    /// ```
    func print(to output: some PrintOutput) -> some View {
        var output = output
        Swift.print(self, to: &output)
        return self
    }
    
    /// Prints custom items to the console and returns the view.
    ///
    /// This method allows printing arbitrary content alongside the view for debugging.
    /// It's particularly useful for logging state values or other contextual information.
    ///
    /// - Parameters:
    ///   - items: The items to print.
    ///   - separator: The separator between items. Defaults to a space.
    ///   - terminator: The terminator after all items. Defaults to a newline.
    /// - Returns: The view unchanged for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// Text("User: \(username)")
    ///     .print("Current user:", username, "logged in at:", Date())
    /// ```
    func print<T: CustomStringConvertible>(_ items: T..., separator: String = " ", terminator: String = "\n") -> some View {
        Swift.print(items, separator: separator, terminator: terminator)
        return self
    }
    
    /// Prints custom items to the specified output and returns the view.
    ///
    /// This method allows printing arbitrary content to a specific output destination
    /// alongside the view. It's useful for logging contextual information to files or other outputs.
    ///
    /// - Parameters:
    ///   - items: The items to print.
    ///   - separator: The separator between items. Defaults to a space.
    ///   - terminator: The terminator after all items. Defaults to a newline.
    ///   - output: The print output destination to write to.
    /// - Returns: The view unchanged for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let debugOutput = BufferPrintOutput.shared
    /// 
    /// Text("Current state")
    ///     .print("State:", viewModel.state, "at:", Date(), to: debugOutput)
    /// ```
    func print<T: CustomStringConvertible>(_ items: T..., separator: String = " ", terminator: String = "\n", to output: some PrintOutput) -> some View {
        var output = output
        Swift.print(items, separator: separator, terminator: terminator, to: &output)
        return self
    }
}

#endif
