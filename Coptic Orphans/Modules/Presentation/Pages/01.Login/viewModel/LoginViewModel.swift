//
//  LoginViewModel.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//


import Foundation
import Combine

//MARK: - PROTOCOL
protocol LoginViewModelProtocol{
//    var user: UserDomain? { get set }
    
    var output: LoginViewModelOutput { get }
    var input: LoginViewModelInput { get }

//    func getUsers()
}

//MARK: - ViewModel-Output
struct LoginViewModelOutput {
    let isLoading: PassthroughSubject<Bool, Never> = .init()
    let reloadView: PassthroughSubject<Void, Never> = .init()
    let showToast: PassthroughSubject<Void, Never> = .init()
}

//MARK: - ViewModel-Input
struct LoginViewModelInput {
    let loginButtonTriggered = PassthroughSubject<Void, Never>()
    let registerButtonTriggered = PassthroughSubject<Void, Never>()
}


//MARK: - IMPLEMENTATION
class LoginViewModel: LoginViewModelProtocol {
    
    private let coordinator: AppCoordinatorProtocol
    private var useCase: LoginUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    

    var output: LoginViewModelOutput
    var input: LoginViewModelInput
    
    init(coordinator: AppCoordinatorProtocol,
         useCase: LoginUseCaseProtocol,
         output: LoginViewModelOutput = LoginViewModelOutput(),
         input: LoginViewModelInput = LoginViewModelInput()) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.output = output
        self.input = input
        configureInputObservers()
    }

    
}


//MARK: - Observe-Inputs
extension LoginViewModel {
    func configureInputObservers() {
        input.loginButtonTriggered
            .sink { [weak self] in
                guard let self else { return }
                coordinator.displayHomeScreen()
            }
            .store(in: &cancellables)
        input.registerButtonTriggered
            .sink { [weak self] in
                guard let self else { return }
                coordinator.displayRegisterScreen()
            }
            .store(in: &cancellables)
    }
}
    
//MARK: - CALLS
extension LoginViewModel {
    
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
