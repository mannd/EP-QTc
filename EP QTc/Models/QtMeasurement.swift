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
                   sex: Sex, age: Age, units: Units) throws -> Double? {
        var result: Double?
        switch units {
        case .msec:
            if intervalRateType == .interval {
                result = try calculate(qtInMsec: qt, rrInMsec: intervalRate, sex: sex, age: age)
            }
            else {
                result = try calculate(qtInMsec: qt, rate: intervalRate, sex: sex, age: age)
            }
        case .sec:
            if intervalRateType == .interval {
                result = try calculate(qtInSec: qt, rrInSec: intervalRate, sex: sex, age: age)
            }
            else {
                result = try calculate(qtInSec: qt, rate: intervalRate, sex: sex, age: age)
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
    case raw
    case roundOnePlace
    case roundFourPlaces
    case roundToInteger
    case roundFourFigures
    
    static let rawFormatString = "%.8f"
    static let onePlaceFormatString = "%.1f"
    static let fourPlacesFormatString = "%.4f"
    static let roundToIntegerFormatString = "%.f"
    static let fourFiguresFormatString = "%.4g"
    static let errorMessage = "ERROR"
    
    func formattedDouble(_ double: Double) -> String {
        var formatString: String
        switch self {
        case .raw:
            formatString = FormatType.rawFormatString
        case .roundOnePlace:
            formatString = FormatType.onePlaceFormatString
        case .roundFourPlaces:
            formatString = FormatType.fourPlacesFormatString
        case .roundToInteger:
            formatString = FormatType.roundToIntegerFormatString
        case .roundFourFigures:
            formatString = FormatType.fourFiguresFormatString
        }
        return String.localizedStringWithFormat(formatString, double)
    }
    
    // Precision depends on FormatType, EXCEPT intervals in secs always using 4 decimal places unless using raw which
    // gives 8 places.
    // Otherwise too much precision is lost.  Otherwise intervals and rates respect the FormatType.
    func formattedMeasurement(measurement: Double?, units: Units, intervalRateType: IntervalRateType) -> String {
        guard let measurement = measurement else {
            return FormatType.errorMessage
        }
        if self == .roundFourFigures {
           return formattedDouble(measurement)
        }
        if units == .sec && intervalRateType != .rate && self != .raw {
            // ignore the actual FormatType
            let formatString = FormatType.fourPlacesFormatString
            return String.localizedStringWithFormat(formatString, measurement)
        }
        else {
            return formattedDouble(measurement)
        }
    }
    
    func formattedMeasurementWithUnits(measurement: Double?, units: Units, intervalRateType: IntervalRateType) -> String {
        guard let measurement = measurement else {
            return FormatType.errorMessage
        }
        let result = formattedMeasurement(measurement: measurement, units: units, intervalRateType: intervalRateType)
        var unitString: String
        if intervalRateType == .rate {
            unitString = "bpm"
        }
        else {
            if units == .msec {
                unitString = "msec"
            }
            else {
                unitString = "sec"
            }
            
        }
        return String.localizedStringWithFormat("%@ %@", result, unitString)
    }
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
    
    func calculateQTc(formula: QTcFormula) throws -> Double? {
        let qtcCalculator = QTc.qtcCalculator(formula: formula)
        // age is sliced to Int?
        var intAge: Age = nil
        if let age = age {
            intAge = Int(age)
        }
        return try qtcCalculator.calculate(qt: qt, intervalRate: intervalRate, intervalRateType: intervalRateType, sex: sex, age: intAge, units: units)
    }
    
    func calculateQTcToString(formula: QTcFormula, formatType: FormatType) -> String {
        do {
            let qtc = try calculateQTc(formula: formula) ?? 0
            let formatString = formatType.formattedMeasurement(measurement: qtc, units: units, intervalRateType: .interval)
            let resultString = String.localizedStringWithFormat("\(formatString) %@", intervalUnits())
            return resultString
        } catch CalculationError.ageRequired {
            return "must specify age"
        } catch CalculationError.sexRequired {
            return "must specify sex"
        } catch CalculationError.ageOutOfRange {
            return "age out of range"
        } catch CalculationError.heartRateOutOfRange {
            return "heart rate out of range"
        } catch CalculationError.wrongSex {
            return "wrong sex for formula"
        } catch {
            return "unexpected error"
        }
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
    
    func ageString() -> String {
        guard let age = age else {
            return unspecifiedString
        }
        return String(Int(age))
    }
    
}


