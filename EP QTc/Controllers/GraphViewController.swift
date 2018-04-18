//
//  GraphViewController.swift
//  EP QTc
//
//  Created by David Mann on 4/13/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import Charts
import QTc

class GraphViewController: UIViewController, ChartViewDelegate {
    var qtMeasurement: QtMeasurement?
    var formulas: [Formula]?
    var formulaType: FormulaType?

    @IBOutlet var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        barChartView.delegate = self
        self.title = formulaType?.name ?? "Bar Chart"
        let entry: BarChartDataEntry = BarChartDataEntry(x:1, y:412)
        let entry2 = BarChartDataEntry(x: 2, y: 357)
        let set: BarChartDataSet = BarChartDataSet(values: [entry, entry2], label: "QTc")
        let entry3 = BarChartDataEntry(x: 5, y: 333)
        let set2 = BarChartDataSet(values: [entry3], label: "maxQTc")
        set2.setColor(UIColor.red)
        let data: BarChartData = BarChartData(dataSets: [set, set2])
        barChartView.data = data
        barChartView.highlightValue(x: 2, dataSetIndex: 0, stackIndex: 0)
        barChartView.setNeedsDisplay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
