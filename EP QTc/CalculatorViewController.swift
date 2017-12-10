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
extension UIViewController
{
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
    @IBOutlet var qtTextField: UITextField!
    @IBOutlet var intervalRateSegmentedControl: UISegmentedControl!
    @IBOutlet var intervalRateTextField: UITextField!
    @IBOutlet var sexLabel: UILabel!
    @IBOutlet var sexSegmentedControl: UISegmentedControl!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var ageTextField: UITextField!
    
    private var activeField: UITextField? = nil
    private var errorMessage = ""
    

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
    }

    @IBAction func unitsChanged(_ sender: Any) {
        // I'm not sure if should clear fields when units change.  For example,
        // someone might fill in the numbers and then realize they are using
        // secs instead of msec.  Just changing the units without erasing all the
        // inputted numbers would probably be the nicest thing to do.
        //clearFields()
    }

    @IBAction func intervalRateChanged(_ sender: Any) {
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
        //"^[-+]?(\\d*[.])?\\d+$"
        // Need to vary pattern according to region
        let separator = NSLocale.current.decimalSeparator
        let localizedPattern = String("^[-+]?(\\d*[\(separator ?? ".")])?\\d+$")
        let isNumberRule = ValidationRulePattern(pattern: localizedPattern, error: ValidationError(message: "No a true number"))

        let result = qtTextField.validate(rule: isNumberRule)
        switch result {
        case .valid: print("😀")
        case .invalid(let errors as? [ValidationError]): print(errors.first?.message)
        }
        let number = stringToDouble(qtTextField.text)
        if let number = number {
            let rangeRule = ValidationRuleComparison<Double>(min: 100, max: 1200, error: ValidationError(message: "Number not in range"))
            let result = number.validate(rule: rangeRule)
            switch result {
            case .valid: print("😀")
            case .invalid(let error as? ValidationError): print(error.message)
            }
        }
        else {
            print("bad number is nil!")
        }
        //        if validateFields() {
        //            performSegue(withIdentifier: "showResultsSegue", sender: self)
        //        }
    }
    
    @IBAction func clear(_ sender: Any) {
        clearFields()
        resetFieldBorder([qtTextField, intervalRateTextField, ageTextField])
    }
    
    private func resetFieldBorder(_ textFields: [UITextField]) {
        for textField in textFields {
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.layer.borderWidth = 0.25
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
