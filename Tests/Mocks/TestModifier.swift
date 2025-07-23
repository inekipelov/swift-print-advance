//
//  TestModifier.swift
//

import PrintAdvance

struct TestModifier: PrintModifier {
    let prefix: String
    
    func callAsFunction(input string: String) -> String {
        return "\(prefix): \(string)"
    }
}
