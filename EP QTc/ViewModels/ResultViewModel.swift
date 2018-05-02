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
    
    let errorColor = UIColor.blue
    let normalColor = UIColor.black // green doesn't look good
    let borderlineColor = UIColor.orange
    let mildColor = UIColor.orange
    let moderateColor = UIColor.red
    let severeColor = UIColor.purple
    let abnormalColor = UIColor.red
    let defaultColor = UIColor.black
    let undefinedColor = UIColor.gray
    
    
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
        switch severity {
        case .error:
            return errorColor
        case .normal:
            return normalColor
        case .borderline:
            return borderlineColor
        case .mild:
            return mildColor
        case .moderate:
            return moderateColor
        case .severe:
            return severeColor
        case .abnormal:
            return abnormalColor
        case .undefined:
            return undefinedColor
        default:
            // above should be exhaustive, but compiler can't check this
            assertionFailure("Unknown severity.")
            return defaultColor
        }
    }
    
    func severityFontWeight() -> UIFont.Weight {
        let severity = resultModel.resultSeverity()
        if severity.isAbnormal() {
            return UIFont.Weight.bold
        }
        else {
            return UIFont.Weight.light
        }
    }
        
}
