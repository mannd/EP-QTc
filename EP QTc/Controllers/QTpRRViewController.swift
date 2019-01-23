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

class QTpRRViewController: UIViewController {

    @IBOutlet var chartView: ScatterChartView!
    
    var qtMeasurement: QtMeasurement?
    var viewModel: QTpRRViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let qtMeasurement = qtMeasurement else {
            fatalError("qtMeasurement can't be nil.")
        }
        // Do any additional setup after loading the view.
        self.title = "QTp vs Heart Rate"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveToCameraRoll))
       
        viewModel = QTpRRViewModel(chartView: chartView, qtMeasurement: qtMeasurement)
        viewModel?.drawGraph()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func saveToCameraRoll() {
        viewModel?.saveToCameraRoll(target:self, selector:#selector(image(_:didFinishSavingWithError:contextInfo:)))
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        let ac = Alerts.saveAlert(error: error)
        present(ac, animated: true)
    }
}
