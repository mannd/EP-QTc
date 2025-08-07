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
    var backButton: UIBarButtonItem!
    var forwardButton: UIBarButtonItem!


    @IBOutlet var helpWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Help"
        if let path = Bundle.main.path(forResource: "help", ofType: "html", inDirectory: "docs") {
            helpWebView.load(URLRequest(url: URL(fileURLWithPath: path)))
        }
        backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(goBack(_:)))
        forwardButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(goForward(_:)))
        navigationItem.setRightBarButtonItems([forwardButton, backButton], animated: true)
        helpWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
        helpWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)

        updateButtons()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func goBack(_ sender: UIBarButtonItem) {
        if helpWebView.canGoBack {
            helpWebView.goBack()
        }
    }

    @objc func goForward(_ sender: UIBarButtonItem) {
        if helpWebView.canGoForward {
            helpWebView.goForward()
        }
    }

    func updateButtons() {
        backButton.isEnabled = helpWebView.canGoBack
        forwardButton.isEnabled = helpWebView.canGoForward
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.canGoBack) || keyPath == #keyPath(WKWebView.canGoForward) {
            updateButtons()
        }
    }
}
