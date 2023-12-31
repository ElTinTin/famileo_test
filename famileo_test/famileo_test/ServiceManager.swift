//
//  Services.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 18/08/2023.
//

import Foundation

enum APIError: Error {
    case noData
    case httpError
}

class ServiceManager {
    func fetchCocktails(_ search: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        let store = DependencyResolver.resolve(name: .store, type: Store.self)
        
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(search)") else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching cocktails: \(error)")
                completion(.failure(.httpError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.httpError))
                return
            }
            
            if let data = data,
               let searchResult = try? JSONDecoder().decode(Search.self, from: data) {
                DispatchQueue.main.async {
                    store.cocktails = searchResult.drinks
                    completion(.success(()))
                }
            } else {
                completion(.failure(.noData))
            }
        })
        task.resume()
    }
}
