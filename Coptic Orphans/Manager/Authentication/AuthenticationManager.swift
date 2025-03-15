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
    
    // MARK: - Facebook Login
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
