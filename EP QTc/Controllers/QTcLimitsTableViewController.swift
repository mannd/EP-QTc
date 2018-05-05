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
        
        qtcLimits = [.schwartz1985, .fda2005, .esc2005, .aha2009]
        let preferences = Preferences.retrieve()
        selectedQTcLimits = preferences.qtcLimits ?? []
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for element in selectedQTcLimits {
            print(element)  
        }
        let preferences = Preferences()
        preferences.qtcLimits = selectedQTcLimits
        preferences.save()
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
        let abnormalQTc = AbnormalQTc.qtcLimits(criterion: qtcLimits[indexPath.row])
        cell.textLabel?.text = abnormalQTc?.name
        cell.detailTextLabel?.text = abnormalQTc?.description
        
        for criterion in selectedQTcLimits {
            if let row = qtcLimits.index(of: criterion) {
                if row == indexPath.row {
                    cell.accessoryType = .checkmark
                }
            }
        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        // toggle checkmark
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            selectedQTcLimits.remove(qtcLimits[indexPath.row])
        }
        else {
            cell?.accessoryType = .checkmark
            selectedQTcLimits.insert(qtcLimits[indexPath.row])
        }
        cell?.setSelected(false, animated: true)
        
        
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
