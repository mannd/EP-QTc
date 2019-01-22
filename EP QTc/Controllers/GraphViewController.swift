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

final class GraphViewController: UIViewController {
    var qtMeasurement: QtMeasurement?
    var formulaType: FormulaType?
    var results: [Double]?
    var formulas: [Formula]?
    var viewModel: GraphViewModel?

    @IBOutlet var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let qtMeasurement = qtMeasurement, let formulaType = formulaType, let results = results,
            let formulas = formulas else {
            fatalError("qtMeasurement, formulaType, and results can't be nil.")
        }
        let preferences = Preferences.retrieve()
        self.title = String(format: "%@ Graph", formulaType.name)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveToCameraRoll))
        viewModel = GraphViewModel(barChartView: barChartView, qtMeasurement: qtMeasurement, results: results, formulas: formulas, formulaType: formulaType, preferences: preferences)
        viewModel?.drawGraph()
    }
    
    @objc func saveToCameraRoll() {
        viewModel?.saveToCameraRoll(target:self, selector:#selector(image(_:didFinishSavingWithError:contextInfo:)))
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        let ac = Alerts.saveAlert(error: error)
        present(ac, animated: true)
    }
}
