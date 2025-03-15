//
//  String+.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 15/03/2025.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
}
