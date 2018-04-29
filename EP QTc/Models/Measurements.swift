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

// Using String raw values here for serialization in UserDefaults
public enum Precision: String {
    case raw = "raw"
    case roundOnePlace = "one"
    case roundTwoPlaces = "two"
    case roundFourPlaces = "four"
    case roundToInteger = "integer"
    case roundFourFigures = "fourFigures"
    
    static let rawFormatString = "%.8f"
    static let onePlaceFormatString = "%.1f"
    static let twoPlaceFormatString = "%.2f"
    static let fourPlacesFormatString = "%.4f"
    static let roundToIntegerFormatString = "%.f"
    static let fourFiguresFormatString = "%.4g"
    static let errorMessage = "ERROR"
    
    func formattedDouble(_ double: Double) -> String {
        var formatString: String
        switch self {
        case .raw:
            formatString = Precision.rawFormatString
        case .roundOnePlace:
            formatString = Precision.onePlaceFormatString
        case .roundTwoPlaces:
            formatString = Precision.twoPlaceFormatString
        case .roundFourPlaces:
            formatString = Precision.fourPlacesFormatString
        case .roundToInteger:
            formatString = Precision.roundToIntegerFormatString
        case .roundFourFigures:
            formatString = Precision.fourFiguresFormatString
        }
        return String.localizedStringWithFormat(formatString, double)
    }
    
    // Precision depends on FormatType, EXCEPT intervals in secs always using 4 decimal places unless using raw which
    // gives 8 places.
    // Otherwise too much precision is lost.  Otherwise intervals and rates respect the FormatType.
    func formattedMeasurement(measurement: Double?, units: Units, intervalRateType: IntervalRateType) -> String {
        guard let measurement = measurement else {
            return Precision.errorMessage
        }
        if self == .roundFourFigures {
            return formattedDouble(measurement)
        }
        if units == .sec && intervalRateType != .rate && self != .raw {
            // ignore the actual FormatType
            let formatString = Precision.fourPlacesFormatString
            return String.localizedStringWithFormat(formatString, measurement)
        }
        else {
            return formattedDouble(measurement)
        }
    }
    
    func formattedMeasurementWithUnits(measurement: Double?, units: Units, intervalRateType: IntervalRateType) -> String {
        guard let measurement = measurement else {
            return Precision.errorMessage
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
    
    // Generally returns one step higher precision, used for statistics.  For example,
    // if precision is set at integer, stats on groups of integers can be precise to one decimal place.
    func morePrecise() -> Precision {
        switch self {
        case .raw:
            fallthrough
        case .roundFourPlaces:
            fallthrough
        case .roundFourFigures:
            return self
        case .roundToInteger:
            return .roundOnePlace
        case .roundOnePlace:
            return .roundTwoPlaces
        case .roundTwoPlaces:
            return .roundFourPlaces
        }
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

