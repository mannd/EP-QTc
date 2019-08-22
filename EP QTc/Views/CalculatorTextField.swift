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
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1.0
    }
    
    public func showValidFieldBorder() {
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.borderWidth = 0.5
    }
    
    public func resetFieldBorder() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.25
    }
}


// FIXME: Need to understand the logic here.  See below.
class CalculatorTextField: UITextField {

    @IBOutlet private(set) var textField: UITextField!


    var validationRuleSet: ValidationRuleSet<String>? {

        didSet {

            textField.validationRules = validationRuleSet
        }
    }


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
        // TODO: Apparently need to reference the textField variable here (and not self),
        // since we get an error if we leave out textField.  But how to set textField?
        // Need to study the example validator program more.
        textField.validateOnInputChange(enabled: true)
        textField.validationHandler = { [weak self] result in self?.updateValidationState(result: result) }
    }
    
}
