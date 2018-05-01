//
//  Preferences.swift
//  EP QTc
//
//  Created by David Mann on 4/24/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import Foundation
import QTc

// TODO: new preference defaults must be registered in AppDelegate
class Preferences {
    static let precisionKey = "PrecisionKey"
    static let sortOrderKey = "SortOrderKey"
    static let qtcLimitsKey = "QTcLimitsKey"
    
    static let defaultPrecision = Precision.roundToInteger
    static let defaultSortOrder = SortOrder.bigFourFirstByDate
    static let defaultQTcLimits: Set<Criterion> = [Criterion.schwartz1985]
    static let defaultQTcLimitsArray = [Criterion.schwartz1985.rawValue]
    
    var precision: Precision?
    var sortOrder: SortOrder?
    var qtcLimits: Set<Criterion>? = [.schwartz1985]
    
    func qtcLimitsString() -> String {
        guard let limits = qtcLimits, limits.count > 0 else {
            return "None"
        }
        var string = ""
        for limit in limits {
            if let abnormalQTc = AbnormalQTc.qtcLimits(criterion: limit) {
                string.append(abnormalQTc.name + "\n")
            }
        }
        return string
    }
    
    private func convertCriteriaSet(criteria: Set<Criterion>?) -> [String] {
        guard let criteria = criteria else { return [] }
        var array: [String] = []
        for criterion in criteria {
            array.append(criterion.rawValue)
        }
        return array
    }
    
    private func convertCriteriaArray(array: [String]?) -> Set<Criterion>? {
        guard let array = array else { return nil }
        var set: Set<Criterion> = []
        for string in array {
            if let criterion = Criterion(rawValue: string) {
                set.insert(criterion)
            }
        }
        return set
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(precision?.rawValue, forKey: Preferences.precisionKey)
        defaults.set(sortOrder?.rawValue, forKey: Preferences.sortOrderKey)
        defaults.set(convertCriteriaSet(criteria: qtcLimits), forKey: Preferences.qtcLimitsKey)
    }
    
    func load() {
        let defaults = UserDefaults.standard
        precision = Precision(rawValue: defaults.string(forKey: Preferences.precisionKey) ?? Preferences.defaultPrecision.rawValue)
        sortOrder = SortOrder(rawValue: defaults.string(forKey: Preferences.sortOrderKey) ?? Preferences.defaultSortOrder.rawValue)
        qtcLimits = convertCriteriaArray(array: defaults.array(forKey: Preferences.qtcLimitsKey) as? [String]) ?? Preferences.defaultQTcLimits
    }
    
    
    
    
    
}
