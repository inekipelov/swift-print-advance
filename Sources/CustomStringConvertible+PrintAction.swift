//
//  CustomStringConvertible+PrintAction.swift
//

public extension CustomStringConvertible {
    
    @discardableResult
    func print() -> Self {
        return PrintAction(self)()
    }
    
    @discardableResult
    func print(to output: some PrintOutput, with modifiers: (any PrintModifier)...) -> Self {
        return PrintAction(self, to: output, with: modifiers)()
    }
    
    @discardableResult
    func print(to output: some PrintOutput, with modifiers: [any PrintModifier] = []) -> Self {
        return PrintAction(self, to: output, with: modifiers)()
    }
}
