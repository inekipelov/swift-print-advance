//
//  TestModel.swift
//


struct TestModel: CustomStringConvertible {
    let name: String
    let value: Int
    
    var description: String {
        return "TestModel(name: \(name), value: \(value))"
    }
}
