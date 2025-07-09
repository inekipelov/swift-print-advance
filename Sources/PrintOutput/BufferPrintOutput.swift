//
//  BufferPrintOutput.swift
//

typealias BufferPrint = BufferPrintOutput

public final class  BufferPrintOutput: PrintOutput {
    static let shared = BufferPrintOutput()
    private init() {}
    private(set) var buffer: String = ""
    
    public func write(_ string: String) {
        buffer += string
    }
    
    /// Clears the internal buffer and pasteboard content
    public func clear() {
        buffer.removeAll()
    }
}

public extension BufferPrintOutput {
    var cleared: BufferPrintOutput {
        self.clear()
        return self
    }
}
