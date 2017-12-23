//
//  QtMeasurement.swift
//  EP QTc
//
//  Created by David Mann on 12/2/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import Foundation
import QTc

public enum Units {
    case msec
    case sec
}

public enum IntervalRateType {
    case interval
    case rate
}

//public enum Sex {
//    case male
//    case female
//    case unspecified
//}

public struct QtMeasurement {
    var qt: Double
    var intervalRate: Double
    var units: Units
    var intervalRateType: IntervalRateType
    var sex: Sex
    var age: Double?
    
    func calculatorName(formula: QTcFormula) -> String {
        let qtcCalculator = QTc.qtcCalculator(formula: formula)
        return qtcCalculator.longName
    }
    
    func calculateQTc(formula: QTcFormula) -> Double? {
        var result: Double? = nil
        let qtcCalculator = QTc.qtcCalculator(formula: formula)
        var intAge = QTcCalculator.unspecified
        if let age = age {
            intAge = Int(age)
        }
        switch units {
        case .msec:
            if intervalRateType == .interval {
                result = qtcCalculator.calculate(qtInMsec: qt, rrInMsec: intervalRate, sex: sex, age: intAge)
            }
            else {
                result = qtcCalculator.calculate(qtInMsec: qt, rate: intervalRate, sex: sex, age: intAge)
            }
        case .sec:
            if intervalRateType == .interval {
                result = qtcCalculator.calculate(qtInSec: qt, rrInSec: intervalRate, sex: sex, age: intAge)
            }
            else {
                result = qtcCalculator.calculate(qtInSec: qt, rate: intervalRate, sex: sex, age: intAge)
            }
        }
        return result
    }
}


