//
//  AgeTextField.swift
//  EP QTc
//
//  Created by David Mann on 12/10/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import UIKit
import Validator

final class AgeTextField: CalculatorTextField {

    override
    func updateValidationState(result: ValidationResult) {
        if text == nil  || text!.isEmpty {
            resetFieldBorder()
        }
        else {
            super.updateValidationState(result: result)
        }
  
    }

}
