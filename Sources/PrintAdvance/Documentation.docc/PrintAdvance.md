# ``PrintAdvance``

Advanced print utilities for Swift with chainable extensions and flexible output destinations.

## Overview

PrintAdvance provides a comprehensive set of tools for enhanced printing and logging in Swift applications. It extends the standard library's printing capabilities with chainable methods, flexible output destinations, and powerful modifiers.

### Key Features

- **Chainable Print Methods**: Print values without breaking method chains
- **Flexible Output Destinations**: Console, files, system logs, pasteboard, and more
- **Output Modifiers**: Transform output with filters, prefixes, timestamps, and more
- **SwiftUI Integration**: Print view changes and debug information
- **Combine Support**: Debug publishers with enhanced print operators
- **Cross-Platform**: Works on iOS, macOS, tvOS, and watchOS

## Topics

### Getting Started

- <doc:QuickStart>
- <doc:Installation>
- <doc:Tutorial>

### Core Extensions

- <doc:CoreExtensions>

### Print Outputs

- ``PrintOutput``
- ``ConsolePrintOutput``
- ``FilePrintOutput``
- ``OSLogPrintOutput``
- ``BufferPrintOutput``
- ``PasteboardPrintOutput``
- ``ManyPrintOutput``

### Output Modifiers

- ``PrintOutputModifier``
- ``LabelPrintOutputModifier``
- ``PrefixPrintOutputModifier``
- ``SuffixPrintOutputModifier``
- ``TimestampPrintOutputModifier``
- ``FilterPrintOutputModifier``
- ``ReplacePrintOutputModifier``
- ``TracePrintOutputModifier``
- ``UppercasePrintOutputModifier``

### Framework Integration

- <doc:SwiftUIIntegration>
- <doc:CombineIntegration>
- <doc:ResultUtilities>

### Advanced Usage

- <doc:CustomOutputs>
- <doc:ModifyingOutputs>
- <doc:PerformanceConsiderations>
- <doc:Troubleshooting>
