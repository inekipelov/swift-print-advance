//
//  TracePrintOutputModifier.swift
//

import Foundation

public struct TracePrintOutputModifier: PrintOutputModifier {
    let function: String
    let file: String
    let line: Int

    public func modify(_ string: String) -> String {
        let fileName = (file as NSString).lastPathComponent
        return "[\(fileName) -> \(line):\(function)] \(string)"
    }
}

public extension PrintOutput {
    func trace(
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) -> ModifiedPrintOutput<Self> {
        self.modified(
            TracePrintOutputModifier(
                function: function,
                file: file,
                line: line
            )
        )
    }
}
