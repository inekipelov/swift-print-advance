//
//  FilterPrintOutputModifier.swift
//

public struct FilterPrintOutputModifier: PrintOutputModifier {
    let shouldPrint: (String) -> Bool
    public func modify(_ string: String) -> String {
        shouldPrint(string) ? string : ""
    }
}

public extension PrintOutput {
    func filtered(using shouldPrint: @escaping (String) -> Bool) -> ModifiedPrintOutput<Self> {
        modified(FilterPrintOutputModifier(shouldPrint: shouldPrint))
    }
}
