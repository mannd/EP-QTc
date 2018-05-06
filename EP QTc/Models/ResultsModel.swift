//
//  ResultsModel.swift
//  EP QTc
//
//  Created by David Mann on 4/28/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import Foundation
import QTc

class ResultsModel {
    let qtMeasurement: QtMeasurement
    // Only calculation results that are not errors
    var results: [Double]  = []
    // Formulas that correspond to above results
    var resultFormulas: [Formula] = []
    // All calculators (including those giving errors)
    var calculators: [Calculator] = []
    
    init(formulas: [Formula], qtMeasurement: QtMeasurement) {
        self.qtMeasurement = qtMeasurement
        for formulas in formulas {
            let calculator = QTc.calculator(formula: formulas)
            calculators.append(calculator)
            if let result = try? calculator.calculate(qtMeasurement: qtMeasurement) {
                results.append(result)
                resultFormulas.append(calculator.formula)
            }
        }
    }
    
    func allResults() -> [Double] {
        return results
    }
    
    func allCalculators() -> [Calculator] {
        return calculators
    }
    
    func allFormulas() -> [Formula] {
        return resultFormulas
    }
    
    func resultsSummary(preferences: Preferences) -> String {
        let copyToCSV = preferences.copyToCSV ?? Preferences.defaultCopyToCSV
        let delimiter = copyToCSV ? "," : " "
        let quoteString = copyToCSV
        return resultsSummary(preferences: preferences, delimiter: delimiter, quoteStrings: quoteString)
    }
    
    func resultsSummary(preferences: Preferences, delimiter: String = " ", quoteStrings: Bool = false) -> String {
        var text: String = ""
        let calculators = allCalculators()
            let precision = preferences.precision ?? Preferences.defaultPrecision
            text += getSummaryLine(values: ("QT", qtMeasurement.qtString(precision: precision)), quoteString: quoteStrings, delimiter: delimiter)
            text += getSummaryLine(values: ("RR", qtMeasurement.rrString(precision: precision)), quoteString: quoteStrings, delimiter: delimiter)
            text += getSummaryLine(values: ("HR", qtMeasurement.heartRateString(precision: precision)), quoteString: quoteStrings, delimiter: delimiter)
            text += getSummaryLine(values: ("Sex", qtMeasurement.sexString()), quoteString: quoteStrings, delimiter: delimiter)
            text += getSummaryLine(values: ("Age", qtMeasurement.ageString()), quoteString: quoteStrings, delimiter: delimiter)
            for calculator in calculators {
                let resultModel = ResultModel(calculator: calculator, measurement: qtMeasurement, preferences: preferences)
                text += getSummaryLine(values: (resultModel.shortName, resultModel.resultText()), quoteString: quoteStrings, delimiter: delimiter)
        }
        return text
    }

    private func getSummaryLine(values: (v1: String, v2: String), quoteString: Bool, delimiter: String) -> String {
        let LF = "\n"
        return addQuotes(values.v1, quoteString) + delimiter + addQuotes(values.v2, quoteString) + LF
    }
    
    private func addQuotes (_ s: String, _ add: Bool) -> String {
        if add {
            return "\"\(s)\""
        }
        return s
    }
}
