//
//  Store+Accessors.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 18/08/2023.
//

import Foundation

extension Store {

    public var cocktails: [Cocktail] {
        get {
            return (self[.cocktails] as? [Cocktail]) ?? []
        }
        set {
            self[.cocktails] = newValue
        }
    }
}

