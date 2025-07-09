import Foundation

public protocol PrintOutput: TextOutputStream {
    mutating func write(_ string: String)
}

public extension PrintOutput { 
    mutating func write(_ string: String) {
        fatalError("This method must be overridden in conforming types.")
    }
}
