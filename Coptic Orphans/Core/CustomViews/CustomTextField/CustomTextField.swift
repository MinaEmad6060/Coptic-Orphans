import UIKit
import Combine

class CustomTextField: UIView, UITextFieldDelegate {

    // MARK: - OUTLETS
    @IBOutlet weak var leadingImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var trailingBtn: UIButton!
    
    // MARK: - Properties
    private let defaultBorderColor: UIColor = .secondary
    private let activeBorderColor: UIColor = .main
    private var isPassSecure = false

    // MARK: - INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    // MARK: - FUNCTIONS
    private func commonInit() {
        let bundle = Bundle(for: CustomTextField.self)
        if let viewToAdd = bundle.loadNibNamed("CustomTextField", owner: self, options: nil)?.first as? UIView {
            addSubview(viewToAdd)
            viewToAdd.frame = self.bounds
            viewToAdd.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        textField.isSecureTextEntry = true
        textField.delegate = self
    }

    func setupView(leadingImageName: String, placeholder: String, isPassword: Bool = false) {
        leadingImage.image = UIImage(systemName: leadingImageName)
        trailingBtn.isHidden = !isPassword
        textField.placeholder = placeholder
    }

    // MARK: - UITextFieldDelegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        layer.borderWidth = 1.5
        layer.borderColor = activeBorderColor.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        layer.borderWidth = 0.3
        layer.borderColor = defaultBorderColor.cgColor
    }
    
    // MARK: - Handling-Button
    @IBAction func btnEye(_ sender: Any) {
        textField.isSecureTextEntry.toggle()
        if self.isPassSecure {
            self.isPassSecure = false
            trailingBtn.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }else{
            self.isPassSecure = true
            trailingBtn.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
    }
}
