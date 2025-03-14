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
//    var user: UserDomain? { get set }
    
    var output: HomeViewModelOutput { get }
    var input: HomeViewModelInput { get }

//    func getUsers()
}

//MARK: - ViewModel-Output
struct HomeViewModelOutput {
    let isLoading: PassthroughSubject<Bool, Never> = .init()
    let reloadView: PassthroughSubject<Void, Never> = .init()
    let showToast: PassthroughSubject<Void, Never> = .init()
}

//MARK: - ViewModel-Input
struct HomeViewModelInput {
    let registerButtonTriggered = PassthroughSubject<Void, Never>()
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
        input.registerButtonTriggered
            .sink { [weak self] in
                guard let self else { return }
                coordinator.displayRegisterScreen()
            }
            .store(in: &cancellables)
    }
}
    
//MARK: - CALLS
extension HomeViewModel {
    
//    func getUsers() {
//        coordinator.showLoader()
//        useCase.getUsers()
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                guard let self else { return }
//                coordinator.hideLoader()
//                switch completion {
//                    case .finished: print("Completed")
//                    case .failure(let error): print(error.localizedDescription)
//                }
//            } receiveValue: { [weak self] users in
//                if let randomUser = users.randomElement() {
//                    self?.user = randomUser
//                    self?.getAlbums(userId: randomUser.id ?? 0)
//                }
//            }
//            .store(in: &cancellables)
//    }
    
}
