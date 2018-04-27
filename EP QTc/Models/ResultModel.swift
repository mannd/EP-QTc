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
    
    init(calculator: Calculator, measurement: QtMeasurement) {
        self.calculator = calculator
        self.measurement = measurement
        self.preferences = Preferences()
        preferences.load()
    }
    
    func result() -> String {
        let precision = preferences.precision ?? Preferences.defaultPrecision
        return calculator.calculateToString(qtMeasurement: measurement, precision: precision)
    }
    
    func resultSeverity() -> Severity {
        do {
            let result = try calculator.calculate(qtMeasurement: measurement)
            // calculated QTp is normal by definition, unless there is an error
            if calculator.formula?.formulaType() == .qtp {
                return Severity.normal
            }
            var severityArray: [Int] = []
            if let result = result {
                let qtcMeasurement = QTcMeasurement(qtc: result, units: measurement.units, sex: measurement.sex, age: measurement.age)
                if let criteria = preferences.qtcLimits {
                    for criterion in criteria {
                        let testSuite = AbnormalQTc.qtcLimits(criterion: criterion)
                        let severity = testSuite?.severity(measurement: qtcMeasurement)
                        severityArray.append(severity?.rawValue ?? 0)
                    }
                }
            }
            return Severity(rawValue: severityArray.max() ?? 0)
        }
        catch {
            return Severity.error
        }
        
        
    }
    

    
    
}
