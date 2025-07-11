//
//  ManyPrintOutput.swift
//

/// Type alias for `ManyPrintOutput` for convenience.
public typealias ManyPrint = ManyPrintOutput

/// A print output that distributes writes to multiple underlying print outputs.
///
/// `ManyPrintOutput` allows you to write to multiple output destinations simultaneously.
/// This is useful when you want to output to both console and file, or any combination
/// of print outputs.
///
/// This class maintains a collection of print outputs and forwards all write operations
/// to each output in the collection. You can dynamically add or remove outputs from
/// the collection.
///
/// ## Example
///
/// ```swift
/// // This will write to both console and file
/// "Hello, World!".print(to: ConsolePrint()
///                             .with(FilePrint.documentsFile))
/// ```
///
/// ## Thread Safety
///
/// This class is not thread-safe. If you need to use it from multiple threads,
/// you should provide your own synchronization.
public final class ManyPrintOutput: PrintOutput {
    /// The collection of print outputs that will receive writes.
    private var outputs: [any PrintOutput]
    
    /// Creates a new `ManyPrintOutput` with the given array of outputs.
    /// - Parameter outputs: An array of print outputs to include in the collection.
    public init(_ outputs: [any PrintOutput]) {
        self.outputs = outputs
    }
    
    /// Creates a new `ManyPrintOutput` with the given variadic outputs.
    /// - Parameter outputs: A variadic list of print outputs to include in the collection.
    public convenience init(_ outputs: any PrintOutput...) {
        self.init(outputs)
    }
    
    /// Writes a string to all print outputs in the collection.
    /// - Parameter string: The string to write to all outputs.
    public func write(_ string: String) {
        for var output in outputs {
            output.write(string)
        }
    }
    
    /// Adds a new print output to the collection.
    /// - Parameter output: The print output to add to the collection.
    public func add(_ output: any PrintOutput) {
        outputs.append(output)
    }
    
    /// Removes all print outputs from the collection.
    public func clear() {
        outputs.removeAll()
    }
    
    /// Returns the number of print outputs in the collection.
    public var count: Int {
        return outputs.count
    }
}

public extension ManyPrintOutput {
    /// Creates a new `ManyPrintOutput` with the given variadic outputs.
    /// - Parameter outputs: A variadic list of print outputs to include.
    /// - Returns: A new `ManyPrintOutput` instance.
    static func with(_ outputs: any PrintOutput...) -> ManyPrintOutput {
        return ManyPrintOutput(outputs)
    }
    
    /// Creates a new `ManyPrintOutput` with the given array of outputs.
    /// - Parameter outputs: An array of print outputs to include.
    /// - Returns: A new `ManyPrintOutput` instance.
    static func with(_ outputs: [any PrintOutput]) -> ManyPrintOutput {
        return ManyPrintOutput(outputs)
    }
    
    /// Adds a print output to this collection and returns self for chaining.
    /// - Parameter output: The print output to add.
    /// - Returns: This `ManyPrintOutput` instance for method chaining.
    func with(_ output: any PrintOutput) -> ManyPrintOutput {
        self.add(output)
        return self
    }
}

public extension PrintOutput {
    /// Creates a `ManyPrintOutput` that includes this output and the given variadic outputs.
    /// - Parameter outputs: Additional print outputs to include.
    /// - Returns: A new `ManyPrintOutput` containing this output and the specified outputs.
    func with(_ outputs: any PrintOutput...) -> ManyPrintOutput {
        return ManyPrintOutput([self] + outputs)
    }
    
    /// Creates a `ManyPrintOutput` that includes this output and the given array of outputs.
    /// - Parameter outputs: An array of additional print outputs to include.
    /// - Returns: A new `ManyPrintOutput` containing this output and the specified outputs.
    func with(_ outputs: [any PrintOutput]) -> ManyPrintOutput {
        return ManyPrintOutput([self] + outputs)
    }
}
