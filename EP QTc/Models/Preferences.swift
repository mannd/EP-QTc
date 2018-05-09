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
    static let automaticYAxisKey = "AutomaticYAxisKey"
    static let yAxisMaximumKey = "YAxisMaximumKey"
    static let yAxisMinimumKey = "YAxisMinimumKey"
    static let copyToCSVKey = "CopyToCSVKey"
    
    static let defaultPrecision = Precision.roundToInteger
    static let defaultSortOrder = SortOrder.bigFourFirstByDate
    static let defaultQTcLimits: Set<Criterion> = [Criterion.schwartz1985]
    static let defaultQTcLimitsArray = [Criterion.schwartz1985.rawValue]
    static let defaultAutomaticYAxis = true
    static let defaultYAxisMaximum: Double = 600
    static let defaultYAxisMinimum: Double = 300
    static let defaultCopyToCSV: Bool = false
    
    var precision: Precision? = Preferences.defaultPrecision
    var sortOrder: SortOrder? = Preferences.defaultSortOrder
    var qtcLimits: Set<Criterion>? = Preferences.defaultQTcLimits
    var automaticYAxis: Bool? = Preferences.defaultAutomaticYAxis
    var yAxisMaximum: Double? = Preferences.defaultYAxisMaximum
    var yAxisMinimum: Double? = Preferences.defaultYAxisMinimum
    var copyToCSV: Bool? = Preferences.defaultCopyToCSV
    
    /// Returns updated set of preferences.
    static func retrieve() -> Preferences {
        let preferences = Preferences()
        preferences.load()
        return preferences
    }
    
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
        let array = criteria.map{$0.rawValue}
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
        defaults.set(automaticYAxis, forKey: Preferences.automaticYAxisKey)
        defaults.set(yAxisMaximum, forKey: Preferences.yAxisMaximumKey)
        defaults.set(yAxisMinimum, forKey: Preferences.yAxisMinimumKey)
        defaults.set(copyToCSV, forKey: Preferences.copyToCSVKey)
    }
    
    func load() {
        let defaults = UserDefaults.standard
        precision = Precision(rawValue: defaults.string(forKey: Preferences.precisionKey) ?? Preferences.defaultPrecision.rawValue)
        sortOrder = SortOrder(rawValue: defaults.string(forKey: Preferences.sortOrderKey) ?? Preferences.defaultSortOrder.rawValue)
        qtcLimits = convertCriteriaArray(array: defaults.array(forKey: Preferences.qtcLimitsKey) as? [String]) ?? Preferences.defaultQTcLimits
        automaticYAxis = defaults.bool(forKey: Preferences.automaticYAxisKey)
        yAxisMaximum = defaults.double(forKey: Preferences.yAxisMaximumKey)
        yAxisMinimum = defaults.double(forKey: Preferences.yAxisMinimumKey)
        copyToCSV = defaults.bool(forKey: Preferences.copyToCSVKey)
    }
    
    
    
    
    
}
