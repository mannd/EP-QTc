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

final class GraphViewController: UIViewController {
    let normalColor = UIColor.green
    let abnormalColor = UIColor.red
    let meanColor = UIColor.blue
    
    var qtMeasurement: QtMeasurement?
    var formulaType: FormulaType?
    var results: [Double]?
    var formulas: [Formula]?

    @IBOutlet var barChartView: BarChartView!
    
    // TODO: Add further abnormal colors to correspond with .borderline, etc.
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let qtMeasurement = qtMeasurement, let formulaType = formulaType, let results = results else {
            fatalError("qtMeasurement, formulaType, and results can't be nil.")
        }
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
                // TODO: add Severity to array here, to allow for more colors depending on Severity
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
        let marker = QtMarkerView(color: UIColor(white: 180/250, alpha: 1), font: UIFont.boldSystemFont(ofSize: 12.0), textColor: UIColor.white, insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.formulas = formulas
        marker.formulaTypeName = formulaType.name
        barChartView.marker = marker
        barChartView.chartDescription?.enabled = false
        // FIXME: Is this useful?
        barChartView.pinchZoomEnabled = true
        
        // Y axis
        let preferences = Preferences()
        preferences.load()
        if let autoYAxis = preferences.automaticYAxis, let yAxisMax = preferences.yAxisMaximum, let yAxisMin = preferences.yAxisMinimum {
            if !autoYAxis {
                barChartView.leftAxis.axisMaximum = yAxisMax
                barChartView.leftAxis.axisMinimum = yAxisMin
            }
        }
 
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        // no need to call barChartView.setNeedsDisplay() when using animation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

public class QtMarkerView: BalloonMarker {
    var formulas: [Formula]?
    var formulaTypeName: String?
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        if let formulas = formulas {
            let index = Int(entry.x)
            if index < formulas.count {
                setLabel(formulas[index].shortName(formulaType: .qtc))
            }
            else if index == formulas.count {
                setLabel("Mean \(formulaTypeName ?? "value")")
            }
            else if index == formulas.count + 1 {
                setLabel("Measured QT")  // only displayed with QTp graph
            }
            else {
                setLabel("???")
            }
        }
    }
}
