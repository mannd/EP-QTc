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
    var results: [Double] = []
    var calculators: [Calculator] = []
    
    init(formulas: [Formula], qtMeasurement: QtMeasurement) {
        for formulas in formulas {
            let calculator = QTc.calculator(formula: formulas)
            calculators.append(calculator)
            if let result = try? calculator.calculate(qtMeasurement: qtMeasurement) {
                results.append(result)
            }
        }
    }
    
    func allResults() -> [Double] {
        return results
    }
    
    func allCalculators() -> [Calculator] {
        return calculators
    }
}
