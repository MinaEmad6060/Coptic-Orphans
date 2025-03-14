//
//  RegisterViewModel.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//

import Foundation
import Combine

//MARK: - PROTOCOL
protocol RegisterViewModelProtocol{
//    var user: UserDomain? { get set }
    
    var output: RegisterViewModelOutput { get }
    var input: RegisterViewModelInput { get }

//    func getUsers()
}

//MARK: - ViewModel-Output
struct RegisterViewModelOutput {
    let isLoading: PassthroughSubject<Bool, Never> = .init()
    let reloadView: PassthroughSubject<Void, Never> = .init()
    let showToast: PassthroughSubject<Void, Never> = .init()
}

//MARK: - ViewModel-Input
struct RegisterViewModelInput {
    let loginButtonTriggered = PassthroughSubject<Void, Never>()
}


//MARK: - IMPLEMENTATION
class RegisterViewModel: RegisterViewModelProtocol {
    
    private let coordinator: AppCoordinatorProtocol
    private var useCase: LoginUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    

    var output: RegisterViewModelOutput
    var input: RegisterViewModelInput
    
    init(coordinator: AppCoordinatorProtocol,
         useCase: LoginUseCaseProtocol,
         output: RegisterViewModelOutput = RegisterViewModelOutput(),
         input: RegisterViewModelInput = RegisterViewModelInput()) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.output = output
        self.input = input
        configureInputObservers()
    }
    
}


//MARK: - Observe-Inputs
private extension RegisterViewModel {
    func configureInputObservers() {
        input.loginButtonTriggered
            .sink { [weak self] in
                guard let self else { return }
                coordinator.router.pop(animated: true)
            }
            .store(in: &cancellables)
    }
}
    
//MARK: - CALLS
extension RegisterViewModel {
    
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
