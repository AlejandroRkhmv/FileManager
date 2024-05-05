//
//  NetworkService.swift
//  FileManager
//
//  Created by Александр Рахимов on 05.05.2024.
//

import Foundation
import Combine

enum Errors: Error {
    case failed
    case dataIsNill
}

final class NetworkService {
    
    func getData(for string: String) -> AnyPublisher<Data, Errors> {
        guard let url = URL(string: string) else {
            return Fail<Data, Errors>(error: Errors.failed).eraseToAnyPublisher()
        }
        
        let future = Future<Data, Errors> { promice in
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                
                guard error == nil else {
                    promice(.failure(.failed))
                    return
                }
                
                guard let data = data else {
                    promice(.failure(.dataIsNill))
                    return
                }
                
                promice(.success(data))
            }
            task.resume()
            
        }.eraseToAnyPublisher()
        
        return future
    }
    
}

