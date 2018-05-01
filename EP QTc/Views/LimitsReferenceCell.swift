//
//  LimitsReferenceCell.swift
//  EP QTc
//
//  Created by David Mann on 4/30/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit

class LimitsReferenceCell: UITableViewCell {
    static let identifier = "LimitsReferenceCell"
    let doiPattern = "doi:.*$"
    var doiString: String = ""
    
    @IBOutlet var label: UILabel!
    var item: String? {
        didSet {
            guard let item = item else {
                return
            }
            let underlinedString = NSMutableAttributedString(string: item)
            if let doiRegex = try? NSRegularExpression(pattern: doiPattern) {
                let result = doiRegex.matches(in: item, range: NSRange(item.startIndex..., in: item))
                let doiStrings = result.map {String(item[Range($0.range, in: item)!])}
                if doiStrings.count > 0 {
                    doiString = doiStrings[0]
                    let doiRange = (item as NSString).range(of: doiString)
                    let attributes: [NSAttributedStringKey: Any] = [.link: doiString,
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
