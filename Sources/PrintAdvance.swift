/// # PrintAdvance
///
/// A Swift package providing advanced printing capabilities with customizable outputs,
/// modifiers, and integrations for SwiftUI, Combine, and Result types.
///
/// ## Overview
///
/// PrintAdvance extends the standard Swift printing functionality with:
///
/// - **Custom Output Destinations**: Console, files, OS logs, pasteboard, and more
/// - **Output Modifiers**: Add timestamps, prefixes, filters, and transformations
/// - **Framework Integrations**: SwiftUI views, Combine publishers, and Result types
/// - **Extensible Architecture**: Create your own outputs and modifiers
///
/// ## Quick Start
///
/// ```swift
/// import PrintAdvance
///
/// // Basic usage with custom output
/// let fileOutput = FilePrintOutput(url: documentsURL.appendingPathComponent("log.txt"))
/// "Hello, World!".print(to: fileOutput)
///
/// // With modifiers
/// let timestampOutput = fileOutput.timestamp()
/// "Important message".print(to: timestampOutput)
/// ```
///
/// ## Topics
///
/// ### Print Outputs
/// - ``PrintOutput``
/// - ``ConsolePrintOutput``
/// - ``FilePrintOutput``
/// - ``OSLogPrintOutput``
/// - ``BufferPrintOutput``
/// - ``PasteboardPrintOutput``
/// - ``ManyPrintOutput``
/// - ``AnyPrintOutput``
///
/// ### Output Modifiers
/// - ``PrintOutputModifier``
/// - ``TimestampPrintOutputModifier``
/// - ``PrefixPrintOutputModifier``
/// - ``SuffixPrintOutputModifier``
/// - ``LabelPrintOutputModifier``
/// - ``FilterPrintOutputModifier``
/// - ``ReplacePrintOutputModifier``
/// - ``TracePrintOutputModifier``
/// - ``UppercasePrintOutputModifier``
///
/// ### Extensions
/// - <doc:CustomStringConvertible+Print>
/// - <doc:Publisher+Print>
/// - <doc:Result+Print>
/// - <doc:View+Print>
///
public struct PrintAdvance {
    /// The current version of the PrintAdvance library.
    public static let version = "1.0.0"
    
    /// Private initializer to prevent instantiation.
    private init() {}
}
