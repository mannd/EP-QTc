//
//  GraphViewController.swift
//  EP QTc
//
//  Created by David Mann on 4/13/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import Charts
import SigmaSwiftStatistics
import QTc

// TODO: create full QTp rate vs QTp graph, with superimposed QT measurement at rate

class GraphViewController: UIViewController, ChartViewDelegate {
    let normalColor = UIColor.green
    let abnormalColor = UIColor.red
    let meanColor = UIColor.blue
    
    var qtMeasurement: QtMeasurement?
    var formulas: [Formula]?
    var formulaType: FormulaType?
    var results: [Double]?

    @IBOutlet var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        barChartView.delegate = self
        self.title = String(format: "%@ Chart", formulaType?.name ?? "Bar")
        var values: [BarChartDataEntry] = []
        var meanResult: [BarChartDataEntry] = []
        if let results = results {
            var i: Double = 0
            for result in results {
                let entry = BarChartDataEntry(x: i, y: result)
                i += 1
                values.append(entry)
             }
            if let mean = Sigma.average(results) {
                meanResult.append(BarChartDataEntry(x: Double(results.count), y: mean))
            }
        }
        var data: BarChartData
        let resultsSet = BarChartDataSet(values: values, label: formulaType?.name ?? "")
        // get mean QTc/p
        let meanResultSet = BarChartDataSet(values: meanResult, label: "Mean")
        meanResultSet.setColor(meanColor)
        // Show measured QT in QTp graph
        if let qtMeasurement = qtMeasurement, let qt = qtMeasurement.qt, let results = results,
            formulaType == .qtp {
            let qtEntry = BarChartDataEntry(x: Double(results.count + 1), y: qt)
            let qtResultsSet = BarChartDataSet(values: [qtEntry], label: "QT")
            if let max = results.max(), let min = results.min(), qt > max || qt < min {
                qtResultsSet.setColor(abnormalColor)
            }
            else {
                qtResultsSet.setColor(normalColor)
            }
            data = BarChartData(dataSets: [resultsSet, meanResultSet, qtResultsSet])
        }
        else {
            data = BarChartData(dataSets: [resultsSet, meanResultSet])
        }
        barChartView.data = data
        barChartView.animate(xAxisDuration: 2, yAxisDuration: 2)
        // no need to call barChartView.setNeedsDisplay() when using animation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
