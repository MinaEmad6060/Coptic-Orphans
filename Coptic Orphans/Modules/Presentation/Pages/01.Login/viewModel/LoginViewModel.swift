//
//  LoginViewModel.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//


import Foundation
import Combine
import FirebaseAuth
import UIKit
import GoogleSignIn

//MARK: - PROTOCOL
protocol LoginViewModelProtocol{
 
    var output: LoginViewModelOutput { get }
    var input: LoginViewModelInput { get }

    func signIn(email: String, password: String)
}

//MARK: - ViewModel-Output
struct LoginViewModelOutput {
    let isLoading: PassthroughSubject<Bool, Never> = .init()
    let reloadView: PassthroughSubject<Void, Never> = .init()
    let showToast: PassthroughSubject<String, Never> = .init()
}

//MARK: - ViewModel-Input
struct LoginViewModelInput {
    let loginButtonTriggered = PassthroughSubject<(String?, String?), Never>()
    let loginUsingGoogleButtonTriggered = PassthroughSubject<Void, Never>()
    let loginUsingFaceBookButtonTriggered = PassthroughSubject<Void, Never>()
    let navToHomeButtonTriggered = PassthroughSubject<Void, Never>()
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
            .sink { [weak self] (email, password) in
                guard let self else { return }
                signIn(email: email ?? "", password: password ?? "")
            }
            .store(in: &cancellables)
        
        input.loginUsingGoogleButtonTriggered
            .sink { [weak self]in
                guard let self else { return }
                signInWithGoogle()
            }
            .store(in: &cancellables)
        
        input.loginUsingFaceBookButtonTriggered
            .sink { [weak self]in
                guard let self else { return }

            }
            .store(in: &cancellables)
        
        input.navToHomeButtonTriggered
            .sink { [weak self]in
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
    
    func signIn(email: String, password: String) {
        coordinator.showLoader()
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            coordinator.hideLoader()
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.signIn(email: email, password: password)
                coordinator.hideLoader()
                output.showToast.send("Sign-in successful")
                output.reloadView.send()
                print(returnedUserData)
            } catch let error as NSError {
                coordinator.hideLoader()
                if error.code == AuthErrorCode.wrongPassword.rawValue {
                    output.showToast.send("Incorrect password. Please try again.")
                } else if error.code == AuthErrorCode.userNotFound.rawValue {
                    output.showToast.send("No account found for this email.")
                } else {
                    output.showToast.send("\(error.localizedDescription)")
                }
            }
        }
    }

    func signInWithGoogle() {
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController }).first else {
            print("Unable to get root view controller")
            return
        }

        coordinator.showLoader()

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            guard let result = signInResult, error == nil else {
                self.coordinator.hideLoader()
                self.output.showToast.send("Google Sign-In failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            guard let idToken = result.user.idToken?.tokenString else {
                self.coordinator.hideLoader()
                self.output.showToast.send("Failed to retrieve Google ID token.")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)

            Task {
                do {
                    let authResult = try await Auth.auth().signIn(with: credential)
                    self.coordinator.hideLoader()
                    self.output.showToast.send("Google Sign-In successful!")
                    self.output.reloadView.send()
                    print("User signed in: \(authResult.user.email ?? "No email")")
                } catch {
                    self.coordinator.hideLoader()
                    self.output.showToast.send("Authentication failed: \(error.localizedDescription)")
                }
            }
        }
    }

    
}
