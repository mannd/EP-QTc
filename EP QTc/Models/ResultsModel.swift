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
    // Only calculation results that are not errors
    var results: [Double]  = []
    // Formulas that correspond to above results
    var resultFormulas: [Formula] = []
    // All calculators (including those giving errors)
    var calculators: [Calculator] = []
    
    init(formulas: [Formula], qtMeasurement: QtMeasurement) {
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
}
