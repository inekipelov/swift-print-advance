//
//  PasteboardPrintOutput.swift
//

#if os(iOS) || os(tvOS)
import UIKit
public typealias SystemPasteboard = UIPasteboard
#elseif os(macOS)
import AppKit
public typealias SystemPasteboard = NSPasteboard
#endif

typealias PasteboardPrint = PasteboardPrintOutput

@available(iOS 9, macOS 10.13, tvOS 9, *)
public final class PasteboardPrintOutput: PrintOutput {
    static let general = PasteboardPrintOutput(pasteboard: .general)
    
    private(set) var buffer: [String] = []
    let pasteboard: SystemPasteboard
    
    public init(pasteboard: SystemPasteboard = .general) {
        self.pasteboard = pasteboard
    }
    
    public func write(_ string: String) {
        buffer.append(string)
        let joined = buffer.joined(separator: "")
#if os(iOS) || os(tvOS)
        pasteboard.string = joined
#elseif os(macOS)
        pasteboard.clearContents()
        pasteboard.setString(joined, forType: .string)
#endif
    }
    
    /// Clears the internal buffer and pasteboard content
    public func clear() {
        buffer.removeAll()
#if os(iOS) || os(tvOS)
        pasteboard.string = ""
#elseif os(macOS)
        pasteboard.clearContents()
#endif
    }
    
    /// Returns the current content of the buffer as a single string
    public var content: String {
        return buffer.joined(separator: "")
    }
}

public extension PasteboardPrintOutput {
    var cleared: PasteboardPrintOutput {
        self.clear()
        return self
    }
}
