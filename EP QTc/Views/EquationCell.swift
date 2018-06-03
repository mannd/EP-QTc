//
//  EquationCell.swift
//  EP QTc
//
//  Created by David Mann on 3/16/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit

class EquationCell: UITableViewCell {
    static let identifier = "EquationCell"

    @IBOutlet var label: UILabel!
    var item: DetailsViewModelItem? {
        didSet {
            guard let item = item as? DetailsViewModelEquationItem else {
                return
            }
            label.text = item.equation
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
