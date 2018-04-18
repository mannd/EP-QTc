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
    let calculator: Calculator
    let precision: Precision
    
    // parameter to be eventually set in Settings
    let defaultFormatType: Precision = .roundOnePlace
    
    init(calculator: Calculator, qtMeasurement: QtMeasurement) {
        self.calculator = calculator
        self.qtMeasurement = qtMeasurement
        let preferences = Preferences()
        preferences.load()
        self.precision = preferences.precision ?? Preferences.defaultPrecision
    }
    
    func resultLabel() -> String {
        return calculator.calculateToString(qtMeasurement: qtMeasurement, precision: precision)
    }
    
    func longCalculatorName() -> String {
        return calculator.longName
    }
    
    func shortCalculatorName() -> String {
        return calculator.shortName
    }
        
}
