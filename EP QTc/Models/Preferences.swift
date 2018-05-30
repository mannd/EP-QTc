//
//  Preferences.swift
//  EP QTc
//
//  Created by David Mann on 4/24/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import Foundation
import QTc

class Preferences {
    static let precisionKey = "PrecisionKey"
    static let sortOrderKey = "SortOrderKey"
    static let qtcLimitsKey = "QTcLimitsKey"
    static let automaticYAxisKey = "AutomaticYAxisKey"
    static let yAxisMaximumKey = "YAxisMaximumKey"
    static let yAxisMinimumKey = "YAxisMinimumKey"
    static let copyToCSVKey = "CopyToCSVKey"
    static let unitsKey = "UnitsKey"
    static let heartRateKey = "HeartRateKey"
    static let animateGraphsKey = "AnimateGraphsKey"
    static let qtcCustomSortKey = "QTcCustomSortKey"
    static let qtpCustomSortKey = "QTpCustomSortKey"

    static let defaultPrecision = Precision.roundToInteger
    static let defaultSortOrder = SortOrder.bigFourFirstByDate
    static let defaultQTcLimits: Set<Criterion> = [Criterion.schwartz1985]
    static let defaultQTcLimitsArray = [Criterion.schwartz1985.rawValue]
    static let defaultAutomaticYAxis = true
    static let defaultYAxisMaximum: Double = 600
    static let defaultYAxisMinimum: Double = 300
    static let defaultCopyToCSV = false
    static let defaultUnitsMsec = true
    static let defaultHeartRateAsInterval = true
    static let defaultAnimateGraphs = true
    static let defaultQTcCustomSort: [String] = []
    static let defaultQTpCustomSort: [String] = []

    var precision: Precision? = Preferences.defaultPrecision
    var sortOrder: SortOrder? = Preferences.defaultSortOrder
    var qtcLimits: Set<Criterion>? = Preferences.defaultQTcLimits
    var automaticYAxis: Bool? = Preferences.defaultAutomaticYAxis
    var yAxisMaximum: Double? = Preferences.defaultYAxisMaximum
    var yAxisMinimum: Double? = Preferences.defaultYAxisMinimum
    var copyToCSV: Bool? = Preferences.defaultCopyToCSV
    var unitsMsec: Bool? = Preferences.defaultUnitsMsec
    var heartRateAsInterval: Bool? = Preferences.defaultHeartRateAsInterval
    var animateGraphs: Bool? = Preferences.defaultAnimateGraphs
    var qtcCustomSort: [Formula]? = []
    var qtpCustomSort: [Formula]? = []

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
            if let abnormalQTc = AbnormalQTc.qtcTestSuite(criterion: limit) {
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
        // sinces units and heart rate are binary values, will store as Bool
        defaults.set(unitsMsec, forKey: Preferences.unitsKey)
        defaults.set(heartRateAsInterval, forKey: Preferences.heartRateKey)
        defaults.set(animateGraphs, forKey: Preferences.animateGraphsKey)
        let qtcCustomSortMap = qtcCustomSort?.map {$0.rawValue}
        defaults.set(qtcCustomSortMap, forKey: Preferences.qtcCustomSortKey)
        let qtpCustomSortMap = qtpCustomSort?.map {$0.rawValue}
        defaults.set(qtpCustomSortMap, forKey: Preferences.qtpCustomSortKey)
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
        unitsMsec = defaults.bool(forKey: Preferences.unitsKey)
        heartRateAsInterval = defaults.bool(forKey: Preferences.heartRateKey)
        animateGraphs = defaults.bool(forKey: Preferences.animateGraphsKey)
        let qtcCustomSortMap = defaults.array(forKey: Preferences.qtcCustomSortKey) as? [String] ?? Preferences.defaultQTcCustomSort
        let qtpCustomSortMap = defaults.array(forKey: Preferences.qtpCustomSortKey) as? [String] ?? Preferences.defaultQTpCustomSort
        qtcCustomSort = qtcCustomSortMap.compactMap {Formula(rawValue: $0)}
        qtpCustomSort = qtpCustomSortMap.compactMap {Formula(rawValue: $0)}
    }
    
    
    
    
    
}
