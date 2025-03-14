//
//  AppCoordinator.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//



protocol AppCoordinatorProtocol: Coordinator {
    func displayLoginScreen()
}


//MARK: - APP-COORDINATOR
final class AppCoordinator: AppCoordinatorProtocol {
 
    var router: any Router
    
    init(router: Router) {
        self.router = router
    }
    
    func displayLoginScreen() {
        let viewModel = LoginViewModel(coordinator: self, useCase: loginUseCase())
        let viewController = LoginViewController(viewModel: viewModel)
        self.router.push(viewController, animated: true)
    }
   
}


//MARK: - Init-UseCase
extension AppCoordinator {
    
    private func loginUseCase() -> LoginUseCaseProtocol {
        let repository = AppRepository(dependencies: AppRepositoryDependencies(dataSource: AppRemoteDataSource()))
        let useCase = LoginUseCase(dependencies: LoginUseCaseDependencies(repository: repository))
        return useCase
    }
    
}
