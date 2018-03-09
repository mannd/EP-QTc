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
    let defaultFormatType: FormatType = .roundToInteger
    
    init(formula: QTcFormula, qtMeasurement: QtMeasurement) {
        self.formula = formula
        self.qtMeasurement = qtMeasurement
    }
    
    func resultLabel() -> String {
        let formatType: FormatType = defaultFormatType
        // TODO: deal with other rounding options, e.g. msec rounded to integer
        let qtc = qtMeasurement.calculateQTc(formula: formula) ?? 0
        let formatString = formatType.formattedMeasurement(measurement: qtc, units: qtMeasurement.units, intervalRateType: .interval)
        let resultString = String.localizedStringWithFormat("\(formatString) %@", qtMeasurement.intervalUnits())
        return resultString
    }
    
    func longCalculatorName() -> String {
        return formula.calculatorName()
    }
    
    func shortCalculatorName() -> String {
        return formula.calculatorShortName()
    }
        
}
