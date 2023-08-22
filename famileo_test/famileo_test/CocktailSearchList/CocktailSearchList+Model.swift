//
//  CocktailSearchListModel.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 16/08/2023.
//

import Foundation


class CocktailSearchListModel {
    @Inject(name: .store)
    var store: Store
    
    var cocktails: [Cocktail] {
        store.cocktails
    }
    
    init() {
    }
    
    var sectionCount: Int {
        return cocktails.count
    }
    
    func searchCocktails(_ search: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        ServiceManager().fetchCocktails(search, completion: { result in
            switch result {
            case .success():
                completion(.success(()))
            case .failure(let failure):
                completion(.failure(failure))
            }
            
        })
    }
}
