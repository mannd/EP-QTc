//
//  ResultModel.swift
//  EP QTc
//
//  Created by David Mann on 4/26/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import Foundation
import QTc

class ResultModel {
    let calculator: Calculator
    let measurement: QtMeasurement
    let preferences: Preferences
    
    var name: String {
        get {
            return calculator.longName
        }
    }
    
    var shortName: String {
        get {
            return calculator.shortName
        }
    }
    
    init(calculator: Calculator, measurement: QtMeasurement, preferences: Preferences) {
        self.calculator = calculator
        self.measurement = measurement
        self.preferences = preferences
    }
    
//    func result() -> (text: String, number: Double?) {
//        let precision = preferences.precision ?? Preferences.defaultPrecision
//        return calculator.calculateTextAndNumber(qtMeasurement: measurement, precision: precision)
//    }
//    
    func resultText() -> String {
        let precision = preferences.precision ?? Preferences.defaultPrecision
        return calculator.calculateToString(qtMeasurement: measurement, precision: precision)
    }
    
    func resultSeverity() -> Severity {
        return calculator.resultSeverity(qtMeasurement: measurement)
    }
    

    
}
