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
    // TODO: change these to system colors (? nicer in dark mode) for iOS 13
    let undefinedColor = UIColor.systemGray
    let normalColor = UIColor.systemGreen
    let abnormalColor = UIColor.systemRed
    let normalQTpColor = UIColor.prettyCyan()
    let normalMeanColor: UIColor
    let abnormalMeanColor = UIColor.systemBlue
    let borderlineColor = UIColor.systemOrange
    let mildColor = UIColor.systemOrange
    let moderateColor = UIColor.systemRed
    let severeColor = UIColor.systemPurple
    
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
        if #available(iOS 13.0, *) {
            normalMeanColor = UIColor.label
        } else {
            normalMeanColor = UIColor.black
        }
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

        if #available(iOS 13.0, *) {
            barChartView.xAxis.labelTextColor = UIColor.label
            barChartView.leftAxis.labelTextColor = UIColor.label
            barChartView.rightAxis.labelTextColor = UIColor.label
            barChartView.chartDescription?.textColor = UIColor.label
        } else {
            // Use default label color
        }

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
        let normalValuesSet = BarChartDataSet(entries: normalValues, label: normalLabel)
        normalValuesSet.setColor(formulaType == .qtp ? normalQTpColor: normalColor)
        let undefinedValuesSet = BarChartDataSet(entries: undefinedValues, label: "Uninterpreted QTc")
        let borderlineValuesSet = BarChartDataSet(entries: borderlineValues, label: "Borderline QTc")
        borderlineValuesSet.setColor(borderlineColor)
        let mildValuesSet = BarChartDataSet(entries: mildValues, label: "Mildly abnormal QTc")
        mildValuesSet.setColor(mildColor)
        let moderateValuesSet = BarChartDataSet(entries: moderateValues, label: "Moderatedly abnormal QTc")
        moderateValuesSet.setColor(moderateColor)
        let severeValuesSet = BarChartDataSet(entries: severeValues, label: "Severely abnormal QTc")
        severeValuesSet.setColor(severeColor)
        let abnormalValuesSet = BarChartDataSet(entries: abnormalValues, label: "Abnormal \(baseLabel)")
        abnormalValuesSet.setColor(abnormalColor)
        
        // get mean QTc/p
        let meanValuesSet = BarChartDataSet(entries: meanValues, label: "Mean \(baseLabel)")
        if Calculator.resultSeverity(result: meanValues[0].y, qtMeasurement: qtMeasurement, formulaType: formulaType, qtcLimits: preferences.qtcLimits).isAbnormal() {
            meanValuesSet.setColor(abnormalMeanColor)
        }
        else {
            meanValuesSet.setColor(normalMeanColor)
        }
        // Show measured QT in QTp graph
        var qtValuesSet = BarChartDataSet()
        if let qt = qtMeasurement.qt, formulaType == .qtp {
            let qtValue = BarChartDataEntry(x: Double(results.count + 1), y: qt)
            qtValuesSet = BarChartDataSet(entries: [qtValue], label: "QT")
            if let max = results.max(), let min = results.min(), qt > max || qt < min {
                qtValuesSet.setColor(abnormalColor)
            }
            else {
                qtValuesSet.setColor(normalColor)
            }
        }
        barChartView.data = BarChartData(dataSets: [undefinedValuesSet, normalValuesSet, borderlineValuesSet,
                                                    mildValuesSet, moderateValuesSet,
                                                    severeValuesSet, abnormalValuesSet,
                                                    meanValuesSet, qtValuesSet])
        let legend: Legend = barChartView.legend
        if #available(iOS 13.0, *) {
            legend.textColor = UIColor.label
        } else {
            // Use default legend color
        }
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
                if let cutoffs = testSuite?.cutoffs(units: qtMeasurement.units) {
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
    
    func saveToCameraRoll(target: Any, selector: Selector) {
        // Do nothing gracefully if necessary.
        guard let image = barChartView.getChartImage(transparent: false) else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, target, selector, nil)
    }

    private class QtMarkerView: BalloonMarker {
        var formulas: [Formula]?
        var formulaTypeName: String?
        
        public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
            if let formulas = formulas {
                let index = Int(entry.x)
                var label: String = ""
                if index < formulas.count {
                    label = formulas[index].shortName()
                }
                else if index == formulas.count {
                    label = "Mean \(formulaTypeName ?? "value")"
                }
                else if index == formulas.count + 1 {
                    label = "QT"  // only displayed with QTp graph
                }
                else {
                    label = "???"
                }
                label = label + "\n" + String(format: "%.1f", entry.y)
                setLabel(label)
            }
        }
    }
}
