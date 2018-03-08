//
//  QtMeasurement.swift
//  EP QTc
//
//  Created by David Mann on 12/2/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import Foundation
import QTc

extension QTcCalculator {
    func calculate(qt: Double, intervalRate: Double, intervalRateType: IntervalRateType,
                   sex: Sex, age: Int, units: Units) -> Double? {
        var result: Double?
        switch units {
        case .msec:
            if intervalRateType == .interval {
                result = calculate(qtInMsec: qt, rrInMsec: intervalRate, sex: sex, age: age)
            }
            else {
                result = calculate(qtInMsec: qt, rate: intervalRate, sex: sex, age: age)
            }
        case .sec:
            if intervalRateType == .interval {
                result = calculate(qtInSec: qt, rrInSec: intervalRate, sex: sex, age: age)
            }
            else {
                result = calculate(qtInSec: qt, rate: intervalRate, sex: sex, age: age)
            }
        }
        return result
    }
}

public enum Units {
    case msec
    case sec
}

public enum IntervalRateType {
    case interval
    case rate
}

public enum FormatType {
    case rawFormat
    case 
}

public struct QtMeasurement {
    let bpmString = NSLocalizedString("bpm", comment: "abbreviation for beats per minute")
    let msecString = NSLocalizedString("msec", comment: "abbreviation for milliseconds")
    let secString = NSLocalizedString("sec", comment: "abbreviation for seconds")
    let maleString = NSLocalizedString("male", comment: "")
    let femaleString = NSLocalizedString("female", comment: "")
    let unspecifiedString = NSLocalizedString("unspecified", comment: "for example 'unspecified sex'")
    
    var qt: Double
    var intervalRate: Double
    var units: Units
    var intervalRateType: IntervalRateType
    var sex: Sex
    var age: Double?
    
    func calculateQTc(formula: QTcFormula) -> Double? {
        let qtcCalculator = QTc.qtcCalculator(formula: formula)
        var intAge = QTcCalculator.unspecified
        if let age = age {
            intAge = Int(age)
        }
        return qtcCalculator.calculate(qt: qt, intervalRate: intervalRate, intervalRateType: intervalRateType, sex: sex, age: intAge, units: units)
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
            return femaleString
        case .male:
            return maleString
        case .unspecified:
            return unspecifiedString
        }
    }
    
}


