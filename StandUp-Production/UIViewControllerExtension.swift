//
//  UIViewControllerExtension.swift
//  StandUp-Production
//
//  Created by Devesh Laungani on 6/22/16.
//  Copyright © 2016 Devesh Laungani. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}