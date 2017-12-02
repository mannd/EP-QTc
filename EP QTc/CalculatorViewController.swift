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
    
    @IBOutlet var sexSegmentedControl: UISegmentedControl!
    
    @IBOutlet var ageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
