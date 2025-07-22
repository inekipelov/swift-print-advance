//
//  ColorPrintModifier.swift
//

import Foundation

/// A print modifier that adds ANSI color codes to output strings.
///
/// `ColorPrintModifier` enhances terminal output by applying colors and text styles
/// using ANSI escape codes. This makes it easier to distinguish different types
/// of output and improves readability in terminal environments.
///
/// The modifier supports foreground colors, background colors, and text styles
/// like bold, italic, and underline. Colors are applied using standard ANSI
/// escape sequences that work in most modern terminals.
///
/// ## Example
///
/// ```swift
/// let redModifier = ColorPrintModifier(foreground: .red, style: .bold)
/// let result = redModifier("Error occurred!")
/// // Output: "\u{001B}[31;1mError occurred!\u{001B}[0m" (displays as bold red text)
/// ```
public struct ColorPrintModifier: PrintModifier {
    
    /// ANSI color codes for foreground colors.
    public enum Color: String, CaseIterable {
        case black = "30"
        case red = "31"
        case green = "32"
        case yellow = "33"
        case blue = "34"
        case magenta = "35"
        case cyan = "36"
        case white = "37"
        case brightBlack = "90"
        case brightRed = "91"
        case brightGreen = "92"
        case brightYellow = "93"
        case brightBlue = "94"
        case brightMagenta = "95"
        case brightCyan = "96"
        case brightWhite = "97"
    }
    
    /// ANSI color codes for background colors.
    public enum BackgroundColor: String, CaseIterable {
        case black = "40"
        case red = "41"
        case green = "42"
        case yellow = "43"
        case blue = "44"
        case magenta = "45"
        case cyan = "46"
        case white = "47"
        case brightBlack = "100"
        case brightRed = "101"
        case brightGreen = "102"
        case brightYellow = "103"
        case brightBlue = "104"
        case brightMagenta = "105"
        case brightCyan = "106"
        case brightWhite = "107"
    }
    
    /// ANSI style codes for text formatting.
    public enum Style: String, CaseIterable {
        case bold = "1"
        case dim = "2"
        case italic = "3"
        case underline = "4"
        case blink = "5"
        case reverse = "7"
        case strikethrough = "9"
    }
    
    /// The foreground color to apply.
    private let foregroundColor: Color?
    
    /// The background color to apply.
    private let backgroundColor: BackgroundColor?
    
    /// The text styles to apply.
    private let styles: [Style]
    
    /// Creates a new color print modifier.
    ///
    /// - Parameters:
    ///   - foreground: The foreground color to apply (optional)
    ///   - background: The background color to apply (optional)
    ///   - styles: Text styles to apply (default: empty)
    ///   - forceColor: Force color output even in non-terminal environments (default: false)
    public init(
        foreground: Color? = nil,
        background: BackgroundColor? = nil,
        styles: [Style] = []
    ) {
        self.foregroundColor = foreground
        self.backgroundColor = background
        self.styles = styles
    }
    
    /// Modifies the input string by adding ANSI color codes.
    ///
    /// This method wraps the input string with appropriate ANSI escape sequences
    /// for colors and styles, and adds a reset sequence at the end to restore
    /// normal formatting.
    ///
    /// - Parameter string: The original string to colorize.
    /// - Returns: The string with ANSI color codes applied.
    public func callAsFunction(input string: String) -> String {
        // Skip coloring if not in a terminal environment
        if !Self.isTerminalEnvironment {
            return string
        }
        
        var codes: [String] = []
        
        // Add foreground color
        if let fg = foregroundColor {
            codes.append(fg.rawValue)
        }
        
        // Add background color
        if let bg = backgroundColor {
            codes.append(bg.rawValue)
        }
        
        // Add styles
        codes.append(contentsOf: styles.map { $0.rawValue })
        
        // If no codes to apply, return original string
        guard !codes.isEmpty else { return string }
        
        let escapeSequence = "\u{001B}[\(codes.joined(separator: ";"))m"
        let resetSequence = "\u{001B}[0m"
        
        return "\(escapeSequence)\(string)\(resetSequence)"
    }
}

private extension ColorPrintModifier {
/// Determines if the current environment supports terminal colors.
    static var isTerminalEnvironment: Bool {
        // Check if stdout is a terminal
        guard isatty(STDOUT_FILENO) != 0 else { return false }
        
        // Check environment variables that indicate color support
        let termEnv = ProcessInfo.processInfo.environment["TERM"] ?? ""
        let colorTerm = ProcessInfo.processInfo.environment["COLORTERM"]
        
        return termEnv.contains("color") || 
               termEnv.contains("xterm") || 
               colorTerm != nil ||
               termEnv == "screen" ||
               termEnv == "tmux"
    }
}

/// Convenience initializers for common color combinations.
public extension ColorPrintModifier {
    /// Creates a modifier for error messages (bright red, bold).
    static var error: ColorPrintModifier {
        ColorPrintModifier(foreground: .brightRed, styles: [.bold])
    }
    
    /// Creates a modifier for warning messages (bright yellow, bold).
    static var warning: ColorPrintModifier {
        ColorPrintModifier(foreground: .brightYellow, styles: [.bold])
    }
    
    /// Creates a modifier for success messages (bright green, bold).
    static var success: ColorPrintModifier {
        ColorPrintModifier(foreground: .brightGreen, styles: [.bold])
    }
    
    /// Creates a modifier for info messages (bright blue).
    static var info: ColorPrintModifier {
        ColorPrintModifier(foreground: .brightBlue)
    }
    
    /// Creates a modifier for debug messages (dim white).
    static var debug: ColorPrintModifier {
        ColorPrintModifier(foreground: .white, styles: [.dim])
    }
}
