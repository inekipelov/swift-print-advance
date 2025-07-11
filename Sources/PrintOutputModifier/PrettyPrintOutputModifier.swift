//
//  PrettyPrintOutputModifier.swift
//

import Foundation

/// A print output modifier that formats strings with pretty-printing.
///
/// `PrettyPrintOutputModifier` transforms input strings to make them more readable
/// by adding proper indentation, line breaks, and formatting. It's particularly
/// useful for formatting structured data like JSON, XML, or nested objects.
///
/// The modifier supports multiple formatting styles including JSON-like formatting,
/// indented structure formatting, and custom beautification rules.
///
/// ## Example
///
/// ```swift
/// let jsonString = """
/// {"name":"John","age":30,"city":"New York","hobbies":["reading","gaming"]}
/// """
/// jsonString.print(to: ConsolePrint().prettyPrinted())
/// // Output:
/// // {
/// //   "name": "John",
/// //   "age": 30,
/// //   "city": "New York",
/// //   "hobbies": [
/// //     "reading",
/// //     "gaming"
/// //   ]
/// // }
/// ```
public struct PrettyPrintOutputModifier: PrintOutputModifier {
    
    /// The indentation style to use for formatting.
    public enum Spacing {
        case spaces(Int)
        case tabs
    }
    
    /// The formatting style to apply.
    public enum Format {
        case json
        case structured
        case minimal
    }
    
    /// The indentation style used for formatting.
    private let spacing: Spacing
    
    /// The formatting style to apply.
    private let format: Format
    
    /// The maximum line length before wrapping.
    private let maxLineLength: Int
    
    /// Creates a new pretty print output modifier.
    /// - Parameters:
    ///   - indentationStyle: The indentation style to use (default: 2 spaces)
    ///   - formattingStyle: The formatting style to apply (default: .json)
    ///   - maxLineLength: Maximum line length before wrapping (default: 80)
    public init(
        spacing: Spacing = .spaces(2),
        format: Format = .json,
        maxLineLength: Int = 80
    ) {
        self.spacing = spacing
        self.format = format
        self.maxLineLength = maxLineLength
    }
    
    /// Modifies the input string by applying pretty-printing formatting.
    /// - Parameter string: The original string to format.
    /// - Returns: The pretty-printed string.
    public func modify(_ string: String) -> String {
        return switch format {
        case .json: formatJSON(string)
        case .structured: formatStructured(string)
        case .minimal: formatMinimal(string)
        }
    }
}

// MARK: - Private Methods
private extension PrettyPrintOutputModifier {
    
    /// Formats a string as JSON with proper indentation.
    func formatJSON(_ string: String) -> String {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Try to parse as JSON first
        if let data = trimmed.data(using: .utf8),
           let jsonObject = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys]),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            return adjustIndentation(prettyString)
        }
        
        // Fallback to manual formatting if not valid JSON
        return formatStructured(string)
    }
    
    /// Formats a string with structured indentation.
    func formatStructured(_ string: String) -> String {
        var result = ""
        var currentIndent = 0
        var inString = false
        var escapeNext = false
        
        for char in string {
            if escapeNext {
                result.append(char)
                escapeNext = false
                continue
            }
            
            if char == "\\" {
                escapeNext = true
                result.append(char)
                continue
            }
            
            if char == "\"" {
                inString.toggle()
                result.append(char)
                continue
            }
            
            if inString {
                result.append(char)
                continue
            }
            
            switch char {
            case "{", "[":
                result.append(char)
                result.append("\n")
                currentIndent += 1
                result.append(String(repeating: spacing.string, count: currentIndent))
                
            case "}", "]":
                if result.last == " " || result.last?.isWhitespace == true {
                    result = String(result.dropLast())
                }
                result.append("\n")
                currentIndent = max(0, currentIndent - 1)
                result.append(String(repeating: spacing.string, count: currentIndent))
                result.append(char)
                
            case ",":
                result.append(char)
                result.append("\n")
                result.append(String(repeating: spacing.string, count: currentIndent))
                
            case ":":
                result.append(char)
                result.append(" ")
                
            case " ", "\t", "\n", "\r":
                    // Skip whitespace in structured mode
                continue
                
            default:
                result.append(char)
            }
        }
        
        return result
    }
    
    /// Formats a string with minimal formatting.
    func formatMinimal(_ string: String) -> String {
        return string
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Adjusts indentation in a pre-formatted string to match the configured style.
    func adjustIndentation(_ string: String) -> String {
        let lines = string.components(separatedBy: .newlines)
        var result: [String] = []
        
        for line in lines {
            let leadingSpaces = line.prefix { $0 == " " }.count
            let indentLevel = leadingSpaces / 2 // Assuming 2-space default from JSONSerialization
            let content = line.trimmingCharacters(in: .whitespaces)
            
            if content.isEmpty {
                result.append("")
            } else {
                let newIndent = String(repeating: spacing.string, count: indentLevel)
                result.append(newIndent + content)
            }
        }
        
        return result.joined(separator: "\n")
    }
}

private extension PrettyPrintOutputModifier.Spacing {
    var string: String {
        switch self {
        case .spaces(let count):
            return String(repeating: " ", count: count)
        case .tabs:
            return "\t"
        }
    }
}

// MARK: - PrintOutput Extensions

public extension PrintOutput {
    /// Returns a modified print output that applies pretty-printing formatting.
    /// - Parameters:
    ///   - indentationStyle: The indentation style to use (default: 2 spaces)
    ///   - formattingStyle: The formatting style to apply (default: .json)
    ///   - maxLineLength: Maximum line length before wrapping (default: 80)
    /// - Returns: A modified print output with pretty-printing applied.
    func prettyPrinted(
        spacing: PrettyPrintOutputModifier.Spacing = .spaces(2),
        format: PrettyPrintOutputModifier.Format = .json,
        maxLineLength: Int = 80
    ) -> some PrintOutput {
        return modified(
            PrettyPrintOutputModifier(
                spacing: spacing,
                format: format,
                maxLineLength: maxLineLength
            )
        )
    }
}
