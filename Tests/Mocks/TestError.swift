//
//  TestError.swift
//


enum TestError: Error, CustomStringConvertible {
    case testFailure(String)
    
    var description: String {
        switch self {
        case .testFailure(let message):
            return "TestError: \(message)"
        }
    }
}
