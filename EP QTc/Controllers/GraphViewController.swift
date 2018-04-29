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

// TODO: pretty up the Y axis, e.g. go from reasonable ranges of QT interval (250 to 600 msec,
// 0.250 to .6 sec) unless a value is out of the range, in which case use automatic axes

// TODO: Color code QTc values by whether normal or not.
// E.g. when looping through values, keep x position but add value to normalresult vs abnormalresult entries.

class GraphViewController: UIViewController, ChartViewDelegate {
    let normalColor = UIColor.green
    let abnormalColor = UIColor.red
    let meanColor = UIColor.blue
    
    var qtMeasurement: QtMeasurement?
    var formulaType: FormulaType?
    var results: [Double]?

    @IBOutlet var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let qtMeasurement = qtMeasurement, let formulaType = formulaType, let results = results else {
            fatalError("qtMeasurement, formulaType, and results can't be nil.")
        }
        barChartView.delegate = self
        self.title = String(format: "%@ Graph", formulaType.name)
        var values: [BarChartDataEntry] = []
        var abnormalValues: [BarChartDataEntry] = []
        var meanValues: [BarChartDataEntry] = []
        var i: Double = 0
        for result in results {
            let entry = BarChartDataEntry(x: i, y: result)
            i += 1
            if (Calculator.resultSeverity(result: result, qtMeasurement: qtMeasurement, formulaType: formulaType).isAbnormal()) {
                abnormalValues.append(entry)
            }
            else {
                values.append(entry)
            }
        }
        if let mean = Sigma.average(results) {
            meanValues.append(BarChartDataEntry(x: Double(results.count), y: mean))
        }
        var data: BarChartData
        let baseLabel = formulaType.name
        let normalLabel = (formulaType == .qtp ? "QTp" : "Normal QTc")
        let normalValuesSet = BarChartDataSet(values: values, label: normalLabel)
        let abnormalValuesSet = BarChartDataSet(values: abnormalValues, label: "Abnormal \(baseLabel)")
        abnormalValuesSet.setColor(abnormalColor)
        // get mean QTc/p
        let meanValuesSet = BarChartDataSet(values: meanValues, label: "Mean \(baseLabel)")
        meanValuesSet.setColor(meanColor)
        // Show measured QT in QTp graph
        if let qt = qtMeasurement.qt, formulaType == .qtp {
            let qtValue = BarChartDataEntry(x: Double(results.count + 1), y: qt)
            let qtValuesSet = BarChartDataSet(values: [qtValue], label: "QT")
            if let max = results.max(), let min = results.min(), qt > max || qt < min {
                qtValuesSet.setColor(abnormalColor)
            }
            else {
                qtValuesSet.setColor(normalColor)
            }
            data = BarChartData(dataSets: [normalValuesSet, abnormalValuesSet, meanValuesSet, qtValuesSet])
        }
        else {
            data = BarChartData(dataSets: [normalValuesSet, abnormalValuesSet, meanValuesSet])
        }
        barChartView.data = data
        // FIXME: this is just an example of manual Y axis
        barChartView.leftAxis.axisMinimum = 250
        barChartView.leftAxis.axisMaximum = 550
        barChartView.animate(xAxisDuration: 2, yAxisDuration: 2)
        // no need to call barChartView.setNeedsDisplay() when using animation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
