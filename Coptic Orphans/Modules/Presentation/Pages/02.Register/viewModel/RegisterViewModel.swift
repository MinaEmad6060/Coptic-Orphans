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
    var output: RegisterViewModelOutput { get }
    var input: RegisterViewModelInput { get }

    func signUpWithEmail(email: String, password: String)
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
    private var cancellables = Set<AnyCancellable>()
    
    var output: RegisterViewModelOutput
    var input: RegisterViewModelInput
    
    init(coordinator: AppCoordinatorProtocol,
         output: RegisterViewModelOutput = RegisterViewModelOutput(),
         input: RegisterViewModelInput = RegisterViewModelInput()) {
        self.coordinator = coordinator
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
                signUpWithEmail(email: email ?? "", password: password ?? "")
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
                signUpWithFacebook()
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
    
    // MARK: - Email & Password Sign-Up
    func signUpWithEmail(email: String, password: String) {
        coordinator.showLoader()
        
        guard !email.isEmpty, !password.isEmpty else {
            output.showToast.send("Please enter both email and password.")
            coordinator.hideLoader()
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.signUpWithEmail(email: email, password: password)
                coordinator.hideLoader()
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
    
    // MARK: - Google Sign-Up
    func signUpWithGoogle() {
           guard let rootViewController = UIApplication.shared.connectedScenes
               .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController }).first else {
               print("Unable to get root view controller")
               return
           }

            Task {
               do {
                   let authResult = try await AuthenticationManager.shared.signUpWithGoogle(from: rootViewController)
                   print("User signed up: \(authResult.user.email ?? "No email")")
                   output.reloadView.send()
               } catch {
                   output.showToast.send("Authentication failed: \(error.localizedDescription)")
               }
           }
       }
    
    // MARK: - Facebook Sign-Up
    func signUpWithFacebook() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = scene.windows.first?.rootViewController else { return }

        Task {
            do {
                let user = try await AuthenticationManager.shared.signUpWithFacebook(rootViewController: rootVC)
                output.showToast.send("Registered as \(user.email ?? "")")
                output.reloadView.send()
            } catch {
                output.showToast.send("Facebook Registration failed: \(error.localizedDescription)")
                print("Facebook Registration failed: \(error.localizedDescription)")
            }
        }
    }


    
}
