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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let ctrl = CocktailSearchListViewController.instantiate(model: CocktailSearchListModel())
        ctrl.coordinator = self
        present(ctrl)
    }
    
    func openDetail(_ model: Cocktail) {
        let ctrl = CocktailDetailViewController.instantiate(model: CocktailDetailModel(model))
        ctrl.coordinator = self
        present(ctrl)
    }
}
