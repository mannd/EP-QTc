//
//  ResultViewModel.swift
//  EP QTc
//
//  Created by David Mann on 3/1/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import QTc

class ResultViewModel {
    let resultModel: ResultModel
    
    init(calculator: Calculator, qtMeasurement: QtMeasurement, preferences: Preferences) {
        self.resultModel = ResultModel(calculator: calculator, measurement: qtMeasurement, preferences: preferences)
    }
    
    func resultLabel() -> String {
        return resultModel.resultText()
    }
    
    func longCalculatorName() -> String {
        return resultModel.name
    }
    
    func shortCalculatorName() -> String {
        return resultModel.shortName
    }
    
    func severityColor() -> UIColor {
        let severity = resultModel.resultSeverity()
        return severity.color()
    }
    
    func severityFontWeight() -> UIFont.Weight {
        let severity = resultModel.resultSeverity()
        return severity.fontWeight()
    }
        
}
