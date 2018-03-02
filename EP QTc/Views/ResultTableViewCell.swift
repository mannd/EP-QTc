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

    @IBOutlet var calculatorNameLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var shortNameLabel: UILabel!
    
    var resultViewModel: ResultViewModel!
    
    var formula: QTcFormula!
    var qtMeasurement: QtMeasurement! {
        didSet {
            resultViewModel = ResultViewModel(formula: formula, qtMeasurement: qtMeasurement)
            resultLabel.text = resultViewModel.resultLabel()
            calculatorNameLabel.text = resultViewModel.longCalculatorName()
            shortNameLabel.text = resultViewModel.shortCalculatorName()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        resultLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    
    }

}
