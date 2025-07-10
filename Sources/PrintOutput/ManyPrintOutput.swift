//
//  ManyPrintOutput.swift
//

typealias ManyPrint = ManyPrintOutput

public final class ManyPrintOutput: PrintOutput {
    private var outputs: [any PrintOutput]
    
    public init(_ outputs: [any PrintOutput]) {
        self.outputs = outputs
    }
    
    public convenience init(_ outputs: any PrintOutput...) {
        self.init(outputs)
    }
    
    public func write(_ string: String) {
        for var output in outputs {
            output.write(string)
        }
    }
    
    /// Adds a new print output to the collection
    public func add(_ output: any PrintOutput) {
        outputs.append(output)
    }
    
    /// Removes all print outputs from the collection
    public func clear() {
        outputs.removeAll()
    }
    
    /// Returns the number of print outputs in the collection
    public var count: Int {
        return outputs.count
    }
}

public extension ManyPrintOutput {
    /// Creates a new ManyPrintOutput with the given outputs
    static func with(_ outputs: any PrintOutput...) -> ManyPrintOutput {
        return ManyPrintOutput(outputs)
    }
    
    /// Creates a new ManyPrintOutput with the given outputs array
    static func with(_ outputs: [any PrintOutput]) -> ManyPrintOutput {
        return ManyPrintOutput(outputs)
    }
}

public extension PrintOutput {
    func with(_ outputs: any PrintOutput...) -> ManyPrintOutput {
        return ManyPrintOutput([self] + outputs)
    }
    func with(_ outputs: [any PrintOutput]) -> ManyPrintOutput {
        return ManyPrintOutput([self] + outputs)
    }
}