//
//  RegisterViewController.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {

    
    // MARK: - OUTLETS
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var confirmPasswordTextField: CustomTextField!
    
    @IBOutlet weak var emailErrorMessageText: UILabel!
    @IBOutlet weak var confirmPasswordErrorMessageText: UILabel!
    @IBOutlet weak var btnSignUpOutlet: UIButton!
    @IBOutlet weak var loginText: UILabel!

    @IBOutlet weak var btnGoogleOutlet: UIButton!
    @IBOutlet weak var btnFaceBookOutlet: UIButton!
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: RegisterViewModelProtocol?
    
    //MARK: - INITIALIZER
    init(viewModel: RegisterViewModelProtocol) {
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
        self.navigationItem.hidesBackButton = true
        initTextFields(textField: emailTextField, leadingImageName: "person", placeholder: "Email", isPassword: false)
        initTextFields(textField: passwordTextField, leadingImageName: "lock", placeholder: "Password", isPassword: true)
        initTextFields(textField: confirmPasswordTextField, leadingImageName: "lock", placeholder: "Confirm Password", isPassword: true)
        initBtns()
    }
    
    private func initTextFields(textField: CustomTextField, leadingImageName: String, placeholder: String, isPassword: Bool){
        textField.setupView(leadingImageName: leadingImageName, placeholder: placeholder, isPassword: isPassword)
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.secondary.cgColor
        textField.layer.borderWidth = 0.3
    }
    
    private func initBtns(){
        btnSignUpOutlet.layer.cornerRadius = 16
        btnGoogleOutlet.layer.cornerRadius = btnGoogleOutlet.frame.width/2
        btnFaceBookOutlet.layer.cornerRadius = btnGoogleOutlet.frame.width/2
    }
    
    
    // MARK: - BUTTONS
    @IBAction func btnSignUp(_ sender: Any) {
        viewModel?.input.registerButtonTriggered.send()
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        viewModel?.input.loginButtonTriggered.send()
    }


}
