//
//  DetailsViewModel.swift
//  EP QTc
//
//  Created by David Mann on 3/1/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import QTc
import SafariServices

// This TableView code is based on this very useful Medium article:
// https://medium.com/@stasost/ios-how-to-build-a-table-view-with-multiple-cell-types-2df91a206429

enum DetailsViewModelItemType {
    case parameters
    case result
    case interpretation
    case formulaDetails
    case equation
    case reference
    case notes
    case limits
    case limitsReference
    case limitsDescription
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

class DetailsViewModelParametersItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .parameters
    }
    
    var sectionTitle: String {
        return "Parameters"
    }
    
    var parameters: [Parameter]
    
    init(parameters: [Parameter]) {
        self.parameters = parameters
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
        return "Calculated \(formulaType.name) (\(units))"
    }
    
    var result: String
    var formulaType: FormulaType
    var units: String
    var severity: Severity
    
    init(result: String, formulaType: FormulaType, units: String, severity: Severity) {
        self.result = result
        self.formulaType = formulaType
        self.units = units
        self.severity = severity
        
    }
}

class DetailsViewModelInterpretationItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .interpretation
    }
    
    var sectionTitle: String {
        return "Interpretation"
    }
    
    var interpetation: String
    
    init(interpretation: String) {
        self.interpetation = interpretation
    }
}

class DetailsViewModelDetailsItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .formulaDetails
    }
    
    var sectionTitle: String {
        return "Formula details"
    }
    
    var details: [Parameter]
    
    init(details: [Parameter]) {
        self.details = details
    }
    
    var rowCount: Int {
        return details.count
    }
}

class DetailsViewModelEquationItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .equation
    }
    
    var sectionTitle: String {
        return "Equation"
    }
    
    var equation: String
    
    init(equation: String) {
        self.equation = equation
    }
}

class DetailsViewModelReferenceItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .reference
    }
    
    var sectionTitle: String {
        return "Reference"
    }
    
    var reference: String
    
    init(reference: String) {
        self.reference = reference
    }
}

class DetailsViewModelNotesItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .notes
    }
    
    var sectionTitle: String {
        return "Notes"
    }
    
    var notes: String
    
    init(notes: String) {
        self.notes = notes
    }
}

class DetailsViewModelLimitsItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .limits
    }
    
    var sectionTitle: String {
        return "QTc limits"
    }
    
    var limits: String
    
    init(limits: String) {
        self.limits = limits
    }
}

class DetailsViewModelLimitsReferenceItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .limitsReference
    }
    
    var sectionTitle: String {
        return String(format: "QTc limits reference%@", references.count > 1 ? "s" : "")
    }
    
    var references: [String]
    
    var rowCount: Int {
        return references.count
    }
    
    init(references: [String]) {
        self.references = references
    }
}

class DetailsViewModelLimitsDescriptionItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .limitsDescription
    }
    
    var sectionTitle: String {
        return String(format: "QTc limits details")
    }
    
    var descriptions: [String]
    
    var rowCount: Int {
        return descriptions.count
    }
    
    init(descriptions: [String]) {
        self.descriptions = descriptions
    }
    
}

class DetailsViewModel: NSObject {
    var items: [DetailsViewModelItem] = []
    let parameters: [Parameter]
    let details: [Parameter]
    let shortName: String
    var limitsReferences: [String] = []
    var limitsDescriptions: [String] = []
    let model: DetailsModel
    let formulaType: FormulaType
    let qtMeasurement: QtMeasurement
    
    weak var viewController: UITableViewController?
    
    init(qtMeasurement: QtMeasurement, calculator: Calculator, formulaType: FormulaType, results: [Double]) {
        self.formulaType = formulaType
        self.qtMeasurement = qtMeasurement
        model = DetailsModel(qtMeasurement: qtMeasurement, calculator: calculator, results: results)
        parameters = model.parameters
        let parametersItem = DetailsViewModelParametersItem(parameters: model.parameters)
        items.append(parametersItem)
        let resultItem = DetailsViewModelResultItem(result: model.result, formulaType: formulaType, units: qtMeasurement.units.string, severity: model.severity)
        items.append(resultItem)
        let interpretationItem = DetailsViewModelInterpretationItem(interpretation: model.interpretation)
        items.append(interpretationItem)
        details = model.details
        let detailsItem = DetailsViewModelDetailsItem(details: model.details)
        items.append(detailsItem)
        let equationItem = DetailsViewModelEquationItem(equation: model.equation)
        items.append(equationItem)
        let referenceItem = DetailsViewModelReferenceItem(reference: model.reference)
        items.append(referenceItem)
        let notesItem = DetailsViewModelNotesItem(notes: model.notes)
        // notes are sometimes emplty
        if !notesItem.notes.isEmpty {
            items.append(notesItem)
        }
        if formulaType == .qtc {
            let limitsItem = DetailsViewModelLimitsItem(limits: model.limits)
            items.append(limitsItem)
            limitsDescriptions = model.limitsDescriptions
            let limitsDescriptionsItem = DetailsViewModelLimitsDescriptionItem(descriptions: limitsDescriptions)
            items.append(limitsDescriptionsItem)
            limitsReferences = model.limitsReferences
            let limitsReferencesItem = DetailsViewModelLimitsReferenceItem(references: limitsReferences)
            items.append(limitsReferencesItem)
        }
        shortName = model.shortFormulaName
    }
    
