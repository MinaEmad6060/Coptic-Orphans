//
//  HomeViewModel.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//


import Foundation
import Combine
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

//MARK: - PROTOCOL
protocol HomeViewModelProtocol{
    var output: HomeViewModelOutput { get }
    var input: HomeViewModelInput { get }

    func getAllPublicRepositories(page: Int)
}

//MARK: - ViewModel-Output
struct HomeViewModelOutput {
    let isLoading: PassthroughSubject<Bool, Never> = .init()
    let reloadView: PassthroughSubject<[GitRepositoryDomain], Never> = .init()
    let showToast: PassthroughSubject<Void, Never> = .init()
}

//MARK: - ViewModel-Input
struct HomeViewModelInput {
    let logoutButtonTriggered = PassthroughSubject<Void, Never>()
}


//MARK: - IMPLEMENTATION
class HomeViewModel: HomeViewModelProtocol {
   
    private let coordinator: AppCoordinatorProtocol
    private var useCase: HomeUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    

    var output: HomeViewModelOutput
    var input: HomeViewModelInput

    init(coordinator: AppCoordinatorProtocol,
         useCase: HomeUseCaseProtocol,
         output: HomeViewModelOutput = HomeViewModelOutput(),
         input: HomeViewModelInput = HomeViewModelInput()) {
        self.coordinator = coordinator
        self.useCase = useCase
        self.output = output
        self.input = input
        configureInputObservers()
    }

}

//MARK: - Observe-Inputs
extension HomeViewModel {
    func configureInputObservers() {
        input.logoutButtonTriggered
            .sink { [weak self] in
                guard let self else { return }
                guard let rootViewController = UIApplication.shared.connectedScenes
                    .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController }).first else {
                    print("Unable to get root view controller")
                    return
                }
                rootViewController.showAlert(title: "Logout", message: "Are you sure you want to logout?"){
                    self.logOutUser()
                }
            }
            .store(in: &cancellables)
    }
}
    
//MARK: - CALLS
extension HomeViewModel {
    
    func getAllPublicRepositories(page: Int) {
        coordinator.showLoader()
        useCase.getAllPublicRepositories(page: page)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                coordinator.hideLoader()
                switch completion {
                    case .finished: print("Completed")
                    case .failure(let error): print(error.localizedDescription)
                }
            } receiveValue: { [weak self] repositories in
                guard let self else { return }
                self.output.reloadView.send(repositories)
            }
            .store(in: &cancellables)
    }
    
    func logOutUser() {
        do {
            try Auth.auth().signOut()
            print("✅ Firebase logout successful")
            
            // Google logout
            if let _ = GIDSignIn.sharedInstance.currentUser {
                GIDSignIn.sharedInstance.signOut()
                print("✅ Google logout successful")
            }

            // Facebook logout
            let loginManager = LoginManager()
            loginManager.logOut()
            print("✅ Facebook logout successful")

            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            coordinator.displayLoginScreen()
            
        } catch let error {
            print("❌ Error logging out: \(error.localizedDescription)")
        }
    }
    
}
