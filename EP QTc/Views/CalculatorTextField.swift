//
//  CalculatorTextField.swift
//  EP QTc
//
//  Created by David Mann on 12/10/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import UIKit
import Validator

extension UITextField {
    public func showErrorFieldBorder() {
        self.layer.borderColor = UIColor.systemRed.cgColor
        self.layer.borderWidth = 1.0
    }
    
    public func showValidFieldBorder() {
        self.layer.borderColor = UIColor.systemGreen.cgColor
        self.layer.borderWidth = 0.5
    }
    
    public func resetFieldBorder() {
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 0.25
    }
}

class CalculatorTextField: UITextField {

    public func updateValidationState(result: ValidationResult) {
        switch result {
        case .valid:
            showValidFieldBorder()
        case .invalid:
            showErrorFieldBorder()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
