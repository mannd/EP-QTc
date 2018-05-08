//
//  QTpRRViewController.swift
//  EP QTc
//
//  Created by David Mann on 5/8/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import Charts
import QTc
import SigmaSwiftStatistics

class QTpRRViewController: UIViewController {

    @IBOutlet var chartView: ScatterChartView!
    
    var qtMeasurement: QtMeasurement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let qtMeasurement = qtMeasurement else {
            fatalError("qtMeasurement can't be nil.")
        }
        // Do any additional setup after loading the view.
        self.title = "QTp vs Heart Rate"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveToCameraRoll))
        
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.chartDescription?.enabled = false

        
        var qtpValues: [ChartDataEntry] = []
        var qtValues: [ChartDataEntry] = []
        guard let qtpFormulas = QtFormulas().formulas[.qtp] else {
            fatalError("QTp formulas can't be nil.")
        }
        let units = qtMeasurement.units
        let sex = qtMeasurement.sex
        let age = qtMeasurement.age
        var results: [Double] = []
        let calculators = qtpFormulas.map{QTc.qtpCalculator(formula: $0)}
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
        let qtSet = ScatterChartDataSet(values: qtValues, label: (qtIsAbnormal ? "Abnormal " : "") + "QT")
        let qtpSet = ScatterChartDataSet(values: qtpValues, label: "QTp")
        qtpSet.drawValuesEnabled = false
        qtSet.setColor(qtIsAbnormal ? UIColor.red : UIColor.blue)
        qtpSet.setColor(UIColor.green)
        qtpSet.setScatterShape(.circle)
        let data = ScatterChartData(dataSets: [qtpSet, qtSet])
        //data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        
        chartView.data = data
        chartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func saveToCameraRoll() {
        UIImageWriteToSavedPhotosAlbum(chartView.getChartImage(transparent: false)!, nil, nil, nil)
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
