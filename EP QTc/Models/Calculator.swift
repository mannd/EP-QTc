//
//  Calculator.swift
//  EP QTc
//
//  Created by David Mann on 4/11/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import Foundation
import QTc


extension Calculator {
    func calculateToString(qtMeasurement: QtMeasurement, precision: Precision) -> String {
        return tryCalculationCatch(block: { () -> String in
        let result = try calculate(qtMeasurement: qtMeasurement) ?? 0
        return formattedIntervalMeasurement(measurement: result, units: qtMeasurement.units, precision: precision)
        })
    }
    
    private func formattedIntervalMeasurement(measurement: Double?, units: Units, precision: Precision) -> String {
        let formatString = precision.formattedMeasurement(measurement: measurement, units: units, intervalRateType: .interval)
        return String.localizedStringWithFormat("\(formatString) %@", units.unitString)
    }
    
    func tryCalculationCatch(block: () throws -> String) -> String {
        do {
            return try block()
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
}


