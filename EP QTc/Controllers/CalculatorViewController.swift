//
//  CalculatorViewController.swift
//  EP QTc
//
//  Created by David Mann on 12/2/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import UIKit
import Validator
import QTc

// Best way to dismiss keyboard on tap on view.
// See https://stackoverflow.com/questions/32281651/how-to-dismiss-keyboard-when-touching-anywhere-outside-uitextfield-in-swift
extension UIViewController {
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}



class CalculatorViewController: UIViewController, UITextFieldDelegate {
    
    // All the controls on the calculator form
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var unitsSegmentedControl: UISegmentedControl!
    @IBOutlet var qtTextField: CalculatorTextField!
    @IBOutlet var intervalRateSegmentedControl: UISegmentedControl!
    @IBOutlet var intervalRateTextField: CalculatorTextField!
    @IBOutlet var sexLabel: UILabel!
    @IBOutlet var sexSegmentedControl: UISegmentedControl!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var ageTextField: AgeTextField!
    @IBOutlet var qtUnitsLabel: UILabel!
    @IBOutlet var intervalRateUnitsLabel: UILabel!
    @IBOutlet var calculateButton: UIBarButtonItem!
 
    private let msecText = "msec"
    private let secText = "sec"
    private let bpmText = "bpm"
    private let qtHintInMsec = "QT (msec)"
    private let qtHintInSec = "QT (sec)"
    private let intervalRateHintInMsec = "RR (msec)"
    private let intervalRateHintInSec = "RR (sec)"
    private let intervalRateHintInBpm = "Heart rate (bpm)"
    private let invalidFieldsMessage = "Empty or invalid field(s)"
    private let badValuesMessage = "Zero or negative value(s)"
    private let ageOutOfRangeMessage = "Oldest human died at age 122"
    private let intervalOutOfRangeMessage = "Seems like your intervals are a bit too long"
    private let maxAge = 123.0
    private let maxInterval = 10_000.0
    
    private var activeField: UITextField? = nil
    private var errorMessage = ""
    private var units: Units = .msec
    private var intervalRateType: IntervalRateType = .interval
    
