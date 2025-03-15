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
        bindhomeViewModel()
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
        guard !emailTextField.textField.text!.isEmpty,
              !passwordTextField.textField.text!.isEmpty,
              !confirmPasswordTextField.textField.text!.isEmpty else {
            showToast(message: "Please fill all fields")
            return
        }
        
        guard passwordTextField.textField.text == confirmPasswordTextField.textField.text else {
            confirmPasswordErrorMessageText.isHidden = false
            return
        }
        
        confirmPasswordErrorMessageText.isHidden = true
        
        viewModel?.input.registerButtonTriggered.send((emailTextField.textField.text,passwordTextField.textField.text))
    }
    
    
    @IBAction func btnGoogle(_ sender: Any) {
        viewModel?.input.registerUsingGoogleButtonTriggered.send()
    }
    
    @IBAction func btnFaceBook(_ sender: Any) {
        viewModel?.input.registerUsingFaceBookButtonTriggered.send()
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        viewModel?.input.loginButtonTriggered.send()
    }


}



//MARK: - BINDING-VIEW-MODEL
private extension RegisterViewController {
    func bindhomeViewModel() {
        bindShowToastView()
        bindReloadView()
    }
    
    func bindShowToastView() {
        viewModel?.output.showToast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self else { return }
                self.showToast(message: message)
            }
            .store(in: &cancellables)
    }
     
    func bindReloadView() {
        viewModel?.output.reloadView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self else { return }
                btnSignUpOutlet.isEnabled = false
                btnGoogleOutlet.isEnabled = false
                btnFaceBookOutlet.isEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [weak self] in
                    self?.viewModel?.input.navToHomeButtonTriggered.send()
                }
            }
            .store(in: &cancellables)
    }
    
}
