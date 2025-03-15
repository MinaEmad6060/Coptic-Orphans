//
//  AuthenticationManager.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//

import Foundation
import FirebaseAuth
import FBSDKLoginKit

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
    
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }

    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // MARK: - Facebook Sign-Up
    func signUpWithFacebook(rootViewController: UIViewController) async throws -> AuthDataResultModel {
        let loginManager = LoginManager()

        // Logout first to clear any previous session
        loginManager.logOut()

        // Perform Facebook login with classic permissions
        let credential: AuthCredential = try await withCheckedThrowingContinuation { continuation in
            loginManager.logIn(permissions: ["public_profile", "email"], from: rootViewController) { result, error in
                if let error = error {
                    print("❌ Facebook Login Error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    return
                }

                guard let result = result, !result.isCancelled else {
                    print("⚠️ Facebook Login Cancelled")
                    continuation.resume(throwing: NSError(domain: "Facebook Sign-Up", code: 3, userInfo: [NSLocalizedDescriptionKey: "User cancelled login"]))
                    return
                }

                guard let token = AccessToken.current?.tokenString else {
                    print("⚠️ Facebook Access Token Missing")
                    continuation.resume(throwing: NSError(domain: "Facebook Sign-Up", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to get Facebook access token"]))
                    return
                }

                let credential = FacebookAuthProvider.credential(withAccessToken: token)
                continuation.resume(returning: credential)
            }
        }
        
        do {
            let authResult = try await Auth.auth().signIn(with: credential)
            
            if authResult.additionalUserInfo?.isNewUser == true {
                print("🎉 New user signed up with Facebook: \(authResult.user.email ?? "No email")")
            } else {
                print("✅ Existing user logged in: \(authResult.user.email ?? "No email")")
            }
            
            return AuthDataResultModel(user: authResult.user)
        } catch {
            print("❌ Firebase Authentication Error: \(error.localizedDescription)")
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
