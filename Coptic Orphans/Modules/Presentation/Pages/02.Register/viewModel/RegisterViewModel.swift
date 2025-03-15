//
//  RegisterViewModel.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//

import Foundation
import Combine
import FirebaseAuth
import UIKit
import GoogleSignIn
import FirebaseAuth
import FBSDKCoreKit
import FacebookLogin
import FBSDKLoginKit

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
    let registerUsingGoogleButtonTriggered = PassthroughSubject<Void, Never>()
    let registerUsingFaceBookButtonTriggered = PassthroughSubject<Void, Never>()
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
        
        input.registerUsingGoogleButtonTriggered
            .sink { [weak self] in
                guard let self else { return }
                signUpWithGoogle()
            }
            .store(in: &cancellables)
        
        input.registerUsingFaceBookButtonTriggered
            .sink { [weak self] in
                guard let self else { return }
                registerWithFacebook()
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
    
    func signUpWithGoogle() {
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
    
    // MARK: - Facebook Sign-In
    func registerWithFacebook() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = scene.windows.first?.rootViewController else { return }

        Task {
            do {
                let user = try await AuthenticationManager.shared.signInWithFacebook(rootViewController: rootVC)
                output.showToast.send("Registered as \(user.email ?? "")")
                output.reloadView.send()
            } catch {
                output.showToast.send("Facebook Registration failed: \(error.localizedDescription)")
                print("Facebook Registration failed: \(error.localizedDescription)")
            }
        }
    }


    
}
