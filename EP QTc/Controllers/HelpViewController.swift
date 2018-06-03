//
//  HelpViewController.swift
//  EP QTc
//
//  Created by David Mann on 5/27/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {

    @IBOutlet var helpWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Help"
        if let path = Bundle.main.path(forResource: "help", ofType: "html", inDirectory: "docs") {
            helpWebView.load(URLRequest(url: URL(fileURLWithPath: path)))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
