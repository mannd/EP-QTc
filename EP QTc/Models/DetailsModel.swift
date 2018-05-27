//
//  DetailsModel.swift
//  EP QTc
//
//  Created by David Mann on 3/1/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import Foundation
import QTc

class DetailsModel {
    var formulaName: String
    var shortFormulaName: String
    var result: String
    var interpretation: String = ""
    var parameters: [Parameter] = []
    var details: [Parameter] = []
    var equation: String
    var reference: String
    var notes: String
    var limits: String
    var limitsReferences: [String] = []
    var limitsDescriptions: [String] = []
    var severity: Severity
    
    
    let results: [Double]
    let calculator: Calculator
    let qtMeasurement: QtMeasurement
    let preferences = Preferences.retrieve()

    init(qtMeasurement: QtMeasurement, calculator: Calculator, results: [Double]) {
        self.results = results
        self.qtMeasurement = qtMeasurement
        self.calculator = calculator
        let units = qtMeasurement.units.string
        let precision: Precision = preferences.precision ?? Preferences.defaultPrecision
        // names
        formulaName = calculator.longName
        shortFormulaName = calculator.shortName
        // parameters
        let qtParameter = Parameter()
        qtParameter.key = "QT (\(units))"
        qtParameter.value = qtMeasurement.qtString(precision: precision)
        parameters.append(qtParameter)
        let rrParameter = Parameter()
        rrParameter.key = "RR (\(units))"
        rrParameter.value = qtMeasurement.rrString(precision: precision)
        parameters.append(rrParameter)
        let hrParameter = Parameter()
        hrParameter.key = "Heart rate (bpm)"
        hrParameter.value = qtMeasurement.heartRateString(precision: precision)
        parameters.append(hrParameter)
        let sexParameter = Parameter()
        sexParameter.key = "Sex"
        sexParameter.value = qtMeasurement.sexString()
        parameters.append(sexParameter)
        let ageParameter = Parameter()
        ageParameter.key = "Age (y)"
        ageParameter.value = qtMeasurement.ageString()
        parameters.append(ageParameter)
        // qtc result
        result = calculator.calculateToString(qtMeasurement: qtMeasurement, precision: precision)
        // formula details
        let nameDetail = Parameter()
        nameDetail.key = "Name"
        nameDetail.value = formulaName
        details.append(nameDetail)
        let shortNameDetail = Parameter()
        shortNameDetail.key = "Short name"
        shortNameDetail.value = shortFormulaName
        details.append(shortNameDetail)
        let dateDetail = Parameter()
        dateDetail.key = "Publication date"
        dateDetail.value = calculator.publicationDate
        details.append(dateDetail)
        let classificationDetail = Parameter()
        classificationDetail.key = "Classification"
        classificationDetail.value = calculator.classification.label
        details.append(classificationDetail)
        let numberOfSubjectsDetail = Parameter()
        numberOfSubjectsDetail.key = "Number of subjects"
        if let totalNumberOfSubjects = calculator.numberOfSubjects {
            numberOfSubjectsDetail.value = String(totalNumberOfSubjects)
        }
        else {
            numberOfSubjectsDetail.value = "not given"
        }
        details.append(numberOfSubjectsDetail)
        equation = calculator.equation
        reference = calculator.reference
        notes = calculator.notes
        // limits
        limits = preferences.qtcLimitsString()
        // QTc limits references
        if let qtcLimits = preferences.qtcLimits {
            for criterion in qtcLimits {
                let qtcTestSuite = AbnormalQTc.qtcTestSuite(criterion: criterion)
                if let reference = qtcTestSuite?.reference {
                    limitsReferences.append(reference)
                }
                if let description = qtcTestSuite?.description {
                    limitsDescriptions.append(description)
                }
            }
        }
        severity = calculator.resultSeverity(qtMeasurement: qtMeasurement, qtcLimits: preferences.qtcLimits)
        // interpretation
        interpretation = interpretResult()

    }
    
    //
    func maxMinResult() -> (max: Double, min: Double) {
        return (results.max() ?? 0, results.min() ?? 0)
    }
    
    func interpretResult() -> String {
        var severity = calculator.resultSeverity(qtMeasurement: qtMeasurement, qtcLimits: preferences.qtcLimits)
        if calculator.formula.formulaType() == .qtp && severity != .error {
            let maxMin = maxMinResult()
            if maxMin == (0,0) {
                severity = .error
            }
            let max = maxMin.max
            let min = maxMin.min
            if let qt = qtMeasurement.qt {
                if qt > max || qt < min {
                    severity = .abnormal
                }
                else {
                    severity = .normal
                }
            }
            else {
                return "Not applicable"
            }
        }
        return severity.interpretation(formulaType: calculator.formula.formulaType())
    }
}

class Parameter {
    var key: String?
    var value: String?
    
    convenience init() {
        self.init(key: nil, value: nil)
    }
    
    init(key: String?, value: String?) {
        self.key = key
        self.value = value
    }
}
