//
//  PrefixPrintOutputModifier.swift
//

public struct PrefixPrintOutputModifier: PrintOutputModifier {
    let prefix: String
    public func modify(_ string: String) -> String {
        prefix + string
    }
}

public extension PrintOutput {
    func prefixed(with prefix: String) -> ModifiedPrintOutput<Self> {
        modified(PrefixPrintOutputModifier(prefix: prefix))
    }
}
