//
//  QTpRRViewModel.swift
//  EP QTc
//
//  Created by David Mann on 5/9/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import Foundation
import QTc
import Charts
import SigmaSwiftStatistics

extension UIColor {
    // This is the default graph color in Charts, a little lighter than UIColor.cyan
    static func prettyCyan() -> UIColor {
        return UIColor(displayP3Red: 0.54902, green: 0.917647, blue: 1, alpha: 1)
    }
}

class QTpRRViewModel {
    var chartView: ScatterChartView
    var qtMeasurement: QtMeasurement
    let preferences: Preferences
    let cyan = UIColor(displayP3Red: 0.54902, green: 0.917647, blue: 1, alpha: 1)
//    let cyan = [UIExtendedSRGBColorSpace 0.54902 0.917647 1 1]

    
    init(chartView: ScatterChartView, qtMeasurement: QtMeasurement) {
        self.chartView = chartView
        self.qtMeasurement = qtMeasurement
        self.preferences = Preferences.retrieve()
    }
    
    func drawGraph() {
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.chartDescription?.text = "QTp, QT (\(qtMeasurement.units.string)) vs Heart Rate (bpm)"
        var qtpValues: [ChartDataEntry] = []
        var qtValues: [ChartDataEntry] = []
        guard let qtpFormulas = QtFormulas().formulas[.qtp] else {
            fatalError("QTp formulas can't be nil.")
        }
        let units = qtMeasurement.units
        let sex = qtMeasurement.sex
        let age = qtMeasurement.age
        var results: [Double] = []
        let calculators = qtpFormulas.map {QTc.qtpCalculator(formula: $0)}
        for calculator in calculators {
            for rate in stride(from: 40.0, to: 130.0, by: 10.0) {
                if let qtp = try? calculator.calculate(rate: rate, sex: sex, age: age) {
                    // QTp calculators return result in secs when taking HR parameter
                    let entry = ChartDataEntry(x: rate, y: units == .sec ? qtp : QTc.secToMsec(qtp))
                    qtpValues.append(entry)
                }
            }
            if let result = try? calculator.calculate(rate: qtMeasurement.heartRate(), sex: sex, age: age) {
                results.append(units == .sec ? result : QTc.secToMsec(result))
            }
        }
        var qtIsAbnormal: Bool = false
        if let qt = qtMeasurement.qt {
            qtValues = [ChartDataEntry(x: qtMeasurement.heartRate(), y: qt)]
            if let max = Sigma.max(results), let min = Sigma.min(results) {
                qtIsAbnormal = qt > max || qt < min
            }
        }
        let qtSet = ScatterChartDataSet(entries: qtValues, label: (qtIsAbnormal ? "Abnormal " : "") + "QT")
        let qtpSet = ScatterChartDataSet(entries: qtpValues, label: "QTp")
        qtpSet.drawValuesEnabled = false
        qtSet.setColor(qtIsAbnormal ? UIColor.red : UIColor.green)
        qtpSet.setColor(UIColor.prettyCyan())
        qtpSet.setScatterShape(.circle)
        let data = ScatterChartData(dataSets: [qtpSet, qtSet])
        chartView.data = data
        if let animateGraphs = preferences.animateGraphs, animateGraphs {
            chartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        }
        else {
            chartView.setNeedsDisplay()
        }
    }
    
    func saveToCameraRoll(target: Any, selector: Selector) {
        // Do nothing gracefully if necessary.
        guard let image = chartView.getChartImage(transparent: false) else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, target, selector, nil)
    }
}
