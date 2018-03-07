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
        let formatString: String
        switch qtMeasurement.units {
        case .msec:
            formatString = "%.1f %@ "
        case .sec:
            formatString = "%.4f %@ "
        }
        return String.localizedStringWithFormat(formatString, qtMeasurement.calculateQTc(formula: formula) ?? 0, qtMeasurement.intervalUnits())
    }
    
    func longCalculatorName() -> String {
        return qtMeasurement.calculatorName(formula: formula)
    }
    
    func shortCalculatorName() -> String {
        return qtMeasurement.calculatorShortName(formula: formula)
    }
        
}
