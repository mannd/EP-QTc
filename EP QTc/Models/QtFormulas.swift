//
//  QtFormulas.swift
//  EP QTc
//
//  Created by David Mann on 12/12/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import Foundation
import QTc

//protocol SortableFormula {
//    func publicationDate(formulaType: FormulaType) -> String
//    func calculatorName(formulaType: FormulaType) -> String
//    func calculatorShortName(formulaType: FormulaType) -> String
//    func classificationName(formulaType: FormulaType) -> String
//}

extension Formula {
    func longName(formulaType: FormulaType) -> String {
        return QTc.calculator(formula: self, formulaType: formulaType).longName
    }
    
    func shortName(formulaType: FormulaType) -> String {
        return QTc.calculator(formula: self, formulaType: formulaType).shortName
    }
    
    func classificationName(formulaType: FormulaType) -> String {
        return QTc.calculator(formula: self, formulaType: formulaType).classificationName
    }
    
    func publicationDate(formulaType: FormulaType) -> String {
        guard let date = QTc.calculator(formula: self, formulaType: formulaType).publicationDate else {
            return "date unspecified"
        }
        return date
    }
}

class QtFormulas {
    let formulas: [FormulaType: [Formula]] =
        [.qtc: [
            .qtcBzt,
            .qtcFrd,
            .qtcHdg,
            .qtcFrm,
            .qtcRtha,
            .qtcRthb,
            .qtcMyd,
            .qtcArr,
            .qtcKwt,
            .qtcDmt,
            .qtcYos,
            .qtcAdm,],
         .qtp: [
            .qtpBzt,
            .qtpFrd,
            .qtpArr,
            .qtpBdl,
            .qtpAsh,
            .qtpHdg,]
    ]

    func bigFourFormulas() -> [Formula] {
        // These are in ascending date order.
        return [.qtcBzt, .qtcFrd, .qtcHdg, .qtcFrm]
    }
    
    // note sorting functions throw Bool; must be handled by calling function
 
    func sortedByDate(formulas: [Formula], formulaType: FormulaType) -> [Formula] {
        return formulas.sorted(by: {$1.publicationDate(formulaType: formulaType) > $0.publicationDate(formulaType: formulaType)})
    }
    
    func sortedByName(formulas: [Formula], formulaType: FormulaType) -> [Formula] {
        return formulas.sorted(by: {$1.longName(formulaType: formulaType) > $0.longName(formulaType: formulaType)})
    }
    
    private func formulasWithoutBigFour() -> ArraySlice<Formula> {
        let formulasMinusBigFour = formulas[.qtc]![4..<(formulas[.qtc]!.count)]
        return formulasMinusBigFour
    }
    
}