    enum EntryErrorCode {
        case invalidEntry
        case zeroOrNegativeEntry
        case ageOutOfRange
        case intervalOutOfRange
        case noError
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        qtTextField.delegate = self
        intervalRateTextField.delegate = self
        ageTextField.delegate = self
        // About info button
        let aboutButton = UIButton(type: .infoLight)
        aboutButton.addTarget(self, action: #selector(showAbout), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: aboutButton)
        
        qtTextField.placeholder = qtHintInMsec
        intervalRateTextField.placeholder = intervalRateHintInMsec
        
        let separator = NSLocale.current.decimalSeparator ?? "."
        // regex now prohibits negative values, 0, and things like 0.0, i.e. only positive floats accepted
        // see https://stackoverflow.com/questions/8910972/regex-exclude-zero
        let localizedPattern = String(format:"^(?!0*(\\%@0+)?$)(\\d+|\\d*\\%@\\d+)$", separator, separator)
        let isNumberRule = ValidationRulePattern(pattern: localizedPattern, error: ValidationError(message: "Invalid number"))
        var rules = ValidationRuleSet<String>()
        rules.add(rule: isNumberRule)
        qtTextField.validationRules = rules
        intervalRateTextField.validationRules = rules
        ageTextField.validationRules = rules
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
        hideKeyboard()
        view.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc
    func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo, let activeField = activeField else {
            return
        }
        if let kbSize =  (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var rect = self.view.frame
            rect.size.height -= kbSize.height
            if !rect.contains(activeField.frame.origin) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc
    func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets()
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc
    fileprivate func showAbout() {
        NSLog("Show about")
        let about = About()
        about.show(viewController: self)
    }

    @IBAction func unitsChanged(_ sender: Any) {
        switch unitsSegmentedControl.selectedSegmentIndex {
        case 0:
            units = .msec
        case 1:
            units = .sec
        default:
            units = .msec
        }
        switch units {
        case .msec:
            qtUnitsLabel.text = msecText
            qtTextField.placeholder = qtHintInMsec
            if intervalRateType == .interval {
                intervalRateUnitsLabel.text = msecText
                intervalRateTextField.placeholder = intervalRateHintInMsec
            }
        case .sec:
            qtUnitsLabel.text = secText
            qtTextField.placeholder = qtHintInSec
            if intervalRateType == .interval {
                intervalRateUnitsLabel.text = secText
                intervalRateTextField.placeholder = intervalRateHintInSec
            }
        }
    }

    @IBAction func intervalRateChanged(_ sender: Any) {
        switch intervalRateSegmentedControl.selectedSegmentIndex {
        case 0:
            intervalRateType = .interval
        case 1:
            intervalRateType = .rate
        default:
            intervalRateType = .interval
        }
        switch intervalRateType {
        case .interval:
            if units == .msec {
                intervalRateUnitsLabel.text = msecText
                intervalRateTextField.placeholder = intervalRateHintInMsec
            }
            else {
                intervalRateUnitsLabel.text = secText
                intervalRateTextField.placeholder = intervalRateHintInSec
            }
        case .rate:
            intervalRateUnitsLabel.text = bpmText
            intervalRateTextField.placeholder = intervalRateHintInBpm
        }
    }
    
    @IBAction func sexChanged(_ sender: Any) {
        sexLabel.isEnabled = !(sexSegmentedControl.selectedSegmentIndex == 0)
    }
    
    @IBAction func ageChanged(_ sender: Any) {
        ageLabel.isEnabled = ageTextField.text != nil && !ageTextField.text!.isEmpty
    }

    struct ValidationError: Error {
        public let message: String

        public init(message m: String) {
            message = m
        }
    }

    @IBAction func calculate(_ sender: Any) {
        let validationCode = fieldsValidationResult()
        var message = ""
        var error = true
        switch validationCode {
        case .invalidEntry:
            message = invalidFieldsMessage
        case .zeroOrNegativeEntry:
            message = badValuesMessage
        case .ageOutOfRange:
            message = ageOutOfRangeMessage
        case .intervalOutOfRange:
            message = intervalOutOfRangeMessage
        case .noError:
            error = false
        }
        // one last check to ensure no nulls or 0s sent over
        if error {
            showErrorMessage(message)
            return
        }
        performSegue(withIdentifier: "resultsTableSegue", sender: self)
    }
    
    private func fieldsValidationResult() -> EntryErrorCode {
        // Empty qt and interval fields will be considered invalid
        var resultCode: EntryErrorCode = .invalidEntry
        let qtIsValid = qtTextField.validate() == .valid
        let intervalRateIsValid = intervalRateTextField.validate() == .valid
        // Empty age field is OK
        let ageIsValid = ageTextField.text == nil || ageTextField.text!.isEmpty || ageTextField.validate() == .valid
        if qtIsValid && intervalRateIsValid && ageIsValid {
            resultCode = .noError
        }
        // Check for zero and negative values.
        if let qt = stringToDouble(qtTextField.text) {
            if qt <= 0 {
                resultCode = .zeroOrNegativeEntry
            }
            if qt > maxInterval {
                resultCode = .intervalOutOfRange
            }
        }
        if let rr = stringToDouble(intervalRateTextField.text) {
            if rr <= 0 {
                resultCode = .zeroOrNegativeEntry
                if rr > maxInterval {
                    resultCode = .intervalOutOfRange
                }
            }
        }
        if let age = stringToDouble(ageTextField.text) {
            if age <= 0 {
                resultCode = .zeroOrNegativeEntry
            }
            if age >= maxAge {
                resultCode = .ageOutOfRange
            }
        }
        return resultCode
    }
    
    private func showErrorMessage(_ message: String) {
        let dialog = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(dialog, animated: true, completion: nil)
    }
    
    @IBAction func clear(_ sender: Any) {
        clearFields()
        resetFieldBorder([qtTextField, intervalRateTextField, ageTextField])
    }
    
    private func resetFieldBorder(_ textFields: [UITextField]) {
        for textField in textFields {
            textField.resetFieldBorder()
        }
    }
    
    
    // This version of stringToDouble respects locale
    // (i.e. 140.4 OK in US, 140,4 OK in France
    func stringToDouble(_ string: String?) -> Double? {
        guard let string = string else { return nil }
        let nf = NumberFormatter()
        guard let number = nf.number(from: string) else { return nil }
        return number.doubleValue
    }
    
    private func clearFields() {
        qtTextField.text = ""
        intervalRateTextField.text = ""
        ageTextField.text = ""
        ageLabel.isEnabled = false
        sexSegmentedControl.selectedSegmentIndex = 0  // set sex to "unknown"
        sexLabel.isEnabled = false
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // First, final sanity check!
        if !finalValueCheck() {
            showErrorMessage(invalidFieldsMessage)
            return
        }
        
        let vc = segue.destination as! ResultsTableViewController
        
        let qt = stringToDouble(qtTextField.text) ?? 0
        let rr = stringToDouble(intervalRateTextField.text) ?? 0
        // these conditions are checked in validation and in finaValueCheck(), so should never happen!
        assert(qt > 0 && rr > 0)
        let units: Units = unitsSegmentedControl.selectedSegmentIndex == 0 ? .msec : .sec
        let intervalRateType: IntervalRateType = intervalRateSegmentedControl.selectedSegmentIndex == 0 ? .interval : .rate
        var sex: Sex = .unspecified
        switch sexSegmentedControl.selectedSegmentIndex {
        case 0:
            sex = .unspecified
        case 1:
            sex = .male
        case 2:
            sex = .female
        default:
            sex = .unspecified
        }
        let age = stringToDouble(ageTextField.text)
        let qtMeasurement = QtMeasurement(qt: qt, intervalRate: rr, units: units, intervalRateType: intervalRateType, sex: sex, age: age)
        vc.qtMeasurement = qtMeasurement
    }
    
    
    func finalValueCheck() -> Bool {
        // Don't ever send any nils, zeros or negative numbers to the poor calculators!
        let qt = stringToDouble(qtTextField.text) ?? 0
        let rr = stringToDouble(intervalRateTextField.text) ?? 0
        return qt > 0 && rr > 0
    }
    
    // MARK: - Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(false)
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    

}