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

private let pasteboardPrintSerialQueue = DispatchQueue(
    label: "com.swift-print-advance.PasteboardPrintOutput",
    qos: .utility
)

@available(iOS 9, macOS 10.13, *)
@available(watchOS, unavailable, message: "Pasteboard operations are not supported on watchOS")
@available(tvOS, unavailable, message: "Pasteboard operations are not practical on tvOS")
@available(iOSApplicationExtension, unavailable, message: "Pasteboard access is restricted in iOS Extensions")
public final class PasteboardPrintOutput: PrintOutput {
    static let general = PasteboardPrintOutput(pasteboard: .general)
    
    private(set) var buffer: String = ""
    let pasteboard: SystemPasteboard
    
    public init(pasteboard: SystemPasteboard = .general) {
        self.pasteboard = pasteboard
    }
    
    public func write(_ string: String) {
        pasteboardPrintSerialQueue.async { [weak self] in
            guard let self = self else { return }
            self.buffer.append(string)
            self.pendingUpdatePasteboard(with: self.buffer)
        }
    }
    
    /// Clears the internal buffer and pasteboard content
    public func clear() {
        pasteboardPrintSerialQueue.async { [weak self] in
            guard let self = self else { return }
            self.buffer = ""
            self.pendingUpdatePasteboard()
        }
    }

    private var pendingPasteboardUpdate: DispatchWorkItem?
}

private extension PasteboardPrintOutput {
    func pendingUpdatePasteboard(with content: String = "") {
        self.pendingPasteboardUpdate?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.updatePasteboard(with: content)
        }
        self.pendingPasteboardUpdate = workItem
        DispatchQueue.main
            .asyncAfter(deadline: .now() + 0.1, execute: workItem)
    }
    func updatePasteboard(with content: String = "") {
#if os(iOS)
        pasteboard.string = content
#elseif os(macOS)
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
#endif
    }
}

public extension PasteboardPrintOutput {
    var cleared: PasteboardPrintOutput {
        self.clear()
        return self
    }
}
