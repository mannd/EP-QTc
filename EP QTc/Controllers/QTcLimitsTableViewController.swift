//
//  QTcLimitsTableViewController.swift
//  EP QTc
//
//  Created by David Mann on 4/25/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import QTc

final class QTcLimitsTableViewController: UITableViewController {

        
    var qtcLimits: [Criterion] = []
    var selectedQTcLimits: Set<Criterion> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qtcLimits = [.schwartz1985, .schwartz1993, .fda2005, .esc2005,
                     .goldenberg2006, .aha2009, .gollob2011, .mazzanti2014]
        let preferences = Preferences.retrieve()
        selectedQTcLimits = preferences.qtcLimits ?? []
        tableView.allowsMultipleSelection = false
        if selectedQTcLimits.count != 1, let firstLimit = qtcLimits.first {
            selectedQTcLimits = [firstLimit]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let preferences = Preferences.retrieve()
        preferences.qtcLimits = selectedQTcLimits
        preferences.save()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let selectedLimit = selectedQTcLimits.first else { return }
        if let row = qtcLimits.firstIndex(of: selectedLimit) {
            let indexPath = IndexPath(row: row, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return qtcLimits.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QTcLimitsCell", for: indexPath)
        let abnormalQTc = AbnormalQTc.qtcTestSuite(criterion: qtcLimits[indexPath.row])
        cell.textLabel?.text = abnormalQTc?.name
        cell.detailTextLabel?.text = abnormalQTc?.description
        cell.accessoryType = selectedQTcLimits.contains(qtcLimits[indexPath.row]) ? .checkmark : .none

        return cell
    }
    
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLimit = qtcLimits[indexPath.row]
        if selectedQTcLimits.contains(selectedLimit) {
            return
        }

        let previousLimit = selectedQTcLimits.first
        selectedQTcLimits = [selectedLimit]

        var indexPathsToReload: [IndexPath] = [indexPath]
        if let previousLimit, let previousRow = qtcLimits.firstIndex(of: previousLimit) {
            indexPathsToReload.append(IndexPath(row: previousRow, section: 0))
        }
        tableView.reloadRows(at: indexPathsToReload, with: .none)
    }

    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
