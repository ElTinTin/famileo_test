//
//  Coordinator.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 16/08/2023.
//

import Foundation
import UIKit

struct CoordinatorPresentationParameters {
    var preferModal: Bool = false
}

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }

    var navigationController: UINavigationController? { get set }

    func start()
}

extension Coordinator {

    func present(_ viewController: UIViewController, parameters: CoordinatorPresentationParameters = .init()) {
        guard let navigationController = self.navigationController else { return }
        
        if !parameters.preferModal {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            navigationController.present(viewController, animated: true)
        }
    }
}
