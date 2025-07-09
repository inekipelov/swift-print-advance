//
//  FilePrintOutput.swift
//

import Foundation

typealias FilePrint = FilePrintOutput

public struct FilePrintOutput: PrintOutput {
    private let fileHandle: FileHandle
    let fileURL: URL
    
    public init(url: URL) throws {
        guard url.isFileURL else { throw URLError(.badURL) }
        var isDirectory: ObjCBool = false
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
            guard !isDirectory.boolValue else { throw URLError(.fileIsDirectory) }
            let isCreated = fileManager.createFile(atPath: url.path, contents: nil)
            guard isCreated else { throw URLError(.cannotCreateFile) }
        }
        guard let fileHandle = try? FileHandle(forWritingTo: url) else {
            throw URLError(.resourceUnavailable)
        }
        self.fileURL = url
        self.fileHandle = fileHandle
    }
    
    public mutating func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
    }
}

