//
//  ResultViewModel.swift
//  EP QTc
//
//  Created by David Mann on 3/1/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import QTc

class ResultViewModel: NSObject {
    let resultModel: ResultModel
    
    let errorColor = UIColor.blue
    let normalColor = UIColor.green
    let abnormalColor = UIColor.red
    let defaultColor = UIColor.black
    
    init(calculator: Calculator, qtMeasurement: QtMeasurement) {
        self.resultModel = ResultModel(calculator: calculator, measurement: qtMeasurement)
    }
    
    func resultLabel() -> String {
        return resultModel.result()
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
        case .abnormal:
            return abnormalColor
        default:
            return defaultColor
        }
        
    }
        
}
