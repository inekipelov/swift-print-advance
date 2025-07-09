import Foundation

@dynamicMemberLookup
public struct ModifiedPrintOutput<Root: PrintOutput>: PrintOutput {
    private(set) var root: Root
    let modifier: PrintOutputModifier

    public mutating func write(_ string: String) {
        root.write(modifier.modify(string))
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<Root, T>) -> T {
        root[keyPath: keyPath]
    }
}

public extension PrintOutput {
    func modified(_ modifier: PrintOutputModifier) -> ModifiedPrintOutput<Self> {
        ModifiedPrintOutput(root: self, modifier: modifier)
    }
}
