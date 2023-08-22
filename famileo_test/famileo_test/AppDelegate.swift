//
//  AppDelegate.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 16/08/2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var coordinator: CocktailSearchListCoordinator?
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DependencyResolver.register(name: .store, dependency: Store())
        
        let navController = UINavigationController()
        
        coordinator = CocktailSearchListCoordinator(navigationController: navController)
        
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    } 
}

