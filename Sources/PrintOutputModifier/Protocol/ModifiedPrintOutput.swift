import Foundation

/// A wrapper that applies a modifier to a print output.
///
/// `ModifiedPrintOutput` combines a print output with a modifier to transform
/// strings before they are written to the underlying output destination.
///
/// This structure uses `@dynamicMemberLookup` to provide transparent access
/// to the underlying print output's properties while applying modifications
/// to the written strings.
///
/// ## Example
///
/// ```swift
/// let modifiedOutput = ConsolePrint().modified(PrefixPrintOutputModifier(prefix: "[LOG] "))
/// ```
@dynamicMemberLookup
public struct ModifiedPrintOutput<Root: PrintOutput>: PrintOutput {
    /// The underlying print output that will receive the modified strings.
    private(set) var root: Root
    /// The modifier that will transform strings before output.
    let modifier: PrintOutputModifier

    /// Writes a string to the underlying output after applying the modifier.
    /// - Parameter string: The string to modify and write.
    public mutating func write(_ string: String) {
        root.write(modifier.modify(string))
    }
    
    /// Provides dynamic member lookup access to the underlying print output.
    /// - Parameter keyPath: The key path to the desired property.
    /// - Returns: The value of the property from the underlying output.
    public subscript<T>(dynamicMember keyPath: KeyPath<Root, T>) -> T {
        root[keyPath: keyPath]
    }
}

public extension PrintOutput {
    /// Creates a modified version of this print output with the given modifier.
    /// 
    /// This method allows you to chain modifiers to create complex string transformations.
    /// 
    /// - Parameter modifier: The modifier to apply to strings written to this output.
    /// - Returns: A new `ModifiedPrintOutput` that applies the modifier before writing.
    /// 
    /// ## Example
    /// 
    /// ```swift
    /// let output = ConsolePrintOutput()
    ///     .modified(PrefixPrintOutputModifier(prefix: "[INFO] "))
    ///     .modified(TimestampPrintOutputModifier())
    /// ```
    func modified(_ modifier: PrintOutputModifier) -> ModifiedPrintOutput<Self> {
        ModifiedPrintOutput(root: self, modifier: modifier)
    }
}
