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
    let unknownColor = UIColor.blue
    let normalColor = UIColor.green
    
    let preferences = Preferences.retrieve()

    var formulas: [Formula] = []
    var selectedFormula: Formula?
    var qtMeasurement: QtMeasurement?
    var formulaType: FormulaType?
    var resultsModel: ResultsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: nil)

        
        guard let formulaType = formulaType, let qtMeasurement = qtMeasurement else {
            assertionFailure("Error: formulaType and/or qtMeasurement can't be nil!")
            return
        }

        self.title = formulaType.name
               
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
        }
        
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
    }
}
