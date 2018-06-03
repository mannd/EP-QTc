//
//  ParameterCell.swift
//  
//
//  Created by David Mann on 3/7/18.
//

import UIKit

class ParameterCell: UITableViewCell {
    static let identifier = "ParameterCell"
    
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    var item: Parameter? {
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
