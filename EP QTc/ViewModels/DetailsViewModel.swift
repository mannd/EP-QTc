//
//  DetailsViewModel.swift
//  EP QTc
//
//  Created by David Mann on 3/1/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import QTc

enum DetailsViewModelItemType {
    case formulaName
    case parameters
    case result
    case formulaDetails
}

protocol DetailsViewModelItem {
    var type: DetailsViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String { get }
}

extension DetailsViewModelItem {
    var rowCount: Int {
        return 1
    }
}

class DetailsViewModelFormulaNameItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .formulaName
    }
    
    var sectionTitle: String {
        return "Formula"
    }
    
    let name: String
    
    init(name: String) {
        self.name = "\(name) formula"
    }
}

class DetailsViewModelParametersItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .parameters
    }
    
    var sectionTitle: String {
        return "Parameters"
    }
    
    var parameters:[String]
    
    init(qtMeasurement: QtMeasurement) {
        parameters = [String]()
        let qtParameter = "QT interval = \(qtMeasurement.qt) \(qtMeasurement.intervalUnits())"
        parameters.append(qtParameter)
        let rrIntervalParameter = "RR interval = \(qtMeasurement.rrInterval()) \(qtMeasurement.intervalUnits())"
        parameters.append(rrIntervalParameter)
        let heartRateParameter = "Heart rate = \(qtMeasurement.heartRate()) \(qtMeasurement.heartRateUnits())"
        parameters.append(heartRateParameter)
        let ageParameter: String
        if let age = qtMeasurement.age {
            ageParameter = "Age = \(age) years"
        }
        else {
            ageParameter = "Age = unspecified"
        }
        parameters.append(ageParameter)
        let sexParameter = "Sex = \(qtMeasurement.sexString())"
        parameters.append(sexParameter)
    }
    
    var rowCount: Int {
        return parameters.count
    }
}

class DetailsViewModelResultItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .result
    }
    
    var sectionTitle: String {
        return "Result"
    }
    
    let resultString:String
    
    init(qtMeasurement: QtMeasurement, formula: QTcFormula) {
        if let result = qtMeasurement.calculateQTc(formula: formula) {
            resultString = "QTc = \(result) \(qtMeasurement.intervalUnits)"
        }
        else {
            resultString = "QTc = ERROR"
        }
    }
}

class DetailsViewModelFormulaDetailsItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .formulaDetails
    }
    
    var sectionTitle: String {
        return "Formula details"
    }
    
    var details: [String]
    
    init(qtMeasurement: QtMeasurement, formula: QTcFormula) {
        details = [String]()
        let name = "Formula name = \(qtMeasurement.calculatorName(formula: formula))"
        details.append(name)
        let shortName = "Short formula name = \(qtMeasurement.calculatorShortName)"
        details.append(shortName)
        let formulaType = "Formula type = QTc"
        details.append(formulaType)
        let qtcCalculator = QTc.qtcCalculator(formula: formula)
        let equation = "Equation = \(qtcCalculator.equation)"
        details.append(equation)
        // add reference, notes, but must calculate number of rows
    }
    
    var rowCount: Int {
        return details.count
    }
    
}

class DetailsViewModel: NSObject {
    var items = [DetailsViewModelItem]()
    
    let formula: QTcFormula
    let qtMeasurement: QtMeasurement
    let qtcCalculator: QTcCalculator
    
    init(formula: QTcFormula, qtMeasurement: QtMeasurement) {
        self.formula = formula
        self.qtMeasurement = qtMeasurement
        qtcCalculator = QTc.qtcCalculator(formula: formula)
        
        let nameItem = DetailsViewModelFormulaNameItem(name: qtcCalculator.longName)
        items.append(nameItem)
        let parametersItem = DetailsViewModelParametersItem(qtMeasurement: qtMeasurement)
        items.append(parametersItem)
        let resultItem = DetailsViewModelResultItem(qtMeasurement: qtMeasurement, formula: formula)
        items.append(resultItem)
        let formulaDetailsItem = DetailsViewModelFormulaDetailsItem(qtMeasurement: qtMeasurement, formula: formula)
        items.append(formulaDetailsItem)
        
    }
    
    func title() -> String {
        return "Details \(qtcCalculator.shortName)"
    }
}

extension DetailsViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .formulaName:
            if let cell = tableView.dequeueReusableCell(withIdentifier: FormulaNameCell.identifier, for: indexPath) as? FormulaNameCell {
                cell.item = item
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
}