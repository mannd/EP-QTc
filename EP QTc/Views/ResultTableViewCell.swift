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
        // Initialization code
        //resultLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    
    }

}
