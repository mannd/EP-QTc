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
    var formulaName: String?
    var shortFormulaName: String?
    var result: String?
    var parameters = [Parameter]()
    var details = [Detail]()

    init(qtMeasurement: QtMeasurement, formula: QTcFormula) {
        let calculator = QTc.qtcCalculator(formula: formula)
        formulaName = calculator.longName
        shortFormulaName = calculator.shortName
        let formatString: String
        switch qtMeasurement.units {
        case .msec:
            formatString = "%.1f %@ "
        case .sec:
            formatString = "%.4f %@ "
        }
        result = String.localizedStringWithFormat(formatString, qtMeasurement.calculateQTc(formula: formula) ?? 0, qtMeasurement.intervalUnits())
        //TODO: add parameters and details
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
