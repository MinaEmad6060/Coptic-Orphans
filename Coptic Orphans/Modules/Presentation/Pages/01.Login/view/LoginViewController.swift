//
//  LoginViewController.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//

import UIKit
import Combine

class LoginViewController: UIViewController {

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: LoginViewModelProtocol?
    
    //MARK: - INITIALIZER
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle-Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
}
