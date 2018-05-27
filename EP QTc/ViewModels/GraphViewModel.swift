//
//  GraphViewModel.swift
//  EP QTc
//
//  Created by David Mann on 5/9/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import Foundation
import QTc
import SigmaSwiftStatistics
import Charts

class GraphViewModel {
    let undefinedColor = UIColor.lightGray
    let normalColor = UIColor.green
    let normalQTColor = UIColor.cyan
    let abnormalColor = UIColor.red
    let meanColor = UIColor.black
    let abnormalMeanColor = UIColor.blue
    let borderlineColor = UIColor.orange
    let mildColor = UIColor.orange
    let moderateColor = UIColor.red
    let severeColor = UIColor.purple
    
    var barChartView: BarChartView
    var qtMeasurement: QtMeasurement
    var formulaType: FormulaType
    var results: [Double]
    var formulas: [Formula]
    var preferences: Preferences
    
    init(barChartView: BarChartView, qtMeasurement: QtMeasurement, results: [Double], formulas: [Formula],
         formulaType: FormulaType, preferences: Preferences) {
        self.barChartView = barChartView
        self.qtMeasurement = qtMeasurement
        self.results = results
        self.formulas = formulas
        self.formulaType = formulaType
        self.preferences = preferences
    }
    
    func drawGraph() {
        var undefinedValues: [BarChartDataEntry] = []
        var normalValues: [BarChartDataEntry] = []
        var abnormalValues: [BarChartDataEntry] = []
        var borderlineValues: [BarChartDataEntry] = []
        var mildValues: [BarChartDataEntry] = []
        var moderateValues: [BarChartDataEntry] = []
        var severeValues: [BarChartDataEntry] = []
        var meanValues: [BarChartDataEntry] = []
        var i: Double = 0
        for result in results {
            let entry = BarChartDataEntry(x: i, y: result)
            i += 1
            let severity = Calculator.resultSeverity(result: result, qtMeasurement: qtMeasurement,
                                                     formulaType: formulaType, qtcLimits: preferences.qtcLimits)
            switch severity {
            case .undefined:
                undefinedValues.append(entry)
            case .normal:
                normalValues.append(entry)
            case .borderline:
                borderlineValues.append(entry)
            case .mild:
                mildValues.append(entry)
            case .moderate:
                moderateValues.append(entry)
            case .severe:
                severeValues.append(entry)
            case .abnormal:
                fallthrough
            default:
                abnormalValues.append(entry)
            }
        }
        if let mean = Sigma.average(results) {
            meanValues.append(BarChartDataEntry(x: Double(results.count), y: mean))
        }
        
        let baseLabel = formulaType.name
        // Note that QTp intervals can only be normal by definition
        let normalLabel = (formulaType == .qtp ? "QTp" : "Normal QTc")
        let normalValuesSet = BarChartDataSet(values: normalValues, label: normalLabel)
        normalValuesSet.setColor(normalColor)
        let undefinedValuesSet = BarChartDataSet(values: undefinedValues, label: "Uninterpreted QTc")
        let borderlineValuesSet = BarChartDataSet(values: borderlineValues, label: "Borderline QTc")
        borderlineValuesSet.setColor(borderlineColor)
        let mildValuesSet = BarChartDataSet(values: mildValues, label: "Mildly abnormal QTc")
        mildValuesSet.setColor(mildColor)
        let moderateValuesSet = BarChartDataSet(values: moderateValues, label: "Moderatedly abnormal QTc")
        moderateValuesSet.setColor(moderateColor)
        let severeValuesSet = BarChartDataSet(values: severeValues, label: "Severely abnormal QTc")
        severeValuesSet.setColor(severeColor)
        let abnormalValuesSet = BarChartDataSet(values: abnormalValues, label: "Abnormal \(baseLabel)")
        abnormalValuesSet.setColor(abnormalColor)
        
        // get mean QTc/p
        let meanValuesSet = BarChartDataSet(values: meanValues, label: "Mean \(baseLabel)")
        if Calculator.resultSeverity(result: meanValues[0].y, qtMeasurement: qtMeasurement, formulaType: formulaType, qtcLimits: preferences.qtcLimits).isAbnormal() {
            meanValuesSet.setColor(abnormalMeanColor)
        }
        else {
            meanValuesSet.setColor(meanColor)
        }
        // Show measured QT in QTp graph
        var qtValuesSet = BarChartDataSet()
        if let qt = qtMeasurement.qt, formulaType == .qtp {
            let qtValue = BarChartDataEntry(x: Double(results.count + 1), y: qt)
            qtValuesSet = BarChartDataSet(values: [qtValue], label: "QT")
            if let max = results.max(), let min = results.min(), qt > max || qt < min {
                qtValuesSet.setColor(abnormalColor)
            }
            else {
                qtValuesSet.setColor(normalQTColor)
            }
        }
        barChartView.data = BarChartData(dataSets: [undefinedValuesSet, normalValuesSet, borderlineValuesSet,
                                                    mildValuesSet, moderateValuesSet,
                                                    severeValuesSet, abnormalValuesSet,
                                                    meanValuesSet, qtValuesSet])
        let marker = QtMarkerView(color: UIColor(white: 180/250, alpha: 1), font: UIFont.boldSystemFont(ofSize: 12.0), textColor: UIColor.white, insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.formulas = formulas
        marker.formulaTypeName = formulaType.name
        barChartView.marker = marker
        // Chart description doesn't contrast well with the bars.
        barChartView.chartDescription?.enabled = false
        barChartView.pinchZoomEnabled = true
        barChartView.xAxis.enabled = false
        if formulaType == .qtp {
            if let max = results.max() {
                let maxQTpLimitLine = ChartLimitLine(limit: max)
                barChartView.leftAxis.addLimitLine(maxQTpLimitLine)
            }
            if let min = results.min() {
                let minQTpLimitLine = ChartLimitLine(limit: min)
                barChartView.leftAxis.addLimitLine(minQTpLimitLine)
            }
        }
        if let criteria = preferences.qtcLimits, formulaType == .qtc {
            for criterion in criteria {
                let testSuite = AbnormalQTc.qtcTestSuite(criterion: criterion)
                if let cutoffs = testSuite?.cutoffs() {
                    for cutoff in cutoffs {
                        let limitLine = ChartLimitLine(limit: cutoff.value)
                        limitLine.lineColor = cutoff.severity.color()
                        barChartView.leftAxis.addLimitLine(limitLine)
                    }
                }
            }
        }
        if let autoYAxis = preferences.automaticYAxis, var yAxisMax = preferences.yAxisMaximum, var yAxisMin = preferences.yAxisMinimum {
            if !autoYAxis {
                // In preferences, Y axis values are given as msec.
                if qtMeasurement.units == .sec {
                    yAxisMax = QTc.msecToSec(yAxisMax)
                    yAxisMin = QTc.msecToSec(yAxisMin)
                }
                barChartView.leftAxis.axisMaximum = yAxisMax
                barChartView.rightAxis.axisMaximum = yAxisMax
                barChartView.leftAxis.axisMinimum = yAxisMin
                barChartView.rightAxis.axisMinimum = yAxisMin
            }
        }
        if let animateGraphs = preferences.animateGraphs, animateGraphs {
            barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        }
        else {
            barChartView.setNeedsDisplay()
        }
    }
    
    func saveToCameraRoll() {
        UIImageWriteToSavedPhotosAlbum(barChartView.getChartImage(transparent: false)!, nil, nil, nil)
    }
    
    
    private class QtMarkerView: BalloonMarker {
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
}
