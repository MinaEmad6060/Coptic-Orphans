//
//  AppDelegate.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()

        // Initialize Google Sign-In
        if let clientID = FirebaseApp.app()?.options.clientID {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
            print("✅ GIDClientID Loaded: \(clientID)")
        } else {
            print("❌ No GIDClientID found. Check GoogleService-Info.plist")
        }
        
        // Initialize Facebook SDK
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle URL for both Google and Facebook sign-ins
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
        
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Handle discarded scene sessions if needed
    }
}
