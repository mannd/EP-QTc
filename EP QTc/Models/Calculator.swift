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
            return (precision.formattedMeasurement(measurement: result, units: qtMeasurement.units, intervalRateType: .interval), result)
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
    
    func resultSeverity(qtMeasurement: QtMeasurement, qtcLimits: Set<Criterion>?) -> Severity {
        do {
            let result = try calculate(qtMeasurement: qtMeasurement)
            return Calculator.resultSeverity(result: result, qtMeasurement: qtMeasurement, formulaType: formula.formulaType(), qtcLimits: qtcLimits)
        }
        catch {
            return Severity.error
        }
     }
    
    // Tests whether a result is abnormal and returns Severity
    static func resultSeverity(result: Double, qtMeasurement: QtMeasurement, formulaType: FormulaType?,
                               qtcLimits: Set<Criterion>?) -> Severity {
        if formulaType == .qtp {
            return Severity.normal
        }
        var severityArray: [Int] = []
        let qtcMeasurement = QTcMeasurement(qtc: result, qtMeasurement: qtMeasurement)
        let criteria = qtcLimits ?? []
        if criteria.count < 1 {
            return Severity.undefined
        }
        for criterion in criteria {
            let testSuite = AbnormalQTc.qtcTestSuite(criterion: criterion)
            let severity = testSuite?.severity(measurement: qtcMeasurement)
            severityArray.append(severity?.rawValue ?? 0)
        }
        return Severity(rawValue: severityArray.max() ?? Severity.error.rawValue)
    }
    
}


