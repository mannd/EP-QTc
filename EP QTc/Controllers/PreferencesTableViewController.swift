//
//  PreferencesTableViewController.swift
//  EP QTc
//
//  Created by David Mann on 4/18/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import QTc
import Validator

final class PreferencesTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet var precisionCell: UITableViewCell!
    @IBOutlet var precisionPicker: UIPickerView!
    @IBOutlet var sortingCell: UITableViewCell!
    @IBOutlet var sortingPicker: UIPickerView!
    @IBOutlet var qtcLimitsCell: UITableViewCell!
    @IBOutlet var automaticYAxisSwitch: UISwitch!
    @IBOutlet var yAxisMaximumCell: UITableViewCell!
    @IBOutlet var yAxisMinimumCell: UITableViewCell!
    @IBOutlet var yAxisMaximumTextField: CalculatorTextField!
    @IBOutlet var yAxisMinimumTextField: CalculatorTextField!
    @IBOutlet var copyToCsvSwitch: UISwitch!
    
    let errorResult: (Double?, Double?) = (nil, nil)
    
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

        precisionPicker.delegate = self
        precisionPicker.dataSource = self
        precisionPicker.tag = precisionPickerViewTag
        sortingPicker.delegate = self
        sortingPicker.dataSource = self
        sortingPicker.tag = sortingPickerViewTag
        yAxisMaximumTextField.delegate = self
        yAxisMinimumTextField.delegate = self
        
        // The elements of both pairs of arrays must match!
        precisionLabels = ["Full", "Integer", "1 place", "2 places", "4 places", "4 figures"]
        precisionOptions = [.raw, .roundToInteger, .roundOnePlace, .roundTwoPlaces, .roundFourPlaces, .roundFourFigures]

        sortOrderLabels = ["Date", "Name", "Number of subjects", "Date big 4 first", "Name big 4 first"]
        sortOrderOptions = [.byDate, .byName, .byNumberOfSubjects, .bigFourFirstByDate, .bigFourFirstByName]
        
        let separator = NSLocale.current.decimalSeparator ?? "."
        // regex allows zero and positive decimal numbers
        let localizedPattern = String(format:"^(?:\\d+|\\d*\\%@\\d+)$", separator, separator)
        let isNumberRule = ValidationRulePattern(pattern: localizedPattern, error: ValidationError(message: "Invalid number"))
        var rules = ValidationRuleSet<String>()
        rules.add(rule: isNumberRule)
        yAxisMinimumTextField.validationRules = rules
        yAxisMaximumTextField.validationRules = rules
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        precisionPicker.isHidden = true
        sortingPicker.isHidden = true
        
        precisionPickerVisible = false
        sortingPickerVisible = false
        
        // must run this async, to allow for loading of data into pickers.
        // self can be strongly captured in a DispatchQueue, since self holds no reference to the
        // DispatchQueue.
        DispatchQueue.main.async {
            let preferences = Preferences.retrieve()
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
            self.qtcLimitsCell.detailTextLabel?.text = preferences.qtcLimitsString()
            let automaticYAxisSwiftIsOn = preferences.automaticYAxis ?? Preferences.defaultAutomaticYAxis
            self.automaticYAxisSwitch.isOn = automaticYAxisSwiftIsOn
            self.copyToCsvSwitch.isOn = preferences.copyToCSV ?? Preferences.defaultCopyToCSV
            self.yAxisMaximumTextField.text = String(format: "%.f", preferences.yAxisMaximum ?? Preferences.defaultYAxisMaximum)
            self.yAxisMinimumTextField.text = String(format: "%.f", preferences.yAxisMinimum ?? Preferences.defaultYAxisMinimum)
            self.hideManualYAxisFields(hide: automaticYAxisSwiftIsOn)
        }
        super.viewWillAppear(animated)
    }
    
 
    // FIXME: this also called when segueing to QTcLimitsViewController
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let precisionRow = precisionPicker.selectedRow(inComponent: 0)
        let sortRow = sortingPicker.selectedRow(inComponent: 0)
        let yAxisFields = validatedYAxisFields()
        let preferences = Preferences.retrieve()
        preferences.precision = precisionOptions[precisionRow]
        preferences.sortOrder = sortOrderOptions[sortRow]
        preferences.automaticYAxis = automaticYAxisSwitch.isOn
        if !automaticYAxisSwitch.isOn && yAxisFields != errorResult {
            preferences.yAxisMaximum = yAxisFields.yAxisMax
            preferences.yAxisMinimum = yAxisFields.yAxisMin
        }
        preferences.copyToCSV = copyToCsvSwitch.isOn
        preferences.save()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validatedYAxisFields() -> (yAxisMax: Double?, yAxisMin: Double?) {
        if !yAxisMaximumTextField.validate().isValid || !yAxisMinimumTextField.validate().isValid {
            return errorResult
        }
        let yAxisMax = yAxisMaximumTextField.text?.stringToDouble()
        let yAxisMin = yAxisMinimumTextField.text?.stringToDouble()
        if let yAxisMax = yAxisMax, let yAxisMin = yAxisMin {
            if yAxisMax > yAxisMin {
                return (yAxisMax, yAxisMin)
            }
        }
        return errorResult
    }
    

    // This is needed for Validation rule, but will not be called.
    struct ValidationError: Error {
        public let message: String
        
        public init(message m: String) {
            message = m
        }
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
    
    func hideManualYAxisFields(hide: Bool) {
        yAxisMaximumCell.isHidden = hide
        yAxisMinimumCell.isHidden = hide
    }
    
    @IBAction func automaticYAxisValueChanged(_ sender: Any) {
        hideManualYAxisFields(hide: automaticYAxisSwitch.isOn)
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
        return 9
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 44.0
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
    
    // MARK: - Text field delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(false)
        return true
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
