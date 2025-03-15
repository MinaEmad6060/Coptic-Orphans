//
//  AppCoordinator.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//



protocol AppCoordinatorProtocol: Coordinator {
    func displayLoginScreen()
    func displayRegisterScreen()
    func displayHomeScreen()
}


//MARK: - APP-COORDINATOR
final class AppCoordinator: AppCoordinatorProtocol {
 
    var router: any Router
    
    init(router: Router) {
        self.router = router
    }
    
    func displayLoginScreen() {
        let viewModel = LoginViewModel(coordinator: self)
        let viewController = LoginViewController(viewModel: viewModel)
        self.router.setRootViewController(viewController, animated: true)
    }
    
    func displayRegisterScreen() {
        let viewModel = RegisterViewModel(coordinator: self)
        let viewController = RegisterViewController(viewModel: viewModel)
        self.router.push(viewController, animated: true)
    }
    
    func displayHomeScreen() {
        let viewModel = HomeViewModel(coordinator: self, useCase: homeUseCase())
        let viewController = HomeViewController(viewModel: viewModel)
        self.router.push(viewController, animated: true)
    }
   
}


//MARK: - Init-UseCase
extension AppCoordinator {
    
    private func homeUseCase() -> HomeUseCaseProtocol {
        let repository = AppRepository(dependencies: AppRepositoryDependencies(dataSource: AppRemoteDataSource()))
        let useCase = HomeUseCase(dependencies: HomeUseCaseDependencies(repository: repository))
        return useCase
    }
    
}
