//
//  CalculatorViewController.swift
//  EP QTc
//
//  Created by David Mann on 12/2/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import UIKit



class CalculatorViewController: UIViewController {
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
        qtTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        ageLabel.isEnabled = !(ageLabel.text == nil || ageLabel.text!.isEmpty)
    }
    
    @IBAction func calculate(_ sender: Any) {
    }
    
    @IBAction func clear(_ sender: Any) {
        clearFields()
        qtTextField.becomeFirstResponder()
    }
    
    private func clearFields() {
        qtTextField.text = ""
        intervalRateTextField.text = ""
        ageTextField.text = ""
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
