//
//  LabelPrintOutputModifier.swift
//

public struct LabelPrintOutputModifier: PrintOutputModifier {
    let label: String
    public func modify(_ string: String) -> String {
        "\(label.lowercased()) = \(string)"
    }
}

public extension PrintOutput {
    func labeled(_ label: String) -> ModifiedPrintOutput<Self> {
        modified(LabelPrintOutputModifier(label: label))
    }
}
