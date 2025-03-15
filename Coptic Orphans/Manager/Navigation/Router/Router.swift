//
//  Router.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//

import UIKit

//MARK: - ROUTER-PROTOCL
protocol Router {
    var navigationController: UINavigationController { get }
    
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func setRootViewController(_ viewController: UIViewController, animated: Bool)

}


//MARK: - APP-ROUTER
final class AppRouter {
    let navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension AppRouter: Router {
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }
   
    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    func setRootViewController(_ viewController: UIViewController, animated: Bool) {
            navigationController.setViewControllers([viewController], animated: animated)
        }
 
}
