//
//  BufferPrintOutput.swift
//

import Dispatch

typealias BufferPrint = BufferPrintOutput

private let bufferPrintSerialQueue = DispatchQueue(
    label: "com.swift-print-advance.BufferPrintOutput",
    qos: .utility
)

public final class  BufferPrintOutput: PrintOutput {
    static let shared = BufferPrintOutput()
    private init() {}
    private(set) var buffer: String = ""
    
    public func write(_ string: String) {
        bufferPrintSerialQueue.async { [weak self] in
            guard let self = self else { return }
            self.buffer.append(string)
        }
    }
    
    /// Clears the internal buffer and pasteboard content
    public func clear() {
        bufferPrintSerialQueue.async { [weak self] in
            guard let self = self else { return }
            self.buffer.removeAll()
        }
    }
}

public extension BufferPrintOutput {
    var cleared: BufferPrintOutput {
        self.clear()
        return self
    }
}
