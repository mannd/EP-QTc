//
//  AppDelegate.swift
//  EP QTc
//
//  Created by David Mann on 12/2/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let defaults = UserDefaults.standard
        defaults.register(defaults: [Preferences.precisionKey: Preferences.defaultPrecision.rawValue,
                                     Preferences.sortOrderKey: Preferences.defaultSortOrder.rawValue,
                                     Preferences.qtcLimitsKey: Preferences.defaultQTcLimitsArray,
                                     Preferences.automaticYAxisKey: Preferences.defaultAutomaticYAxis,
                                     Preferences.yAxisMaximumKey: Preferences.defaultYAxisMaximum,
                                     Preferences.yAxisMinimumKey: Preferences.defaultYAxisMinimum,
                                     Preferences.copyToCSVKey: Preferences.defaultCopyToCSV,
                                     Preferences.unitsKey: Preferences.defaultUnitsMsec,
                                     Preferences.heartRateKey: Preferences.defaultHeartRateAsInterval,
                                     Preferences.animateGraphsKey: Preferences.defaultAnimateGraphs,
                                     Preferences.qtcCustomSortKey: Preferences.defaultQTcCustomSort,
                                     Preferences.qtpCustomSortKey: Preferences.defaultQTpCustomSort
                                     ])
        return true
    }

    override
    func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        builder.remove(menu: .format)
        let preferencesCommand = UIKeyCommand(input: ",", modifierFlags: [.command], action: #selector(CalculatorViewController.showPreferences))
        preferencesCommand.title = "Preferences..."
        let openPreferences = UIMenu(title: "Preferences...", image: nil, identifier: UIMenu.Identifier("openPreferences"), options: .displayInline, children: [preferencesCommand])
        builder.insertSibling(openPreferences, afterMenu: .about)
    }

}
