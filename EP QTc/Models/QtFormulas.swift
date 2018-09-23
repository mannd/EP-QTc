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
    func longName() -> String {
        return QTc.calculator(formula: self).longName
    }
    
    func shortName() -> String {
        return QTc.calculator(formula: self).shortName
    }
    
    func classificationName() -> String {
        return QTc.calculator(formula: self).classification.label
    }
    
    func publicationDate() -> String {
        guard let date = QTc.calculator(formula: self).publicationDate else {
            return "date unspecified"
        }
        return date
    }

    // This func assumes if numberOfSubjects is missing, they are 0.
    // This shouldn't happen when all the QTc/p formulas are completed
    func numberOfSubjects() -> Int {
        return QTc.calculator(formula: self).numberOfSubjects ?? 0
    }

    func result(qtMeasurement: QtMeasurement) -> Double {
        let result = (try? QTc.calculator(formula: self).calculate(qtMeasurement: qtMeasurement)) ?? 0
        return result
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
    case none // just used for testing
    case byDate
    case byName
    case byNumberOfSubjects
    // "Big Four" are the most common formulas: QTcBZT, QTcFrd, QTcHdg, & QTcFrm.
    // The sort orders below keep them first in the list, and only apply to QTc formulas.
    case bigFourFirstByDate
    case bigFourFirstByName
    case custom
    case byResultDescending
    case byResultAscending
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
            .qtcRbk,
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
            .qtpRbk,
            ]
    ]

    func bigFourFormulas() -> [Formula] {
        // These are in ascending date order.
        return [.qtcBzt, .qtcFrd, .qtcHdg, .qtcFrm]
    }
    
    // note sorting functions throw; must be handled by calling function
 
    func sortedByDate(formulas: [Formula]) -> [Formula] {
        return formulas.sorted(by: {$1.publicationDate() > $0.publicationDate()})
    }
    
    func sortedByName(formulas: [Formula]) -> [Formula] {
        return formulas.sorted(by: {$1.longName() > $0.longName()})
    }

    // Number of subjects sorted in descending order
    func sortedByNumberOfSubjects(formulas: [Formula]) -> [Formula] {
        return formulas.sorted(by: {$1.numberOfSubjects() < $0.numberOfSubjects()})
    }
    
    private func formulasWithoutBigFour() -> ArraySlice<Formula> {
        let formulasMinusBigFour = formulas[.qtc]![4..<(formulas[.qtc]!.count)]
        return formulasMinusBigFour
    }
    
    // All the Big Four functions ignore QTp formulas, i.e., only apply to QTc
    func bigFourFirstSortedByDate(formulas: [Formula], formulaType: FormulaType) -> [Formula] {
        if formulaType == .qtp {
            return sortedByDate(formulas: formulas)
        }
        else {
            var sortedFormulas = sortedByDate(formulas: Array(formulasWithoutBigFour()))
            sortedFormulas = bigFourFormulas() + sortedFormulas
            return sortedFormulas
        }
    }
    
    func bigFourFirstSortedByName(formulas: [Formula], formulaType: FormulaType) -> [Formula] {
        if formulaType == .qtp {
            return sortedByName(formulas: formulas)
        }
        else {
            var sortedFormulas = sortedByName(formulas: Array(formulasWithoutBigFour()))
            sortedFormulas = [.qtcBzt, .qtcFrm, .qtcFrd, .qtcHdg] + sortedFormulas
            return sortedFormulas
        }
    }

    func sortedByResultsDescending(formulas: [Formula], qtMeasurement: QtMeasurement) -> [Formula] {
        return formulas.sorted(by: {$0.result(qtMeasurement: qtMeasurement) > $1.result(qtMeasurement: qtMeasurement)})
    }

    func sortedByResultsAscending(formulas: [Formula], qtMeasurement: QtMeasurement) -> [Formula] {
        return formulas.sorted(by: {$1.result(qtMeasurement: qtMeasurement) > $0.result(qtMeasurement: qtMeasurement)})
    }

}