    func title() -> String {
        return String.localizedStringWithFormat("%@", shortName)
    }
    
    func resultsSummary(preferences: Preferences) -> String {
        let copyToCSV = preferences.copyToCSV ?? Preferences.defaultCopyToCSV
        let delimiter = copyToCSV ? "," : " "
        let quoteString = copyToCSV
        let shortNameParameter = Parameter(key: "Formula", value: shortName)
        let resultParameter = Parameter(key: (formulaType == .qtc ? "QTc" : "QTp")
            + " (\(qtMeasurement.units.string))", value: model.result)
        let interpretationParameter = Parameter(key: "Interpretation", value: model.interpretation)
        let equationParameter = Parameter(key: "Equation", value: model.equation)
        let referenceParameter = Parameter(key: "Reference", value: model.reference)
        let notesParameter = Parameter(key: "Notes", value: model.notes)
        var limitNamesParameters: [Parameter] = []
        var limitReferencesParameters: [Parameter] = []
        var limitDetailsParameters: [Parameter] = []
        if let limits = preferences.qtcLimits {
            let qtcTests = limits.compactMap{ AbnormalQTc.qtcTestSuite(criterion: $0) }
            for test in qtcTests {
                let limitNameParameter = Parameter(key: "Limit", value: test.name)
                let limitReferenceParameter = Parameter(key: "Limit reference", value: test.reference)
                let limitDetailParameter = Parameter(key: "Limit details", value: test.description)
                limitNamesParameters.append(limitNameParameter)
                limitReferencesParameters.append(limitReferenceParameter)
                limitDetailsParameters.append(limitDetailParameter)
            }
        }
        var allDetails = [[shortNameParameter], parameters, [resultParameter],
                          [interpretationParameter], details, [equationParameter],
                          [referenceParameter],
                          [notesParameter]].flatMap{ $0 }
        if formulaType == .qtc {
            allDetails = [allDetails, limitNamesParameters,
                          limitDetailsParameters,
                          limitReferencesParameters].flatMap{ $0 }
        }
        var result: String = ""
        for detail in allDetails {
            if let key = detail.key, let value = detail.value {
                result += String.getSummaryLine(values: (key, value), quoteString: quoteString, delimiter: delimiter)
            }
        }
        return result
    }
}

// MARK: - Table view data source
extension DetailsViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .parameters:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ParameterCell.identifier, for: indexPath) as? ParameterCell {
                cell.item = parameters[indexPath.row]
                return cell
            }
        case .result:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.identifier, for: indexPath) as? ResultCell {
                cell.item = item
                return cell
            }
        case .interpretation:
            if let cell = tableView.dequeueReusableCell(withIdentifier: InterpretationCell.identifier, for: indexPath) as? InterpretationCell {
                cell.item = item
                return cell
            }
        case .formulaDetails:
            if let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.identifier, for: indexPath) as? DetailsCell {
                cell.item = details[indexPath.row]
                return cell
            }
        case .equation:
            if let cell = tableView.dequeueReusableCell(withIdentifier: EquationCell.identifier, for: indexPath) as? EquationCell {
                cell.item = item
                return cell
            }
        case .reference:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReferenceCell.identifier, for: indexPath) as? ReferenceCell {
                cell.item = item
                return cell
            }
        case .notes:
            if let cell = tableView.dequeueReusableCell(withIdentifier: NotesCell.identifier, for: indexPath) as? NotesCell {
                cell.item = item
                return cell
            }
        case .limits:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LimitsCell.identifier, for: indexPath) as? LimitsCell {
                cell.item = item
                return cell
            }
        case .limitsReference:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LimitsReferenceCell.identifier, for: indexPath) as? LimitsReferenceCell {
                cell.item = limitsReferences[indexPath.row]
                return cell
            }
        case .limitsDescription:
            if let cell = tableView.dequeueReusableCell(withIdentifier: LimitsDescriptionCell.identifier, for: indexPath) as? LimitsDescriptionCell {
                cell.item = limitsDescriptions[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
}

// MARK: - Table view delegate
extension DetailsViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section]
        if item.type == .reference {
            let selectedCell = tableView.cellForRow(at: indexPath) as? ReferenceCell
            if let doi = selectedCell?.resolvedDoiString() {
                if let url = URL(string: doi) {
                    let svc = SFSafariViewController(url: url)
                    viewController?.present(svc, animated: true, completion: nil)
                }
            }
        }
        if item.type == .limitsReference {
            let selectedCell = tableView.cellForRow(at: indexPath) as? LimitsReferenceCell
            if let doi = selectedCell?.resolvedDoiString() {
                if let url = URL(string: doi) {
                    let svc = SFSafariViewController(url: url)
                    viewController?.present(svc, animated: true, completion: nil)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
