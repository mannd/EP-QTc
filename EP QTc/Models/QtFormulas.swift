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
    
    // This func assumes if numberOfSubjects is missing, they are 0.
    // This shouldn't happen when all the QTc/p formulas are completed
    func numberOfSubjects(formulaType: FormulaType) -> Int {
        return QTc.calculator(formula: self).numberOfSubjects ?? 0
    }
}

extension FormulaClassification {
    var label: String {
        switch self {
        case .linear:
            return "linear"
        case .rational:
            return "rational (hyperbolic)"
        case .power:
            return "power (parabolic)"
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
    case none = "none"  // just used for testing
    case byDate = "byDate"
    case byName = "byName"
    case byNumberOfSubjects = "byNumberOfSubjects"
    // "Big Four" are the most common formulas: QTcBZT, QTcFrd, QTcHdg, & QTcFrm.
    // The sort orders below keep them first in the list, and only apply to QTc formulas.
    case bigFourFirstByDate = "bigFourFirstByDate"
    case bigFourFirstByName = "bigFourFirstByName"
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
            .qtcAdm,
            .qtcGot,
            ],
         .qtp: [
            .qtpBzt,
            .qtpFrd,
            .qtpArr,
            .qtpBdl,
            .qtpAsh,
            .qtpHdg,
            .qtpMyd,
            .qtpKrj,
            .qtpSch,
            .qtpAdm,
            .qtpSmn,
            .qtpKwt,
            .qtpScl,
            .qtpMrr,
            .qtpHgg,
            .qtpGot,
            .qtpKlg,
            .qtpShp,
            .qtpWhl,
            .qtpSrm,
            .qtpLcc,
            ]
    ]

    func bigFourFormulas() -> [Formula] {
        // These are in ascending date order.
        return [.qtcBzt, .qtcFrd, .qtcHdg, .qtcFrm]
    }
    
    // note sorting functions throw; must be handled by calling function
 
    func sortedByDate(formulas: [Formula], formulaType: FormulaType) -> [Formula] {
        return formulas.sorted(by: {$1.publicationDate(formulaType: formulaType) > $0.publicationDate(formulaType: formulaType)})
    }
    
    func sortedByName(formulas: [Formula], formulaType: FormulaType) -> [Formula] {
        return formulas.sorted(by: {$1.longName(formulaType: formulaType) > $0.longName(formulaType: formulaType)})
    }
    
    func sortedByNumberOfSubjects(formulas: [Formula], formulaType: FormulaType) -> [Formula] {
        return formulas.sorted(by: {$1.numberOfSubjects(formulaType: formulaType) > $0.numberOfSubjects(formulaType: formulaType)})
    }
    
    private func formulasWithoutBigFour() -> ArraySlice<Formula> {
        let formulasMinusBigFour = formulas[.qtc]![4..<(formulas[.qtc]!.count)]
        return formulasMinusBigFour
    }
    
    // All the Big Four functions ignore QTp formulas, i.e., only appy to QTc
    func bigFourFirstSortedByDate(formulas: [Formula], formulaType: FormulaType) -> [Formula] {
        if formulaType == .qtp {
            return sortedByDate(formulas: formulas, formulaType: formulaType)
        }
        else {
            var sortedFormulas = sortedByDate(formulas: Array(formulasWithoutBigFour()), formulaType: .qtc)
            sortedFormulas = bigFourFormulas() + sortedFormulas
            return sortedFormulas
        }
    }
    
    func bigFourFirstSortedByName(formulas: [Formula], formulaType: FormulaType) -> [Formula] {
        if formulaType == .qtp {
            return sortedByName(formulas: formulas, formulaType: formulaType)
        }
        else {
            var sortedFormulas = sortedByName(formulas: Array(formulasWithoutBigFour()), formulaType: .qtc)
            sortedFormulas = [.qtcBzt, .qtcFrm, .qtcFrd, .qtcHdg] + sortedFormulas
            return sortedFormulas
        }
    }
    
}
