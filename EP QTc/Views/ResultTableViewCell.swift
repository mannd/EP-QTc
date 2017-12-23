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
    
    var formula: QTcFormula!
    var qtMeasurement: QtMeasurement! {
        didSet {
            var formatString: String
            var unitsString: String
            if qtMeasurement.units == .msec {
                unitsString = "msec"
                formatString = "%.1f %@ "
            }
            else {
                unitsString = "sec"
                formatString = "%.4f %@ "
            }
            resultLabel.text = String(format: formatString, qtMeasurement.calculateQTc(formula: formula) ?? 0, unitsString)
            calculatorNameLabel.text = qtMeasurement.calculatorName(formula: formula)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        resultLabel.font = .boldSystemFont(ofSize: 24)
        accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    
    }

}
