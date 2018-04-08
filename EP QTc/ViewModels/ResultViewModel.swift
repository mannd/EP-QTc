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
    let qtMeasurement: QtMeasurement
    let calculator: BaseCalculator
    
    // parameter to be eventually set in Settings
    let defaultFormatType: FormatType = .roundOnePlace
    
    init(calculator: BaseCalculator, qtMeasurement: QtMeasurement) {
        self.calculator = calculator
        self.qtMeasurement = qtMeasurement
    }
    
    func resultLabel() -> String {
        let formatType: FormatType = defaultFormatType
        return calculator.calculateToString(qtMeasurement: qtMeasurement, formatType: formatType)
    }
    
    func longCalculatorName() -> String {
        return calculator.longName
    }
    
    func shortCalculatorName() -> String {
        return calculator.shortName
    }
        
}
