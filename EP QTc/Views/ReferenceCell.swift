//
//  ReferenceCell.swift
//  EP QTc
//
//  Created by David Mann on 3/16/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit

class ReferenceCell: UITableViewCell {
    static let identifier = "ReferenceCell"

    @IBOutlet var label: UILabel!
    
    var item: DetailsViewModelItem? {
        didSet {
            guard let item = item as? DetailsViewModelReferenceItem else {
                return
            }
            label.text = item.reference
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
