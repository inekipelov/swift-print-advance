import Foundation

/// A protocol for objects that can modify strings before they are output.
///
/// `PrintOutputModifier` allows you to transform strings before they are written
/// to a print output destination. This enables functionality like adding timestamps,
/// prefixes, filtering, or any other string transformation.
///
/// Modifiers can be chained together to create complex string transformations.
/// They are applied to print outputs using the `modified(_:)` method.
///
/// ## Example
///
/// ```swift
/// struct UppercaseModifier: PrintOutputModifier {
///     func modify(_ string: String) -> String {
///         return string.uppercased()
///     }
/// }
/// ```
public protocol PrintOutputModifier {
    /// Modifies the input string and returns the transformed result.
    /// - Parameter string: The original string to modify.
    /// - Returns: The modified string.
    func modify(_ string: String) -> String
}
