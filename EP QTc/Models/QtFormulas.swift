//
//  QtFormulas.swift
//  EP QTc
//
//  Created by David Mann on 12/12/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import Foundation
import QTc

extension Formula {
    func longName(formulaType: FormulaType) -> String {
        return QTc.calculator(formula: self).longName
    }
    
    func shortName(formulaType: FormulaType) -> String {
        return QTc.calculator(formula: self).shortName
    }
    
    func classificationName(formulaType: FormulaType) -> String {
        return QTc.calculator(formula: self).classification.label
    }
    
    func publicationDate(formulaType: FormulaType) -> String {
        guard let date = QTc.calculator(formula: self).publicationDate else {
            return "date unspecified"
        }
        return date
    }
}

extension FormulaClassification {
    var label: String {
        switch self {
        case .linear:
            return "linear"
        case .rational:
            return "rational"
        case .power:
            return "power"
        case .logarithmic:
            return "logarithmic"
        case .exponential:
            return "exponential"
        case .other:
            return "other"
        }
    }
}

// Using String raw values here for serialization in UserDefaults
enum SortOrder: String {
    case none = "none"
    case byDate = "byDate"
    case byName = "byName"
    case bigFourFirstByDate = "bigFourFirstByDate"
    case bigFourFirstByName = "bigFourFirstByName"
    // TODO: implement these
    case byNumberOfSubjects = "byNumberOfSubjects"
    case bigFourByNumberOfSubjects = "bigFourByNumberOfSubjects"
    case byFormulaType = "byFormulaType"
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
