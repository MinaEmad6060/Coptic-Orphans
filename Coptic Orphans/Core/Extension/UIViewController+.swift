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
    
    func showAlert(title: String, message: String, action: (() -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add OK action button
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { _ in
            // Handle OK button action
            action?()
        }))
        
        // Add Cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            // Handle Cancel button action
            alert.dismiss(animated: true)
        })
        
        // Set the color of the Cancel button to red
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(cancelAction)
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}
