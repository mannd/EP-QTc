//
//  ResultTableViewCell.swift
//  EP QTc
//
//  Created by David Mann on 12/21/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import UIKit
import QTc

class ResultTableViewCell: UITableViewCell {
    static let identifier = "ResultCell"

    @IBOutlet var calculatorNameLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var shortNameLabel: UILabel!
    
    // FIXME: can potentially just use the value from the results array in ResultTableViewController,
    // and format it through ResultModel, rather than recalculating the value, to avoid doing the same
    // work twice.
    var resultViewModel: ResultViewModel!
    var calculator: Calculator!
    var qtMeasurement: QtMeasurement! {
        didSet {
            guard calculator != nil else {
                assertionFailure("Programming error: cell.calculator must be set before setting qtMeasurement!")
                return
            }
            resultViewModel = ResultViewModel(calculator: calculator, qtMeasurement: qtMeasurement)
            resultLabel.text = resultViewModel.resultLabel()
            resultLabel.textColor = resultViewModel.severityColor()
            calculatorNameLabel.text = resultViewModel.longCalculatorName()
            shortNameLabel.text = resultViewModel.shortCalculatorName()
            resultLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: resultViewModel.severityFontWeight())
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
    }
}
