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
    
    init(formula: QTcFormula, qtMeasurement: QtMeasurement) {
        self.formula = formula
        self.qtMeasurement = qtMeasurement
    }
    
    func resultLabel() -> String {
        var formatString: String
        var unitsString: String
        if qtMeasurement.units == .msec {
            unitsString = "msec"
            formatString = "%.1f %@ "
        }
        else {
            unitsString = "sec"
            formatString = "%.4f %@ "
        }
        return String.localizedStringWithFormat(formatString, qtMeasurement.calculateQTc(formula: formula) ?? 0, unitsString)
    }
    
    func longCalculatorName() -> String {
        return qtMeasurement.calculatorName(formula: formula)
    }
    
    func shortCalculatorName() -> String {
        return qtMeasurement.calculatorShortName(formula: formula)
    }
        
}
