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
    
    func resultSeverity(qtMeasurement: QtMeasurement) -> Severity {
        do {
            let result = try calculate(qtMeasurement: qtMeasurement)
            // calculated QTp is normal by definition, unless there is an error
            if formula?.formulaType() == .qtp {
                return Severity.normal
            }
            var severityArray: [Int] = []
            if let result = result {
                let qtcMeasurement = QTcMeasurement(qtc: result, units: qtMeasurement.units, sex: qtMeasurement.sex, age: qtMeasurement.age)
                let preferences = Preferences()
                preferences.load()
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


