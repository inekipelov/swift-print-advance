//
//  TracePrintModifier.swift
//

import Foundation

public struct TracePrintModifier: PrintModifier {

    let line: Int
        
    let function: String
    
    let file: String
    
    public init(
        _ line: Int = #line,
        _ function: String = #function,
        _ file: String = #file
    ) {
        self.line = line
        self.file = file
        self.function = function
    }
    
    public func callAsFunction(input string: String) -> String {
        let fileName = (file as NSString).lastPathComponent
        return "[\(line):\(function):\(fileName)] \(string)"
    }
}
