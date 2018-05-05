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
    // TODO: change this to a setting
    let defaultPrecision: Precision = .roundOnePlace
    
    var formulaName: String
    var shortFormulaName: String
    var result: String
    var interpretation: String = ""
    var parameters: [Parameter] = []
    var details: [Detail] = []
    var equation: String
    var reference: String
    var notes: String
    var limits: String
    var limitsReferences: [String] = []
    var limitsDescriptions: [String] = []
    
    
    let results: [Double]
    let calculator: Calculator
    let qtMeasurement: QtMeasurement
    let preferences = Preferences.retrieve()

    init(qtMeasurement: QtMeasurement, calculator: Calculator, results: [Double]) {
        self.results = results
        self.qtMeasurement = qtMeasurement
        self.calculator = calculator
        let precision: Precision = preferences.precision ?? Preferences.defaultPrecision
        // names
        formulaName = calculator.longName
        shortFormulaName = calculator.shortName
        // parameters
        let qtParameter = Parameter()
        qtParameter.key = "QT"
        qtParameter.value = precision.formattedMeasurementWithUnits(measurement: qtMeasurement.qt, units: qtMeasurement.units, intervalRateType: .interval)
        parameters.append(qtParameter)
        let rrParameter = Parameter()
        rrParameter.key = "RR interval"
        rrParameter.value = precision.formattedMeasurementWithUnits(measurement: qtMeasurement.rrInterval(), units: qtMeasurement.units, intervalRateType: .interval)
        parameters.append(rrParameter)
        let hrParameter = Parameter()
        hrParameter.key = "Heart rate"
        hrParameter.value = precision.formattedMeasurementWithUnits(measurement: qtMeasurement.heartRate(), units: qtMeasurement.units, intervalRateType: .rate)
        parameters.append(hrParameter)
        let sexParameter = Parameter()
        sexParameter.key = "Sex"
        sexParameter.value = qtMeasurement.sexString()
        parameters.append(sexParameter)
        let ageParameter = Parameter()
        ageParameter.key = "Age"
        ageParameter.value = qtMeasurement.ageString()
        parameters.append(ageParameter)
        // qtc result
        result = calculator.calculateToString(qtMeasurement: qtMeasurement, precision: precision)
        // formula details
        let nameDetail = Detail()
        nameDetail.key = "Name"
        nameDetail.value = formulaName
        details.append(nameDetail)
        let shortNameDetail = Detail()
        shortNameDetail.key = "Short name"
        shortNameDetail.value = shortFormulaName
        details.append(shortNameDetail)
        let dateDetail = Detail()
        dateDetail.key = "Publication date"
        dateDetail.value = calculator.publicationDate
        details.append(dateDetail)
        let classificationDetail = Detail()
        classificationDetail.key = "Classification"
        classificationDetail.value = calculator.classification.label
        details.append(classificationDetail)
        let numberOfSubjectsDetail = Detail()
        numberOfSubjectsDetail.key = "Total number of subjects"
        if let totalNumberOfSubjects = calculator.numberOfSubjects {
            numberOfSubjectsDetail.value = String(totalNumberOfSubjects)
        }
        else {
            numberOfSubjectsDetail.value = "not given"
        }
        details.append(numberOfSubjectsDetail)
        // TODO: add further details here
        equation = calculator.equation
        reference = calculator.reference
        notes = calculator.notes
        // limits
        limits = preferences.qtcLimitsString()
        // QTc limits references
        if let qtcLimits = preferences.qtcLimits {
            for criterion in qtcLimits {
                let qtcTestSuite = AbnormalQTc.qtcLimits(criterion: criterion)
                if let reference = qtcTestSuite?.reference {
                    limitsReferences.append(reference)
                }
                if let description = qtcTestSuite?.description {
                    limitsDescriptions.append(description)
                }
            }
        }
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
}

class Detail {
    var key: String?
    var value: String?
}
