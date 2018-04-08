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
    var formulas: [QTcFormula]?
    var selectedFormula: QTcFormula?

    
    // these are passed via the segue
    var qtMeasurement: QtMeasurement?
    
    enum FormulaSorting {
        case none
        case byDate
        case byName
        case bigFourFirstByDate
        case bigFourFirstByName
    }
    // TODO: add sorting by number of subjects (high to low and vice versa)
    // TODO: add sorting by formula type, with results table showing formula type section headers
    
    // Preferences
    // TODO: need mechanism to set preferences
    var sortingPreference: FormulaSorting = .bigFourFirstByDate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.title = "QTc"
       
//        processParameters()
        let qtFormulas = QtFormulas()
        switch sortingPreference {
        case .none:
            formulas = qtFormulas.formulas
        case .byDate:
            formulas = qtFormulas.sortedByDate()
        case .byName:
            formulas = qtFormulas.sortedByName()
        case .bigFourFirstByDate:
            formulas = qtFormulas.bigFourFirstSortedByDate()
        case .bigFourFirstByName:
            formulas = qtFormulas.bigFourFirstSortedByName()
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
    
    @IBAction func calculateStats(_ sender: Any) {
    }
    
    @IBAction func showGraph(_ sender: Any) {
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formulas?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as! ResultTableViewCell

        // Configure the cell...
        let row = indexPath.row
        let qtcFormula = formulas?[row]
        if let qtcFormula = qtcFormula {
            cell.formula = qtcFormula
            cell.qtMeasurement = qtMeasurement
        }
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        selectedFormula = formulas?[row]
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
        if segue.identifier == "detailsTableSegue" {
            let vc = segue.destination as! DetailsTableViewController
            vc.formula = selectedFormula
            vc.qtMeasurement = qtMeasurement
        }
        else if segue.identifier == "statsSegue" {
            let vc = segue.destination as! StatsTableViewController
            vc.formulas = formulas
            vc.qtMeasurement = qtMeasurement
        }
        
    }


}
