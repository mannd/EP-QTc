//
//  InterpretationCell.swift
//  EP QTc
//
//  Created by David Mann on 4/27/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit

class InterpretationCell: UITableViewCell {
    static let identifier = "InterpretationCell"
    
    @IBOutlet var label: UILabel!
    var item: DetailsViewModelItem? {
        didSet {
            guard let item = item as? DetailsViewModelInterpretationItem else {
                return
            }
            label.text = item.interpetation
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
