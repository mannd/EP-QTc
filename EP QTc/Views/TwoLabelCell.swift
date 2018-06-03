//
//  TwoLabelCell.swift
//  EP QTc
//
//  Created by David Mann on 3/8/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit

class TwoLabelCell: UITableViewCell {

    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
