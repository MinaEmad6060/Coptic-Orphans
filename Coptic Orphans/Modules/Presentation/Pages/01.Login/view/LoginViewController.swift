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
        bindLoginViewModel()
    }
    
    // MARK: - FUNCTIONS
    private func setupViews(){
        emailTextField.textField.isSecureTextEntry = false
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

    private func controlBtns(isEnabled: Bool){
        btnSignInOutlet.isEnabled = isEnabled
        btnGoogleOutlet.isEnabled = isEnabled
        btnFaceBookOutlet.isEnabled = isEnabled
    }
    
   
    // MARK: - BUTTONS
    @IBAction func btnSignIn(_ sender: Any) {
        guard !emailTextField.textField.text!.isEmpty, !passwordTextField.textField.text!.isEmpty else {
            showToast(message: "Please fill all fields")
            return
        }
        
        guard emailTextField.textField.text?.isValidEmail() ?? false else {
            emailErrorMessageText.isHidden = false
            return
        }
        
        emailErrorMessageText.isHidden = true
        controlBtns(isEnabled: false)
        
        viewModel?.input.loginButtonTriggered.send((emailTextField.textField.text, passwordTextField.textField.text))
    }
    
    @IBAction func btnGoogle(_ sender: Any) {
        controlBtns(isEnabled: false)
        viewModel?.input.loginUsingGoogleButtonTriggered.send()
    }
    
    @IBAction func btnFaceBook(_ sender: Any) {
        controlBtns(isEnabled: false)
        viewModel?.input.loginUsingFaceBookButtonTriggered.send()
    }

    @IBAction func btnRegister(_ sender: Any) {
        viewModel?.input.registerButtonTriggered.send()
    }
}


//MARK: - BINDING-VIEW-MODEL
private extension LoginViewController {
    func bindLoginViewModel() {
        bindShowToastView()
        bindReloadView()
    }
    
    func bindShowToastView() {
        viewModel?.output.showToast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self else { return }
                controlBtns(isEnabled: true)
                self.showToast(message: message)
            }
            .store(in: &cancellables)
    }
     
    func bindReloadView() {
        viewModel?.output.reloadView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self else { return }
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                controlBtns(isEnabled: true)
                viewModel?.input.navToHomeButtonTriggered.send()
            }
            .store(in: &cancellables)
    }
    
}
