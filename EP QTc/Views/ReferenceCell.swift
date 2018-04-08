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
    let doiPattern = "doi:.*$"

    @IBOutlet var label: UILabel!
    
    var item: DetailsViewModelItem? {
        didSet {
            guard let item = item as? DetailsViewModelReferenceItem else {
                return
            }
            let underlinedString = NSMutableAttributedString(string: item.reference)
            if let doiRegex = try? NSRegularExpression(pattern: doiPattern) {
                let result = doiRegex.matches(in: item.reference, range: NSRange(item.reference.startIndex..., in: item.reference))
                let doiString = result.map {String(item.reference[Range($0.range, in: item.reference)!])}
                if doiString.count > 0 {
                    let doiRange = (item.reference as NSString).range(of: doiString[0])
                    let attributes: [NSAttributedStringKey: Any] = [.link: doiString[0],
                                                                    .foregroundColor: UIColor.blue]
                    underlinedString.addAttributes(attributes, range: doiRange)
                }
            }
            label.attributedText = underlinedString
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
