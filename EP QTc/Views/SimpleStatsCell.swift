//
//  SimpleStatsCell.swift
//  EP QTc
//
//  Created by David Mann on 3/27/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit

class SimpleStatsCell: UITableViewCell {
    static let identifier = "SimpleStatsCell"

    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    var item: Stat? {
        didSet {
            guard let item = item else {
                return
            }
            leftLabel.text = item.key
            rightLabel.text = item.value
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
