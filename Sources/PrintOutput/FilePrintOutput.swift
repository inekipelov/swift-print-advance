//
//  FilePrintOutput.swift
//

import Foundation

typealias FilePrint = FilePrintOutput

public struct FilePrintOutput: PrintOutput {
    static let documentsFile: FilePrintOutput = {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = formatter.string(from: date)
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentDirectory
            .appendingPathComponent(timestamp)
            .appendingPathExtension("txt")
        
        let fileManager = FileManager.default.temporaryDirectory
        
        return try! FilePrintOutput(url: url)
    }()
    
    private let fileHandle: FileHandle
    let fileURL: URL
    
    public init(url: URL) throws {
        guard url.isFileURL else { throw URLError(.badURL) }
        var isDirectory: ObjCBool = false
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
            let isCreated = fileManager.createFile(atPath: url.path, contents: nil)
            guard isCreated else { throw URLError(.cannotCreateFile) }
        }
        guard !isDirectory.boolValue else { throw URLError(.fileIsDirectory) }
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

