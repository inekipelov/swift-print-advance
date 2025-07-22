//
//  PrintAction.swift
//

@dynamicMemberLookup
public struct PrintAction<Subject> {
    let subject: Subject
    private(set) var output: (any PrintOutput)?
    private var modifiers: [any PrintModifier] = []
    
    init(
        _ subject: Subject,
        to output: (any PrintOutput)? = nil,
        with modifiers: [any PrintModifier] = []
    ) {
        self.subject = subject
        self.output = output
        self.modifiers = modifiers
    }
    
    init(
        _ subject: Subject,
        to output: (any PrintOutput)? = nil,
        with modifiers: (any PrintModifier)...
    ) {
        self.subject = subject
        self.output = output
        self.modifiers = modifiers
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<Subject, T>) -> T {
        subject[keyPath: keyPath]
    }
}

private extension PrintAction {
    var printableString: String {
        var description: String
        if let subject = subject as? CustomStringConvertible {
            description = subject.description
        } else {
            description = String(describing: subject)
        }
        var modified: String
        if !modifiers.isEmpty {
            modified = description
        } else {
            modified = modifiers.reversed().reduce(description) { result, modifier in
                modifier(input: result)
            }
        }
        return modified
    }
}

public extension PrintAction {
    @discardableResult
    func callAsFunction() -> Subject {
        if var output = output {
            output.write(printableString)
        } else {
            Swift.print(subject)
        }
        
        return subject
    }
}
