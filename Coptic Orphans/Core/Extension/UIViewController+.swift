//
//  UIViewController+.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 15/03/2025.
//

import UIKit
import Toast

extension UIViewController {
    func showToast(message: String){
        var style = ToastStyle()
        style.backgroundColor = UIColor.gray
        self.view.makeToast(message, duration: 2.0, position: .bottom, style: style)
    }
}
