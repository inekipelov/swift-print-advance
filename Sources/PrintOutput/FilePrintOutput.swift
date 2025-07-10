//
//  FilePrintOutput.swift
//

import Foundation

typealias FilePrint = FilePrintOutput

private let filePrintSerialQueue = DispatchQueue(
    label: "com.swift-print-advance.FilePrintOutput",
    qos: .utility
)

@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
@available(watchOS, unavailable, message: "File operations are not supported on watchOS")
@available(iOSApplicationExtension, unavailable, message: "Document directory access is restricted in iOS Extensions")
public final class FilePrintOutput: PrintOutput {
    static let documentsFile: FilePrintOutput = {
        let timestamp: String = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
            return formatter.string(from: Date())
        }()
        
        let fileURL: URL = {
            URL.directory(.documentDirectory)
                .appendingPathComponent(timestamp)
                .appendingPathExtension("txt")
        }()
        
        do {
            return try FilePrintOutput(url: fileURL)
        } catch {
            fatalError("Failed to create FilePrintOutput at \(fileURL): \(error)")
        }
    }()
    
    private let fileHandle: FileHandle
    let fileURL: URL
    
    public init(url: URL) throws {
        try url.createFileIfNeeded()
        guard let fileHandle = try? FileHandle(forWritingTo: url) else {
            throw URLError(.resourceUnavailable)
        }
        self.fileURL = url
        self.fileHandle = fileHandle
    }
    
    public func write(_ string: String) {
        filePrintSerialQueue.async { [fileHandle] in
            let data = Data(string.utf8)
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
        }
    }
    
    deinit {
        fileHandle.closeFile()
    }
}

private extension URL {
    static func directory(_ directory: FileManager.SearchPathDirectory) -> URL {
        return FileManager.default.urls(for: directory, in: .userDomainMask)[0]
    }

    var isExist: Bool {
        FileManager.default.fileExists(atPath: self.path)
    }
    
    var isDirectory: Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: self.path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    
    func createFileIfNeeded() throws {
        guard self.isFileURL else { throw URLError(.badURL) }
        guard !self.isDirectory else { throw URLError(.fileIsDirectory) }
        guard !self.isExist else { return }
        let isCreated = FileManager.default.createFile(
            atPath: self.path,
            contents: nil
        )
        guard isCreated else { throw URLError(.cannotCreateFile) }
    }
}

