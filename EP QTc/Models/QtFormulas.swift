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
    
    var publicationDate: String {
        guard let date = QTc.qtcCalculator(formula: self).publicationDate else { return "date unspecified" }
        return date
    }
    
}

class QtFormulas {
    public let formulas: [QTcFormula] = [
        .qtcBzt,
        .qtcFrd,
        .qtcHdg,
        .qtcFrm,
        .qtcRtha,
        .qtcMyd,
        .qtcArr,
        .qtcKwt,
        .qtcDmt,
        .qtcYos,
        .qtcAdm,
    ]
    
    func bigFourFormulas() -> [QTcFormula] {
        // These are in ascending date order.
        return [.qtcBzt, .qtcFrd, .qtcHdg, .qtcFrm]
    }
    
    // note sorting functions throw Bool; must be handled by calling function
    func sortedByDate() -> [QTcFormula] {
        return formulas.sorted(by: {$1.publicationDate > $0.publicationDate})
    }
    
    func sortedByName() -> [QTcFormula] {
        return formulas.sorted(by: {$1.calculatorName() > $0.calculatorName()})
    }
    
    private func formulasWithoutBigFour() -> ArraySlice<QTcFormula> {
        let formulasMinusBigFour = formulas[4..<formulas.count]
        return formulasMinusBigFour
    }
    
    func bigFourFirstSortedByDate() -> [QTcFormula] {
        let sortedFormulasMinusBigFour = formulasWithoutBigFour().sorted(by: { $1.publicationDate > $0.publicationDate})
        // bigFourFormulas already sorted by date
        return bigFourFormulas() + sortedFormulasMinusBigFour
    }
    
    func bigFourFirstSortedByName() -> [QTcFormula] {
        let sortedFormulasMinusFour = formulasWithoutBigFour().sorted(by: { $1.calculatorName() > $0.calculatorName()})
        // hand sort big four by name
        let sortedByNameBigFour: [QTcFormula] = [.qtcBzt, .qtcFrm, .qtcFrd, .qtcHdg]
        return sortedByNameBigFour + sortedFormulasMinusFour
    }
    
    
}
