//
//  About.swift
//  EP QTc
//
//  Created by David Mann on 12/11/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import UIKit

class About {
    let version = "1.0"
    
    func show(viewController: UIViewController) {
        let message = String(format: "Copyright © 2017, EP Studios, Inc.\nAll rights reserved.\nVersion %@", version)
        let dialog = UIAlertController(title: "EP QTc", message: message, preferredStyle: UIAlertControllerStyle.alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(dialog, animated: true, completion: nil)
    }
}


