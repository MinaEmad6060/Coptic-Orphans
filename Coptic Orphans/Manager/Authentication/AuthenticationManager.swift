//
//  AuthenticationManager.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//

import Foundation
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

struct AuthDataResultModel {
    let uid: String
    let email: String?

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
}

// MARK: - Email & Password Auth
extension AuthenticationManager {
    
    func signInWithEmail(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }

    func signUpWithEmail(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
}
   


// MARK: - Google Auth
extension AuthenticationManager{
    
    func signInWithGoogle(rootViewController: UIViewController) async throws -> AuthDataResultModel {
        return try await withCheckedThrowingContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let signInResult = signInResult else {
                    continuation.resume(throwing: NSError(domain: "Google Sign-In", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sign-in result is nil"]))
                    return
                }
                
                guard let idToken = signInResult.user.idToken?.tokenString else {
                    continuation.resume(throwing: NSError(domain: "Google Sign-In", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID token"]))
                    return
                }
                
                let accessToken = signInResult.user.accessToken.tokenString
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                
                Task {
                    do {
                        let authResult = try await Auth.auth().signIn(with: credential)
                        continuation.resume(returning: AuthDataResultModel(user: authResult.user))
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    func signUpWithGoogle(from viewController: UIViewController) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let result = result, let idToken = result.user.idToken?.tokenString else {
                    let error = NSError(domain: "GoogleAuth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve Google ID token."])
                    continuation.resume(throwing: error)
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
                
                Task {
                    do {
                        let authResult = try await Auth.auth().signIn(with: credential)
                        continuation.resume(returning: authResult)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
}

// MARK: - Facebook Auth
extension AuthenticationManager {
    
    func signUpWithFacebook(rootViewController: UIViewController) async throws -> AuthDataResultModel {
        let loginManager = LoginManager()
        
        loginManager.logOut()
        
        let credential: AuthCredential = try await withCheckedThrowingContinuation { continuation in
            loginManager.logIn(permissions: ["public_profile", "openid"], from: rootViewController) { result, error in
                if let error = error {
                    DispatchQueue.main.async {
                        rootViewController.showToast(message: "Facebook Login Error: \(error.localizedDescription)")
                    }
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let result = result, !result.isCancelled else {
                    DispatchQueue.main.async {
                        rootViewController.showToast(message: "Facebook Login Cancelled")
                    }
                    continuation.resume(throwing: NSError(domain: "Facebook Sign-Up", code: 3, userInfo: [NSLocalizedDescriptionKey: "User cancelled login"]))
                    return
                }
                
                guard let idTokenString = AccessToken.current?.tokenString else {
                    DispatchQueue.main.async {
                        rootViewController.showToast(message: "Facebook ID Token Missing")
                    }
                    continuation.resume(throwing: NSError(domain: "Facebook Sign-Up", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to get Facebook ID Token"]))
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: idTokenString)
                continuation.resume(returning: credential)
            }
        }
        
        do {
            let authResult = try await Auth.auth().signIn(with: credential)
            
            if authResult.additionalUserInfo?.isNewUser == true {
                print("New user signed up with Facebook: \(authResult.user.email ?? "No email")")
            } else {
                print("Existing user logged in: \(authResult.user.email ?? "No email")")
            }
            
            return AuthDataResultModel(user: authResult.user)
        } catch {
            DispatchQueue.main.async {
                rootViewController.showToast(message: "Firebase Authentication Error: \(error.localizedDescription)")
            }
            throw error
        }
    }


     
     func signInWithFacebook(rootViewController: UIViewController) async throws -> User {
         let loginManager = LoginManager()
         
         let credential: AuthCredential = try await withCheckedThrowingContinuation { continuation in
             loginManager.logIn(permissions: ["public_profile", "email"], from: rootViewController) { result, error in
                 if let error = error {
                     continuation.resume(throwing: error)
                     return
                 }

                 guard let result = result, !result.isCancelled, let token = AccessToken.current?.tokenString else {
                     continuation.resume(throwing: NSError(domain: "Facebook Login", code: 3, userInfo: [NSLocalizedDescriptionKey: "Login was cancelled"]))
                     return
                 }

                 let credential = FacebookAuthProvider.credential(withAccessToken: token)
                 continuation.resume(returning: credential)
             }
         }
         
         let authResult = try await Auth.auth().signIn(with: credential)
         return authResult.user
     }

}
