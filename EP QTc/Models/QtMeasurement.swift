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

public struct QtMeasurement {
    let bpmString = NSLocalizedString("bpm", comment: "abbreviation for beats per minute")
    let msecString = NSLocalizedString("msec", comment: "abbreviation for milliseconds")
    let secString = NSLocalizedString("sec", comment: "abbreviation for seconds")
    
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
    
    func calculatorShortName(formula: QTcFormula) -> String {
        let qtcCalculator = QTc.qtcCalculator(formula: formula)
        return qtcCalculator.shortName
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
    
    func intervalUnits() -> String {
        switch units {
        case .msec:
            return msecString
        case .sec:
            return secString
        }
    }
    
    func intervalRateUnits() -> String {
        switch intervalRateType {
        case .interval:
            return intervalUnits()
        case .rate:
            return bpmString
        }
    }
    
    func heartRateUnits() -> String {
        return bpmString
    }
    
    func rrInterval() -> Double {
        switch intervalRateType {
        case .interval:
            return intervalRate
        case .rate:
            switch units {
            case .msec:
                return QTc.bpmToMsec(intervalRate)
            case .sec:
                return QTc.bpmToSec(intervalRate)
            }
        }
    }
    
    func heartRate() -> Double {
        switch intervalRateType {
        case .rate:
            return intervalRate
        case .interval:
            switch units {
            case .msec:
                return QTc.msecToBpm(intervalRate)
            case .sec:
                return QTc.secToBpm(intervalRate)
            }
        }
    }
    
    func sexString() -> String {
        switch sex {
        case .female:
            return "female"
        case .male:
            return "male"
        case .unspecified:
            return "unspecified"
        }
    }
    
}


