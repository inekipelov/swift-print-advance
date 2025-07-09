//
//  ReplacePrintOutputModifier.swift
//

import Foundation

public struct ReplacePrintOutputModifier: PrintOutputModifier {
    let target: String
    let replacement: String
    public func modify(_ string: String) -> String {
        string.replacingOccurrences(of: target, with: replacement)
    }
}

public extension PrintOutput {
    func replacingOccurrences(of target: String, with replacement: String) -> ModifiedPrintOutput<Self> {
        modified(ReplacePrintOutputModifier(target: target, replacement: replacement))
    }
}
