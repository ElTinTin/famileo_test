//
//  CocktailDetail+Model.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 22/08/2023.
//

import Foundation

class CocktailDetailModel {
    @Inject(name: .store)
    var store: Store
    
    var cocktail: Cocktail?
    var cocktails: [Cocktail]?
    var index: Int?
    
    init(_ cocktails: [Cocktail], _ index: IndexPath) {
        self.cocktail = cocktails.get(index: index.row)
        self.cocktails = cocktails
        self.index = index.row
    }
    
    func ingredients() -> [String:String] {
        var dictionary: [String: String] = [:]
        
        let ingredients: [String?] = [cocktail?.ingredient1, cocktail?.ingredient2, cocktail?.ingredient3, cocktail?.ingredient4, cocktail?.ingredient5, cocktail?.ingredient6, cocktail?.ingredient7, cocktail?.ingredient8, cocktail?.ingredient9, cocktail?.ingredient10, cocktail?.ingredient11, cocktail?.ingredient12, cocktail?.ingredient13, cocktail?.ingredient14, cocktail?.ingredient15]
        let measures: [String?] = [cocktail?.measure1, cocktail?.measure2, cocktail?.measure3, cocktail?.measure4, cocktail?.measure5, cocktail?.measure6, cocktail?.measure7, cocktail?.measure8, cocktail?.measure9, cocktail?.measure10, cocktail?.measure11, cocktail?.measure12, cocktail?.measure13, cocktail?.measure14, cocktail?.measure15]
        
        for i in 0..<ingredients.count {
            if let ingredient = ingredients[i], let measure = measures[i] {
                dictionary[ingredient] = measure
            }
        }
        
        return dictionary
    }
    
    func didSwipeLeft() {
        guard let currentIndex = self.index, let count = cocktails?.count else { return }
        
        let newIndex: Int
        if currentIndex == count - 1 {
            newIndex = 0
        } else {
            newIndex = currentIndex + 1
        }
        
        self.index = newIndex
        cocktail = cocktails?.get(index: newIndex)
    }
    
    func didSwipeRight() {
        guard let currentIndex = self.index, let count = cocktails?.count else { return }
        
        let newIndex: Int
        if currentIndex == 0 {
            newIndex = count - 1
        } else {
            newIndex = currentIndex - 1
        }
        
        self.index = newIndex
        cocktail = cocktails?.get(index: newIndex)
    }
}
