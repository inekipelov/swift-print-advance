//
//  PrintModifier.swift
//

public protocol PrintModifier {
    func callAsFunction(input string: String) -> String
}

public extension PrintModifier {
    func callAsFunction(input string: String) -> String {
        return string
    }
}
