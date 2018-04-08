//
//  Measurements.swift
//  EP QTc
//
//  Created by David Mann on 12/2/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import Foundation
import QTc

fileprivate let bpmString = NSLocalizedString("bpm", comment: "abbreviation for beats per minute")
fileprivate let msecString = NSLocalizedString("msec", comment: "abbreviation for milliseconds")
fileprivate let secString = NSLocalizedString("sec", comment: "abbreviation for seconds")
fileprivate let maleString = NSLocalizedString("male", comment: "")
fileprivate let femaleString = NSLocalizedString("female", comment: "")
fileprivate let unspecifiedString = NSLocalizedString("unspecified", comment: "for example 'unspecified sex'")

extension Units {
    var unitString: String { get {
        switch self {
        case .msec:
            return msecString
        case .sec:
            return secString
        }
        }}
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
            unitString = units.unitString
        }
        return String.localizedStringWithFormat("%@ %@", result, unitString)
    }
}


extension QtMeasurement {
    func intervalUnits() -> String {
        return units.unitString
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

