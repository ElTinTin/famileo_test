//
//  CocktailCoordinator.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 16/08/2023.
//

import Foundation
import UIKit

final class CocktailSearchListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    func start() {
        let ctrl = CocktailSearchListViewController.instantiate
    }
    
    
}
