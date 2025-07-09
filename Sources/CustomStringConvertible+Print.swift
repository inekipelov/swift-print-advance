//
//  CustomStringConvertible+Print.swift
//

public extension CustomStringConvertible {
    @discardableResult
    func print() -> Self {
        Swift.print(self)
        return self
    }
    
    @discardableResult
    func print(to output: some PrintOutput) -> Self {
        var output = output
        Swift.print(self, to: &output)
        return self
    }
}
