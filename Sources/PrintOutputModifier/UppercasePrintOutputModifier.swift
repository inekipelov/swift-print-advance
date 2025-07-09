//
//  UppercasePrintOutputModifier.swift
//

public struct UppercasePrintOutputModifier: PrintOutputModifier {
    public func modify(_ string: String) -> String {
        string.uppercased()
    }
}

public extension PrintOutput {
    var uppercased: ModifiedPrintOutput<Self> {
        modified(UppercasePrintOutputModifier())
    }
}
