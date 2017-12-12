//
//  CalculatorViewController.swift
//  EP QTc
//
//  Created by David Mann on 12/2/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import UIKit
import Validator

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
    private let qtHintInMsec = "QT in msec"
    private let qtHintInSec = "QT in sec"
    private let intervalRateHintInMsec = "RR interval in msec"
    private let intervalRateHintInSec = "RR interval in sec"
    private let intervalRateHintInBpm = "Heart rate in bpm"
    
    private var activeField: UITextField? = nil
    private var errorMessage = ""
    private var units: Units = .msec
    private var intervalRate: IntervalRate = .interval
    
    enum EntryErrorCode {
        case invalidEntry
        case zeroOrNegativeEntry
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
        
        let separator = NSLocale.current.decimalSeparator
        // regex now prohibits negative values, 0, and things like 0.0, i.e. only positive floats accepted
        let localizedPattern = String("^[+]?(?!0*(\(separator ?? ".")0+)?$)(\\d*[\(separator ?? ".")])?\\d+$")
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
            if intervalRate == .interval {
                intervalRateUnitsLabel.text = msecText
                intervalRateTextField.placeholder = intervalRateHintInMsec
            }
        case .sec:
            qtUnitsLabel.text = secText
            qtTextField.placeholder = qtHintInSec
            if intervalRate == .interval {
                intervalRateUnitsLabel.text = secText
                intervalRateTextField.placeholder = intervalRateHintInSec
            }
        }
    }

    @IBAction func intervalRateChanged(_ sender: Any) {
        switch intervalRateSegmentedControl.selectedSegmentIndex {
        case 0:
            intervalRate = .interval
        case 1:
            intervalRate = .rate
        default:
            intervalRate = .interval
        }
        switch intervalRate {
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
        var error = false
        switch validationCode {
        case .invalidEntry:
            message = "Empty or invalid field(s)"
            error = true
        case .zeroOrNegativeEntry:
            message = "Zero or negative value(s)"
            error = true
        case .noError:
            break
        }
        if error {
            showErrorMessage(message)
            return
        }
        // segue here
        
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
        }
        if let rr = stringToDouble(intervalRateTextField.text) {
            if rr <= 0 {
                resultCode = .zeroOrNegativeEntry
            }
        }
        if let age = stringToDouble(ageTextField.text) {
            if age <= 0 {
                resultCode = .zeroOrNegativeEntry
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
        let vc = segue.destination as? ResultsTableViewController
        
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
