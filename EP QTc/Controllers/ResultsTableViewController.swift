//
//  ResultsTableViewController.swift
//  EP QTc
//
//  Created by David Mann on 12/7/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import UIKit
import QTc

class ResultsTableViewController: UITableViewController {
    var formulas: [Formula] = []
    var selectedFormula: Formula?
    
    // these are passed via the segue
    var qtMeasurement: QtMeasurement?
    var formulaType: FormulaType?
    
    enum FormulaSorting {
        case none
        case byDate
        case byName
        case bigFourFirstByDate
        case bigFourFirstByName
        // TODO: implement these
        case byNumberOfSubjects
        case bigFourByNumberOfSubjects
        case byFormulaType
        
        // FIXME: might reduce number of cases by implementing bigFourFirst boolean
        // var bigFourFirst: Bool
    }
    
    // Preferences
    // TODO: need mechanism to set preferences
    var sortingPreference: FormulaSorting = .byDate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: nil)

        
        guard let formulaType = formulaType, qtMeasurement != nil else {
            assertionFailure("Error: formulaType and/or qtMeasurement can't be nil!")
            return
        }

        self.title = formulaType.name
       
//        processParameters()
        
        let qtFormulas = QtFormulas()
        guard let rawFormulas = qtFormulas.formulas[formulaType] else {
            assertionFailure("Formula type not found!")
            return
        }
        switch sortingPreference {
        case .none:
            formulas = rawFormulas
        case .byDate:
            formulas = qtFormulas.sortedByDate(formulas: rawFormulas, formulaType: formulaType)
        case .byName:
            formulas = qtFormulas.sortedByName(formulas: rawFormulas, formulaType: formulaType)
        // FIXME: next two have to account for formulaType
//        case .bigFourFirstByDate:
//            formulas = qtFormulas.bigFourFirstSortedByDate()
//        case .bigFourFirstByName:
//            formulas = qtFormulas.bigFourFirstSortedByName()
        default:
            assertionFailure("Sorting preference not implemented.")
        }
        
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

        // Configure the cell...
        let row = indexPath.row
        cell.calculator = QTc.calculator(formula: formulas[row])
        // must set calculator before qtMeasurement
        cell.qtMeasurement = qtMeasurement

        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        selectedFormula = formulas[row]
        performSegue(withIdentifier: "detailsTableSegue", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let formulaType = formulaType else { return }
        if segue.identifier == "detailsTableSegue" {
            guard let selectedFormula = selectedFormula else { return }
           let vc = segue.destination as! DetailsTableViewController
            vc.qtMeasurement = qtMeasurement
            vc.formulaType = formulaType
            vc.calculator = QTc.calculator(formula: selectedFormula)
        }
        else if segue.identifier == "statsSegue" {
            let vc = segue.destination as! StatsTableViewController
            vc.formulas = formulas
            vc.qtMeasurement = qtMeasurement
            vc.formulaType = formulaType
        }
        
    }


}
