//
//  View+Print.swift
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension View {
    
    /// Prints the view's changes to the console.
    @available(iOS 15.0, macOS 12, watchOS 8.0, tvOS 15.0, *)
    func printChanges() -> some View {
        let _ = Self._printChanges()
        return self
    }
    
    /// Logs the view's changes to the console
    @available(iOS 17.1, macOS 14.1, watchOS 10.1, tvOS 17.1, *)
    func logChanges() -> some View {
        let _ = Self._logChanges()
        return self
    }
    
    func print() -> some View {
        Swift.print(self)
        return self
    }
    
    func print(to output: some PrintOutput) -> some View {
        var output = output
        Swift.print(self, to: &output)
        return self
    }
    
    func print<T: CustomStringConvertible>(_ items: T..., separator: String = " ", terminator: String = "\n") -> some View {
        Swift.print(items, separator: separator, terminator: terminator)
        return self
    }
    
    func print<T: CustomStringConvertible>(_ items: T..., separator: String = " ", terminator: String = "\n", to output: some PrintOutput) -> some View {
        var output = output
        Swift.print(items, separator: separator, terminator: terminator, to: &output)
        return self
    }
}

#endif
