//
//  QtFormulas.swift
//  EP QTc
//
//  Created by David Mann on 12/12/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import Foundation
import QTc

extension QTcFormula {
    func calculatorName() -> String {
        return QTc.qtcCalculator(formula: self).longName
    }
    
    func calculatorShortName() -> String {
        return QTc.qtcCalculator(formula: self).shortName
    }
    
    func classificationName() -> String {
        return QTc.qtcCalculator(formula: self).classificationName
    }
    
}

class QtFormulas {
    public let formulas: [QTcFormula] = [
        .qtcBzt,
        .qtcFrd,
        .qtcFrm,
        .qtcHdg,
        .qtcRtha,
        .qtcMyd,
        .qtcArr,
        .qtcKwt,
        .qtcDmt,
        .qtcYos,
        .qtcAdm
    ]
    
    
}
