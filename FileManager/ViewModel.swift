//
//  ViewModel.swift
//  FileManager
//
//  Created by Александр Рахимов on 05.05.2024.
//

import Foundation
import Combine

final class ViewModel: ObservableObject {
    
    let urlString = "https://stunodracing.net/index.php?attachments/redbull-racing-team-png.128674/"
    let networkService = NetworkService()
    var data: Data?
    private var store: AnyCancellable?
    
    func loadData() {
        store = networkService.getData(for: urlString)
            .sink { completion in
                switch completion {
                case .finished:
                    print("success")
                case .failure(.dataIsNill):
                    print("data is nill")
                case .failure(.failed):
                    print("failed")
                }
            } receiveValue: { [weak self] data in
                guard let self else { return }
                self.data = data
                self.objectWillChange.send()
            }
    }
    
    func save() {
        guard let data = self.data else { return }
        do {
            try DataFileManager.shared.save(fileName: "redBullFolder", folderName: "redBull", data: data)
        } catch FileManagerErrors.fileAlreadyExists {
            print("already exist")
        } catch FileManagerErrors.invalidDirectory {
            print("invalid dir")
        } catch FileManagerErrors.writingFailed {
            print("writting error")
        } catch {
            print("qwe")
        }
    }
    
    func read() {
        do {
            self.data = try DataFileManager.shared.read(fileName: "redBullFolder", folderName: "redBull")
            self.objectWillChange.send()
            print("succes")
        } catch FileManagerErrors.fileNotExists {
            print("not exist")
        } catch FileManagerErrors.invalidDirectory {
            print("invalid dir")
        } catch FileManagerErrors.readigFailed {
            print("reading error")
        } catch {
            print("123")
        }
    }
}

