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

// TODO: Add link field to QTc library and make reference cell clickable to open webview with link
// TODO: Button to copy details to clipboard as text

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
        return "Calculated \(formulaType.name)"
    }
    
    var result: String
    var formulaType: FormulaType
    
    init(result: String, formulaType: FormulaType) {
        self.result = result
        self.formulaType = formulaType
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
    
    var details: [Detail]
    
    init(details: [Detail]) {
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

class DetailsViewModel: NSObject {
    var items: [DetailsViewModelItem] = []
    let parameters: [Parameter]
    let details: [Detail]
    let shortName: String
    var formulas: [Formula]?
    weak var viewController: UITableViewController?
    
    init(qtMeasurement: QtMeasurement, calculator: Calculator, formulaType: FormulaType, formulas: [Formula]?) {
        let model = DetailsModel(qtMeasurement: qtMeasurement, calculator: calculator, formulas: formulas)
        parameters = model.parameters
        let parametersItem = DetailsViewModelParametersItem(parameters: model.parameters)
        items.append(parametersItem)
        let resultItem = DetailsViewModelResultItem(result: model.result, formulaType: formulaType)
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
        
        shortName = model.shortFormulaName
    }
    
    func title() -> String {
        return String.localizedStringWithFormat("%@", shortName)
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
    }

}
