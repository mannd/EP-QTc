//
//  DetailsTableViewController.swift
//  EP QTc
//
//  Created by David Mann on 1/24/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import QTc

// TODO: click on reference cell with link and open linked webview

class DetailsTableViewController: UITableViewController {
    var formula: QTcFormula?
    var qtMeasurement: QtMeasurement?
    var detailsViewModel: DetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: nil)
        
        if let formula = formula, let qtMeasurement = qtMeasurement {
            detailsViewModel = DetailsViewModel(qtMeasurement: qtMeasurement, formula: formula)
            tableView?.dataSource = detailsViewModel
            tableView?.delegate = detailsViewModel
            detailsViewModel?.viewController = self
        }
        self.title = detailsViewModel?.title() ?? "Details"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "linkSegue" {
            
        }
        
    }
    
    

  

}
