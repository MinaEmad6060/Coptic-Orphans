//
//  LoginViewController.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//

import UIKit
import Combine

class LoginViewController: UIViewController {

    
    // MARK: - OUTLETS
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var emailErrorMessageText: UILabel!
    @IBOutlet weak var btnSignInOutlet: UIButton!
    
    @IBOutlet weak var btnGoogleOutlet: UIButton!
    @IBOutlet weak var btnFaceBookOutlet: UIButton!

    
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
        setupViews()
    }
    
    // MARK: - FUNCTIONS
    private func setupViews(){
        initTextFields(textField: emailTextField, leadingImageName: "person", placeholder: "Email", isPassword: false)
        initTextFields(textField: passwordTextField, leadingImageName: "lock", placeholder: "Password", isPassword: true)
        initBtns()
    }
    
    private func initTextFields(textField: CustomTextField, leadingImageName: String, placeholder: String, isPassword: Bool){
        textField.setupView(leadingImageName: leadingImageName, placeholder: placeholder, isPassword: isPassword)
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.secondary.cgColor
        textField.layer.borderWidth = 0.3
    }
    
    private func initBtns(){
        btnSignInOutlet.layer.cornerRadius = 16
        btnGoogleOutlet.layer.cornerRadius = btnGoogleOutlet.frame.width/2
        btnFaceBookOutlet.layer.cornerRadius = btnGoogleOutlet.frame.width/2
    }

    
    
    // MARK: - BUTTONS
    @IBAction func btnSignIn(_ sender: Any) {
        viewModel?.input.loginButtonTriggered.send()
    }

    @IBAction func btnRegister(_ sender: Any) {
        viewModel?.input.registerButtonTriggered.send()
    }
}
