//
//  HomeViewModel.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//


import Foundation
import Combine

//MARK: - PROTOCOL
protocol HomeViewModelProtocol{
    var output: HomeViewModelOutput { get }
    var input: HomeViewModelInput { get }

    func getAllPublicRepositories(page: Int)
}

//MARK: - ViewModel-Output
struct HomeViewModelOutput {
    let isLoading: PassthroughSubject<Bool, Never> = .init()
    let reloadView: PassthroughSubject<[GitRepositoryDomain], Never> = .init()
    let showToast: PassthroughSubject<Void, Never> = .init()
}

//MARK: - ViewModel-Input
struct HomeViewModelInput {
    let logoutButtonTriggered = PassthroughSubject<Void, Never>()
}


//MARK: - IMPLEMENTATION
class HomeViewModel: HomeViewModelProtocol {
   
    private let coordinator: AppCoordinatorProtocol
    private var useCase: HomeUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    

    var output: HomeViewModelOutput
    var input: HomeViewModelInput

    init(coordinator: AppCoordinatorProtocol,
         useCase: HomeUseCaseProtocol,
         output: HomeViewModelOutput = HomeViewModelOutput(),
         input: HomeViewModelInput = HomeViewModelInput()) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.output = output
        self.input = input
        configureInputObservers()
    }

}

//MARK: - Observe-Inputs
extension HomeViewModel {
    func configureInputObservers() {
        input.logoutButtonTriggered
            .sink { [weak self] in
                guard let self else { return }
                coordinator.router.pop(animated: true)
            }
            .store(in: &cancellables)
    }
}
    
//MARK: - CALLS
extension HomeViewModel {
    
    func getAllPublicRepositories(page: Int) {
        coordinator.showLoader()
        useCase.getAllPublicRepositories(page: page)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                coordinator.hideLoader()
                switch completion {
                    case .finished: print("Completed")
                    case .failure(let error): print(error.localizedDescription)
                }
            } receiveValue: { [weak self] repositories in
                guard let self else { return }
                self.output.reloadView.send(repositories)
            }
            .store(in: &cancellables)
    }
    
}
