//
//  CocktailSearchListModel.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 16/08/2023.
//

import Foundation


struct CocktailSearchListModel {
    var cocktails: [Cocktail] = []
    
    init() {
    }
    
    var sectionCount: Int {
        return cocktails.count
    }
}
