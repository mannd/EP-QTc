//
//  ResultViewModel.swift
//  EP QTc
//
//  Created by David Mann on 3/1/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import QTc

class ResultViewModel: NSObject {
    let formula: QTcFormula
    let qtMeasurement: QtMeasurement
    
    // parameter to be eventually set in Settings
    let defaultFormatType: FormatType = .roundOnePlace
    
    init(formula: QTcFormula, qtMeasurement: QtMeasurement) {
        self.formula = formula
        self.qtMeasurement = qtMeasurement
    }
    
    func resultLabel() -> String {
        let formatType: FormatType = defaultFormatType
        return qtMeasurement.calculateQTcToString(formula: formula, formatType: formatType)
    }
    
    func longCalculatorName() -> String {
        return formula.calculatorName()
    }
    
    func shortCalculatorName() -> String {
        return formula.calculatorShortName()
    }
        
}
