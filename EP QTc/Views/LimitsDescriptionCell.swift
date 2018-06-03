//
//  LimitsDescriptionCell.swift
//  EP QTc
//
//  Created by David Mann on 5/4/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit

class LimitsDescriptionCell: UITableViewCell {
    static let identifier = "LimitsDescriptionCell"
    
    @IBOutlet var label: UILabel!
    
    var item: String? {
        didSet {
            guard let item = item else {
                return
            }
            label.text = item
        }
    }
}
