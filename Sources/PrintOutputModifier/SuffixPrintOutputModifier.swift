//
//  SuffixPrintOutputModifier.swift
//

public struct SuffixPrintOutputModifier: PrintOutputModifier {
    let suffix: String
    public func modify(_ string: String) -> String {
        string + suffix
    }
}

public extension PrintOutput {
    func suffixed(with suffix: String) -> ModifiedPrintOutput<Self> {
        modified(SuffixPrintOutputModifier(suffix: suffix))
    }
}
