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

//    func getUsers()
}

//MARK: - ViewModel-Output
struct LoginViewModelOutput {
    let isLoading: PassthroughSubject<Bool, Never> = .init()
    let reloadView: PassthroughSubject<Void, Never> = .init()
    let showToast: PassthroughSubject<Void, Never> = .init()
}


//MARK: - IMPLEMENTATION
class LoginViewModel: LoginViewModelProtocol {
    
    private let coordinator: Coordinator
    private var useCase: LoginUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    

    var output: LoginViewModelOutput

    init(coordinator: AppCoordinatorProtocol,
         useCase: LoginUseCaseProtocol,
         output: LoginViewModelOutput = LoginViewModelOutput()) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.output = output
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
