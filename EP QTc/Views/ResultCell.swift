//
//  ResultCell.swift
//  EP QTc
//
//  Created by David Mann on 3/14/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
    static let identifier = "QTcResultCell"
    
    @IBOutlet var label: UILabel!
    var item: DetailsViewModelItem? {
        didSet {
            guard let item = item as? DetailsViewModelResultItem else {
                return
            }
            label.text = item.result
            label.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: item.severity.fontWeight())
            label.textColor = item.severity.color()
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
