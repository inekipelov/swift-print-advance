//
//  Publisher+Print.swift
//

#if canImport(Combine)
import Combine

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension Publisher where Output: CustomStringConvertible {
    
    @available(*, deprecated, message: "Will be removed in future versions. Wait for new implementation for Combine.")
    func print(prefix: String = "", to output: some PrintOutput) -> Publishers.Print<Self> {
        return self.print(prefix, to: output)
    }
}

#endif
