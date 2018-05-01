//
//  LimitsCell.swift
//  EP QTc
//
//  Created by David Mann on 4/30/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit

class LimitsCell: UITableViewCell {
    static let identifier = "LimitsCell"
    
    @IBOutlet var label: UILabel!
    var item: DetailsViewModelItem? {
        didSet {
            guard let item = item as? DetailsViewModelLimitsItem else {
                return
            }
            label.text = item.limits
        }
    }
}
