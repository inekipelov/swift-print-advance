import Foundation

public protocol PrintOutputModifier {
    func modify(_ string: String) -> String
}
