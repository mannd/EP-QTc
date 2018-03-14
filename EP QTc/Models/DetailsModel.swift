//
//  DetailsModel.swift
//  EP QTc
//
//  Created by David Mann on 3/1/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import QTc

class DetailsModel {
    // TODO: change this to a setting
    let defaultFormatType: FormatType = .roundOnePlace
    
    var formulaName: String
    var shortFormulaName: String
    var result: String
    var parameters: [Parameter] = []
    var details: [Detail] = []
    var equation: String
    var reference: String
    var notes: String

    init(qtMeasurement: QtMeasurement, formula: QTcFormula) {
        let calculator = QTc.qtcCalculator(formula: formula)
        let formatType: FormatType = defaultFormatType
        // names
        formulaName = calculator.longName
        shortFormulaName = calculator.shortName
        // parameters
        let qtParameter = Parameter()
        qtParameter.key = "QT"
        qtParameter.value = formatType.formattedMeasurementWithUnits(measurement: qtMeasurement.qt, units: qtMeasurement.units, intervalRateType: .interval)
        parameters.append(qtParameter)
        let rrParameter = Parameter()
        rrParameter.key = "RR interval"
        rrParameter.value = formatType.formattedMeasurementWithUnits(measurement: qtMeasurement.rrInterval(), units: qtMeasurement.units, intervalRateType: .interval)
        parameters.append(rrParameter)
        let hrParameter = Parameter()
        hrParameter.key = "Heart rate"
        hrParameter.value = formatType.formattedMeasurementWithUnits(measurement: qtMeasurement.heartRate(), units: qtMeasurement.units, intervalRateType: .rate)
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
        result = formatType.formattedMeasurementWithUnits(measurement: qtMeasurement.calculateQTc(formula: formula), units: qtMeasurement.units, intervalRateType: .interval)
        // formula details
        let nameDetail = Detail()
        nameDetail.key = "Name"
        nameDetail.value = formulaName
        details.append(nameDetail)
        let shortNameDetail = Detail()
        shortNameDetail.key = "Short name"
        shortNameDetail.value = shortFormulaName
        details.append(shortNameDetail)
        let classificationDetail = Detail()
        classificationDetail.key = "Classification"
        classificationDetail.value = calculator.classificationName
        details.append(classificationDetail)
        // TODO: add further details here
        equation = calculator.equation
        reference = calculator.reference
        notes = calculator.notes
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
