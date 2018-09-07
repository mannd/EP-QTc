//
//  About.swift
//  EP QTc
//
//  Created by David Mann on 12/11/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import UIKit

class About {
    func show(viewController: UIViewController) {
        let message = String(format: "Copyright © 2017, 2018 EP Studios, Inc.\nAll rights reserved.\nVersion %@", getVersion())
        let dialog = UIAlertController(title: "EP QTc", message: message, preferredStyle: UIAlertControllerStyle.alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(dialog, animated: true, completion: nil)
    }

    func getVersion() -> String {
        // if this doesn't unwrap, something is really wrong
        guard let dictionary = Bundle.main.infoDictionary else {
            preconditionFailure("Error: main bundle not found!")
        }
        let version = dictionary["CFBundleShortVersionString"] ?? "error"
    #if DEBUG // Get build number, if you want it. Cleaner to leave out of release version.
        let build = dictionary["CFBundleVersion"] ?? "error"
        // the version+build format is recommended by https://semver.org
        let versionBuild = "\(version)+\(build)"
        return versionBuild
    #else
        return version
    #endif
    }
}


