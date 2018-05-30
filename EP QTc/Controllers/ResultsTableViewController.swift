//
//  ResultsTableViewController.swift
//  EP QTc
//
//  Created by David Mann on 12/7/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import UIKit
import QTc

final class ResultsTableViewController: UITableViewController {
    @IBOutlet var editButton: UIBarButtonItem!
    
    let unknownColor = UIColor.blue
    let normalColor = UIColor.green
    
    let preferences = Preferences.retrieve()

    var formulas: [Formula] = []
    var selectedFormula: Formula?
    var qtMeasurement: QtMeasurement?
    var formulaType: FormulaType?
    var resultsModel: ResultsModel?
    var oldBarButtonItems: [UIBarButtonItem]?
    var originalFormulas: [Formula] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let formulaType = formulaType, let qtMeasurement = qtMeasurement else {
            assertionFailure("Error: formulaType and/or qtMeasurement can't be nil!")
            return
        }

        self.tableView.isEditing = false
        editButton.isEnabled = (preferences.sortOrder == .custom)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: #selector(oopyToClipboard))

        self.title = formulaType.name + " (\(qtMeasurement.units.string))"
               
        let qtFormulas = QtFormulas()
        guard let rawFormulas = qtFormulas.formulas[formulaType] else {
            assertionFailure("Formula type not found!")
            return
        }
        
        let sortingPreference = preferences.sortOrder ?? Preferences.defaultSortOrder
        switch sortingPreference {
        case .none:
            formulas = rawFormulas
        case .byDate:
            formulas = qtFormulas.sortedByDate(formulas: rawFormulas, formulaType: formulaType)
        case .byName:
            formulas = qtFormulas.sortedByName(formulas: rawFormulas, formulaType: formulaType)
        case .bigFourFirstByDate:
            formulas = qtFormulas.bigFourFirstSortedByDate(formulas: rawFormulas, formulaType: formulaType)
        case .bigFourFirstByName:
            formulas = qtFormulas.bigFourFirstSortedByName(formulas: rawFormulas, formulaType: formulaType)
        case .byNumberOfSubjects:
            formulas = qtFormulas.sortedByNumberOfSubjects(formulas: rawFormulas, formulaType: formulaType)
        // TODO: implement custom sorting
        case .custom:
            var customSort = (formulaType == .qtc ? preferences.qtcCustomSort : preferences.qtpCustomSort)
            if let sorted = customSort, sorted.count > 1 {
                formulas = sorted
            }
            else {
                formulas = qtFormulas.bigFourFirstSortedByDate(formulas: rawFormulas, formulaType: formulaType)
                customSort = formulas
                preferences.save()
            }
        }
        originalFormulas = formulas
        resultsModel = ResultsModel(formulas: formulas, qtMeasurement: qtMeasurement)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated);
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editTable(_ sender: Any) {
        oldBarButtonItems = toolbarItems
        toolbarItems?.removeAll()
        toolbarItems?.append(UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(ResultsTableViewController.saveEdit)))
        toolbarItems?.append(UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(ResultsTableViewController.resetEdit)))
        toolbarItems?.append(UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ResultsTableViewController.cancelEdit)))
        tableView.isEditing = true
    }

    @objc private func cancelEdit() {
        toolbarItems?.removeAll()
        toolbarItems = oldBarButtonItems
        tableView.isEditing = false
        formulas = originalFormulas
        tableView.reloadData()
    }

    @objc private func saveEdit() {
        toolbarItems?.removeAll()
        toolbarItems = oldBarButtonItems
        tableView.isEditing = false
//        formulas = originalFormulas
        originalFormulas = formulas
        if formulaType == .qtc {
            preferences.qtcCustomSort = formulas
        }
        else {
            preferences.qtpCustomSort = formulas
        }
        preferences.save()
        resultsModel = ResultsModel(formulas: formulas, qtMeasurement: qtMeasurement!)
        tableView.reloadData()
    }

    @objc private func resetEdit() {
        toolbarItems?.removeAll()
        toolbarItems = oldBarButtonItems
        tableView.isEditing = false
        let qtFormulas = QtFormulas()
        guard let formulaType = formulaType, let rawFormulas = qtFormulas.formulas[formulaType] else {
            assertionFailure("Formula type or formula not found!")
            return
        }
        formulas = qtFormulas.bigFourFirstSortedByDate(formulas: rawFormulas, formulaType: formulaType)
        originalFormulas = formulas
        if formulaType == .qtc {
            preferences.qtcCustomSort = formulas
        }
        else {
            preferences.qtpCustomSort = formulas
        }
        preferences.save()
        resultsModel = ResultsModel(formulas: formulas, qtMeasurement: qtMeasurement!)

        tableView.reloadData()

    }

    @objc private func oopyToClipboard() {
        if let text = resultsModel?.resultsSummary(preferences: preferences) {
            print(text)
            UIPasteboard.general.string = text
            showCopyToClipboardDialog(inCSVFormat: preferences.copyToCSV ?? false)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formulas.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as! ResultTableViewCell
        // Must set calculator and preferences before qtMeasurement.
        // Passing preloaded preferences, rather than have each cell load preferences.
        cell.preferences = preferences
        cell.calculator = resultsModel?.allCalculators()[indexPath.row]
        cell.qtMeasurement = qtMeasurement
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        selectedFormula = formulas[row]
        performSegue(withIdentifier: "detailsTableSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .none
//    }
//
//    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = formulas[sourceIndexPath.row]
        formulas.remove(at: sourceIndexPath.row)
        formulas.insert(movedObject, at: destinationIndexPath.row)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.formulas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let formulaType = formulaType else { return }
        if segue.identifier == "detailsTableSegue" {
            guard let selectedFormula = selectedFormula else { return }
            if let vc = segue.destination as? DetailsTableViewController {
                vc.qtMeasurement = qtMeasurement
                vc.formulaType = formulaType
                vc.calculator = QTc.calculator(formula: selectedFormula)
                // we pass the results array to see if QT outside of max/min QTp range
                vc.results = resultsModel?.allResults() ?? []
            }
        }
        else if segue.identifier == "statsSegue" {
            if let vc = segue.destination as? StatsTableViewController {
                vc.qtMeasurement = qtMeasurement
                vc.formulaType = formulaType
                vc.results = resultsModel?.allResults() ?? []
            }
        }
        else if segue.identifier == "graphSegue" {
            if let vc = segue.destination as? GraphViewController {
                vc.qtMeasurement = qtMeasurement
                vc.formulaType = formulaType
                vc.results = resultsModel?.allResults() ?? []
                vc.formulas = resultsModel?.allFormulas() ?? []
            }
        }
        else if segue.identifier == "QTpvRRSegue" {
            if let vc = segue.destination as? QTpRRViewController {
                vc.qtMeasurement = qtMeasurement
            }
        }
    }
}
