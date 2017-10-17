//
//  AddLocationViewController+Delegate.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 16/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

extension AddLocationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateTextFieldArrow(slideIn: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateTextFieldArrow(slideIn: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchForInputAddress()
        return true
    }
}
