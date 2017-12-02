//
//  CalculatorViewController.swift
//  EP QTc
//
//  Created by David Mann on 12/2/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import UIKit

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
    var activeField: UITextField? = nil
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var unitsSegmentedControl: UISegmentedControl!
    
    @IBOutlet var qtTextField: UITextField!
  
    @IBOutlet var intervalRateSegmentedControl: UISegmentedControl!
    
    @IBOutlet var intervalRateTextField: UITextField!
    
    @IBOutlet var sexLabel: UILabel!
    
    @IBOutlet var sexSegmentedControl: UISegmentedControl!
    
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var ageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        qtTextField.delegate = self
        intervalRateTextField.delegate = self
        ageTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        hideKeyboard()
        view.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    


    @IBAction func unitsChanged(_ sender: Any) {
        clearFields()
    }

    @IBAction func intervalRateChanged(_ sender: Any) {
    }
    
    @IBAction func sexChanged(_ sender: Any) {
        sexLabel.isEnabled = !(sexSegmentedControl.selectedSegmentIndex == 0)
    }
    
    @IBAction func ageChanged(_ sender: Any) {
        ageLabel.isEnabled = ageTextField.text != nil && !ageTextField.text!.isEmpty
    }
    
    @IBAction func calculate(_ sender: Any) {
        validateFields()
    }
    
    @IBAction func clear(_ sender: Any) {
        clearFields()
        qtTextField.becomeFirstResponder()
    }
    
    private func validateFields() {
        
    }
    
    private func clearFields() {
        qtTextField.text = ""
        intervalRateTextField.text = ""
        ageTextField.text = ""
        ageLabel.isEnabled = false
        sexSegmentedControl.selectedSegmentIndex = 0  // set sex to "unknown"
        sexLabel.isEnabled = false
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
