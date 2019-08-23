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
    var doiString: String = ""
    var hasDoi : Bool = false

    @IBOutlet var label: UILabel!
    
    var item: DetailsViewModelItem? {
        didSet {
            guard let item = item as? DetailsViewModelReferenceItem else {
                return
            }
            let underlinedString = NSMutableAttributedString(string: item.reference)
            if let doiRegex = try? NSRegularExpression(pattern: doiPattern) {
                let result = doiRegex.matches(in: item.reference, range: NSRange(item.reference.startIndex..., in: item.reference))
                let doiStrings = result.map {String(item.reference[Range($0.range, in: item.reference)!])}
                if doiStrings.count > 0 {
                    hasDoi = true
                    doiString = doiStrings[0]
                    let doiRange = (item.reference as NSString).range(of: doiString)
                    // TODO: change to link color
                    let linkColor: UIColor
                    if #available(iOS 13.0, *) {
                        linkColor = UIColor.link
                    } else {
                        linkColor = UIColor.systemBlue
                    }
                    let attributes: [NSAttributedString.Key: Any] = [.link: doiString,
                                                                    .foregroundColor: linkColor]
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
    
    func resolvedDoiString() -> String {
        if doiString.count < 4 {
            return doiString
        }
        let strings = doiString.components(separatedBy: ":")
        let _ = strings[0]
        let tail = strings[1]
        return "https://doi.org/" + tail
    }

}
