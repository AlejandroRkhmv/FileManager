//
//  DataFileManager.swift
//  FileManager
//
//  Created by Александр Рахимов on 05.05.2024.
//

import Foundation
import FileProvider

enum FileManagerErrors: Error {
    case fileAlreadyExists
    case fileNotExists
    case invalidDirectory
    case writingFailed
    case readigFailed
}

final class DataFileManager {
    
    
    static let shared = DataFileManager()
    private init() {}
    
    private func makeURL(forFileName name: String, folderName: String) -> URL? {
        guard let urlFolder = getURL(for: folderName) else {
            return nil
        }
        return urlFolder.appendingPathComponent(name)
    }
    
    private func getURL(for folderName: String) -> URL? {
        guard let urlFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return urlFolder.appendingPathComponent(folderName)
    }
    
    private func createFolderIfNeeded(for folderName: String) {
        guard let folderUrl = getURL(for: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: folderUrl.path) {
            do {
                try FileManager.default.createDirectory(at: folderUrl, withIntermediateDirectories: true)
            } catch {
                print("can not create directory")
            }
        }
        
    }
    
    
    func save (fileName: String, folderName: String, data: Data) throws {
        createFolderIfNeeded(for: folderName)
        
        guard let url = makeURL(forFileName: fileName, folderName: folderName) else {
            throw FileManagerErrors.invalidDirectory
        }
        print(url)
        if FileManager.default.fileExists(atPath: url.absoluteString) {
            throw FileManagerErrors.fileAlreadyExists
        }
        do {
            try data.write(to: url)
        } catch {
            throw FileManagerErrors.writingFailed
        }
    }
    
    func read (fileName: String, folderName: String) throws -> Data {
        guard let url = makeURL(forFileName: fileName, folderName: folderName) else {
            throw FileManagerErrors.invalidDirectory
        }
        print(url)
        if FileManager.default.fileExists(atPath: url.absoluteString) {
            throw FileManagerErrors.fileNotExists
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            throw FileManagerErrors.readigFailed
        }
    }
}

