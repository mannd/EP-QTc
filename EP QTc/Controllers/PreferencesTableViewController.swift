//
//  PreferencesTableViewController.swift
//  EP QTc
//
//  Created by David Mann on 4/18/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import QTc

class PreferencesTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var precisionCell: UITableViewCell!
    @IBOutlet var precisionPicker: UIPickerView!
    @IBOutlet var sortingCell: UITableViewCell!
    @IBOutlet var sortingPicker: UIPickerView!
    @IBOutlet var qtcLimitsCell: UITableViewCell!
    
    let pickerViewHeight: CGFloat = 216.0
    let qtcLimitsRowHeight: CGFloat = 100.0
    
    let precisionRowNumber = 0
    let precisionPickerViewRowNumber = 1
    let sortingRowNumber = 2
    let sortingPickerViewRowNumber = 3
    let qtcLimitsRowNumber = 4
    
    let precisionPickerViewTag = 0
    let sortingPickerViewTag = 1
    
    var precisionPickerVisible = false
    var sortingPickerVisible = false
    
    var precisionLabels: [String] = []
    var sortOrderLabels: [String] = []
    var precisionOptions: [Precision] = []
    var sortOrderOptions: [SortOrder] = []
    
    var selectedFormatType: Precision = .raw
    var selectingSorting: SortOrder = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        
        precisionPicker.delegate = self
        precisionPicker.dataSource = self
        precisionPicker.tag = precisionPickerViewTag
        sortingPicker.delegate = self
        sortingPicker.dataSource = self
        sortingPicker.tag = sortingPickerViewTag
        
        // The elements of both pairs of arrays must match!
        precisionLabels = ["Full", "Integer", "1 place", "4 places"]
        precisionOptions = [.raw, .roundToInteger, .roundOnePlace, .roundFourPlaces]

        sortOrderLabels = ["Date", "Name", "Number of subjects", "Date big 4 first", "Name big 4 first", "Subjects big 4 first", "Formula type"]
        sortOrderOptions = [.byDate, .byName, .byNumberOfSubjects, .bigFourFirstByDate, .bigFourFirstByName, .bigFourByNumberOfSubjects, .byFormulaType]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        precisionPicker.isHidden = true
        sortingPicker.isHidden = true
        
        precisionPickerVisible = false
        sortingPickerVisible = false
        
        // must run this async, to allow for loading of data into pickers
        DispatchQueue.main.async {
            let preferences = Preferences()
            preferences.load()
            var preferenceRow = 0
            if let precisionPreference = preferences.precision {
                preferenceRow = self.precisionOptions.index(of: precisionPreference) ?? 0
            }
            var sortRow = 0
            if let sortPreference = preferences.sortOrder {
                sortRow = self.sortOrderOptions.index(of: sortPreference) ?? 0
            }
            self.precisionPicker.selectRow(preferenceRow, inComponent: 0, animated: false)
            self.sortingPicker.selectRow(sortRow, inComponent: 0, animated: false)
            
            self.precisionCell.detailTextLabel?.text = self.precisionLabels[preferenceRow]
            self.sortingCell.detailTextLabel?.text = self.sortOrderLabels[sortRow]
            self.qtcLimitsCell.detailTextLabel?.text = self.qtcLimitsString(preferences.qtcLimits)

        }
        
        super.viewWillAppear(animated)
    }
    
    private func qtcLimitsString(_ limits: Set<Criterion>?) -> String {
        guard let limits = limits, limits.count > 0 else {
            return "None"
        }
        var string = ""
        for limit in limits {
            if let abnormalQTc = AbnormalQTc.qtcLimits(criterion: limit) {
                string.append(abnormalQTc.name + "\n")
            }
        }
        return string
    }
    
    // FIXME: this also called when segueing to QTcLimitsViewController
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let precisionRow = precisionPicker.selectedRow(inComponent: 0)
        let sortRow = sortingPicker.selectedRow(inComponent: 0)
        let preferences = Preferences()
        preferences.load()
        preferences.precision = precisionOptions[precisionRow]
        preferences.sortOrder = sortOrderOptions[sortRow]
        preferences.save()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPickerView(_ picker: UIPickerView) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        picker.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {picker.alpha = 1},
                       completion: {finished in picker.isHidden = false})
    }
    
    func hidePickerView(_ picker: UIPickerView) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        picker.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {picker.alpha = 0},
                       completion: {finished in picker.isHidden = true})
    }
    
    func showPrecisionPickerViewCell() {
        precisionCell.detailTextLabel?.textColor = UIColor.red
        precisionPickerVisible = true
        showPickerView(precisionPicker)
    }
    
    func hidePrecisionPickerViewCell() {
        precisionCell.detailTextLabel?.textColor = UIColor.darkText
        precisionPickerVisible = false
        hidePickerView(precisionPicker)
    }
    
    func showSortingPickerViewCell() {
        sortingCell.detailTextLabel?.textColor = UIColor.red
        sortingPickerVisible = true
        showPickerView(sortingPicker)
    }
    
    func hideSortingPickerViewCell() {
        sortingCell.detailTextLabel?.textColor = UIColor.darkText
        sortingPickerVisible = false
        hidePickerView(sortingPicker)
    }
    
    // MARK: Picker view delegate and data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == precisionPickerViewTag {
            return precisionLabels.count
        }
        if pickerView.tag == sortingPickerViewTag {
            return sortOrderLabels.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == precisionPickerViewTag {
            return precisionLabels[row]
        }
        if pickerView.tag == sortingPickerViewTag {
            return sortOrderLabels[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == precisionPickerViewTag {
            precisionCell.detailTextLabel?.text = precisionLabels[row]
            selectedFormatType = precisionOptions[row]
        }
        if pickerView.tag == sortingPickerViewTag {
            sortingCell.detailTextLabel?.text = sortOrderLabels[row]
            selectingSorting = sortOrderOptions[row]
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = self.tableView.rowHeight;
        if indexPath.row == precisionPickerViewRowNumber {
            height = precisionPickerVisible ? pickerViewHeight : 0
        }
        if indexPath.row == sortingPickerViewRowNumber {
            height = sortingPickerVisible ? pickerViewHeight : 0
        }
        if indexPath.row == qtcLimitsRowNumber {
            height = qtcLimitsRowHeight
        }
        return height;
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == precisionRowNumber {
            if precisionPickerVisible {
                hidePrecisionPickerViewCell()
            }
            else {
                showPrecisionPickerViewCell()
                hideSortingPickerViewCell()
            }
        }
        if indexPath.row == sortingRowNumber {
            if sortingPickerVisible {
                hideSortingPickerViewCell()
            }
            else {
                showSortingPickerViewCell()
                hidePrecisionPickerViewCell()
            }
        }
        if indexPath.row >= qtcLimitsRowNumber {
            hideSortingPickerViewCell()
            hidePrecisionPickerViewCell()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "qtcLimitsSegue" {
//            let vc = segue.destination as? QTcLimitsTableViewController
//            let criteria: Set<Criterion> = [.schwartz1985]
//            vc?.selectedQTcLimits = criteria
//
//        }
//    }

}
