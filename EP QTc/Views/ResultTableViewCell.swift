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
            resultLabel.text = String(format: "%.1f %@", qtMeasurement.calculateQTc(formula: formula) ?? 0, qtMeasurement.units == .msec ? " msec" : " sec")
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
