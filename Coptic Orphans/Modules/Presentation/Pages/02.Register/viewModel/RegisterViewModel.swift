//
//  RegisterViewModel.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//

import Foundation
import Combine
import FirebaseAuth

//MARK: - PROTOCOL
protocol RegisterViewModelProtocol{
//    var user: UserDomain? { get set }
    
    var output: RegisterViewModelOutput { get }
    var input: RegisterViewModelInput { get }

    func signUp(email: String, password: String)

//    func getUsers()
}

//MARK: - ViewModel-Output
struct RegisterViewModelOutput {
    let isLoading: PassthroughSubject<Bool, Never> = .init()
    let reloadView: PassthroughSubject<Void, Never> = .init()
    let showToast: PassthroughSubject<String, Never> = .init()
}

//MARK: - ViewModel-Input
struct RegisterViewModelInput {
    let registerButtonTriggered = PassthroughSubject<(String?, String?), Never>()
    let navToHomeButtonTriggered = PassthroughSubject<Void, Never>()
    let loginButtonTriggered = PassthroughSubject<Void, Never>()
}


//MARK: - IMPLEMENTATION
class RegisterViewModel: RegisterViewModelProtocol {
    
    private let coordinator: AppCoordinatorProtocol
    private var useCase: RegisterUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    

    var output: RegisterViewModelOutput
    var input: RegisterViewModelInput
    
    init(coordinator: AppCoordinatorProtocol,
         useCase: RegisterUseCaseProtocol,
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
        input.registerButtonTriggered
            .sink { [weak self] (email, password) in
                guard let self else { return }
                signUp(email: email ?? "", password: password ?? "")
            }
            .store(in: &cancellables)
        
        input.navToHomeButtonTriggered
            .sink { [weak self]in
                guard let self else { return }
                coordinator.displayHomeScreen()
            }
            .store(in: &cancellables)
        
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
    
    func signUp(email: String, password: String) {
        coordinator.showLoader()
        
        guard !email.isEmpty, !password.isEmpty else {
            output.showToast.send("Please enter both email and password.")
            coordinator.hideLoader()
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                coordinator.hideLoader()
                output.showToast.send("Your account has been created successfully!")
                output.reloadView.send()
                print(returnedUserData)
            } catch let error as NSError {
                coordinator.hideLoader()
                
                var errorMessage = "Something went wrong. Please try again."
                
                if let authError = AuthErrorCode(rawValue: error.code) {
                    switch authError {
                    case .emailAlreadyInUse:
                        errorMessage = "This email is already registered. Try logging in instead."
                    case .invalidEmail:
                        errorMessage = "Please enter a valid email address."
                    case .networkError:
                        errorMessage = "Network issue detected. Please check your internet connection."
                    default:
                        errorMessage = error.localizedDescription
                    }
                }
                
                output.showToast.send(errorMessage)
            }
        }
    }


}
