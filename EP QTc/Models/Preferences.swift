//
//  Preferences.swift
//  EP QTc
//
//  Created by David Mann on 4/24/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import Foundation

// TODO: new preference defaults must be registered in AppDelegate
class Preferences {
    static let precisionKey = "PrecisionKey"
    static let sortOrderKey = "SortOrderKey"
    
    static let defaultPrecision = Precision.roundToInteger
    static let defaultSortOrder = SortOrder.bigFourFirstByDate
    
    var precision: Precision?
    var sortOrder: SortOrder?
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(precision?.rawValue, forKey: Preferences.precisionKey)
        defaults.set(sortOrder?.rawValue, forKey: Preferences.sortOrderKey)
    }
    
    func load() {
        let defaults = UserDefaults.standard
        precision = Precision(rawValue: defaults.string(forKey: Preferences.precisionKey) ?? Preferences.defaultPrecision.rawValue)
        sortOrder = SortOrder(rawValue: defaults.string(forKey: Preferences.sortOrderKey) ?? Preferences.defaultSortOrder.rawValue)
    }
    
    
    
    
    
}
