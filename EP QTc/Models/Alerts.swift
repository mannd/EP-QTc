//
//  Alerts.swift
//  EP QTc
//
//  Created by David Mann on 1/22/19.
//  Copyright © 2019 EP Studios. All rights reserved.
//

import UIKit

class Alerts: NSObject {

    static func saveAlert(error: NSError?) -> UIAlertController {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription + ".\nMake sure you allow EP QTc to access Photos in the Settings app." , preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            return ac
        } else {
            let ac = UIAlertController(title: "Saved", message: "The graph has been saved to your Photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            return ac
        }
    }
}
