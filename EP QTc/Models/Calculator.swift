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
        return calculateTextAndNumber(qtMeasurement: qtMeasurement, precision: precision).text
    }
    
    func calculateTextAndNumber(qtMeasurement: QtMeasurement, precision: Precision) -> (text: String, number: Double?) {
        do {
            let result = try calculate(qtMeasurement: qtMeasurement)
            return(formattedIntervalMeasurement(measurement: result, units: qtMeasurement.units, precision: precision), result)
        } catch CalculationError.ageRequired {
            return ("must specify age", nil)
        } catch CalculationError.sexRequired {
            return ("must specify sex", nil)
        } catch CalculationError.ageOutOfRange {
            return ("age out of range", nil)
        } catch CalculationError.heartRateOutOfRange {
            return ("heart rate out of range", nil)
        } catch CalculationError.wrongSex {
            return ("wrong sex for formula", nil)
        } catch {
            return ("unexpected error", nil)
        }
    }
    
    private func formattedIntervalMeasurement(measurement: Double?, units: Units, precision: Precision) -> String {
        let formatString = precision.formattedMeasurement(measurement: measurement, units: units, intervalRateType: .interval)
        return String.localizedStringWithFormat("\(formatString) %@", units.unitString)
    }
    
    func resultSeverity(qtMeasurement: QtMeasurement) -> Severity {
        do {
            let result = try calculate(qtMeasurement: qtMeasurement)
            return Calculator.resultSeverity(result: result, qtMeasurement: qtMeasurement, formulaType: formula.formulaType())
        }
        catch {
            return Severity.error
        }
     }
    
    // Tests whether a result is abnormal and returns Severity
    static func resultSeverity(result: Double, qtMeasurement: QtMeasurement, formulaType: FormulaType?) -> Severity {
        if formulaType == .qtp {
            return Severity.normal
        }
        var severityArray: [Int] = []
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
        return Severity(rawValue: severityArray.max() ?? 0)
    }
    
}


