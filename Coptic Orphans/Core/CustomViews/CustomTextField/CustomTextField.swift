//
//  CustomTextField.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//


import UIKit


class CustomTextField: UIView{

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        let bundle = Bundle.init(for: CustomTextField.self)
        if let viewToAdd = bundle.loadNibNamed("CustomTextField", owner: self, options: nil)?.first as? UIView {
            addSubview(viewToAdd)
//            viewToAdd.frame = self.bounds
//            viewToAdd.layer.cornerRadius = 16
//            
            viewToAdd.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
}
