//
//  CustomTextField.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//


import UIKit


class CustomTextField: UIView{

    // MARK: - OUTLETS
    @IBOutlet weak var leadingImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var trailingImage: UIImageView!
    
    
    //MARK: - INITIALIZER
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
            viewToAdd.frame = self.bounds  // Ensure it takes the full size
            viewToAdd.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }

    
    func setupView(leadingImageName: String, placeholder: String, isPassword: Bool = false) {
        leadingImage.image = UIImage(systemName: leadingImageName)
        trailingImage.isHidden = !isPassword
        textField.placeholder = placeholder
    }
    
}
