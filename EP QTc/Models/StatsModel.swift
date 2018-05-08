//
//  StatsModel.swift
//  EP QTc
//
//  Created by David Mann on 3/27/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import SigmaSwiftStatistics
import QTc

class StatsModel {

    let units: Units
    let results: [Double]
    let precision: Precision
    let preferences: Preferences
    let qtMeasurement: QtMeasurement
    
    let mean: Double?
    let median: Double?
    let minimum: Double?
    let maximum: Double?
    let sd: Double?
//    let variance: Double?
    let count: Int
    var simpleStats: [Stat] = []
    var measurements: [Stat] = []
    var interpretations: [Stat] = []
    
    // TODO: consider adding number and % of abnormal QTcs
    
    init(results: [Double], qtMeasurement: QtMeasurement, formulaType: FormulaType) {
        preferences = Preferences.retrieve()
        let morePrecise = preferences.precision?.morePrecise()
        self.precision = morePrecise ?? .roundOnePlace
        self.units = qtMeasurement.units
        self.results = results
        self.qtMeasurement = qtMeasurement
        
        count = results.count
        mean = Sigma.average(results)
        median = Sigma.median(results)
        minimum = Sigma.min(results)
        maximum = Sigma.max(results)
        sd = Sigma.standardDeviationPopulation(results)
//        variance = Sigma.variancePopulation(results)
        let countStat = Stat()
        countStat.key = "Number of formulas"
        countStat.value = String(count)
        simpleStats.append(countStat)
        let meanStat = Stat()
        meanStat.key = "Mean"
        meanStat.value = formattedValue(mean)
        simpleStats.append(meanStat)
        let medianStat = Stat()
        medianStat.key = "Median"
        medianStat.value = formattedValue(median)
        simpleStats.append(medianStat)
        let maxStat = Stat()
        maxStat.key = "Maximum value"
        maxStat.value = formattedValue(maximum)
        simpleStats.append(maxStat)
        let minStat = Stat()
        minStat.key = "Minimum value"
        minStat.value = formattedValue(minimum)
        simpleStats.append(minStat)
        let sdStat = Stat()
        sdStat.key = "Standard deviation"
        sdStat.value = formattedValue(sd)
        simpleStats.append(sdStat)
        // Variance probably not needed, also variance units are msec^2 or sec^2
//        let varianceStat = Stat()
//        varianceStat.key = "Variance"
//        varianceStat.value = formattedValue(variance)
//        simpleStats.append(varianceStat)
        // TODO: etc.

        // A few measurements to compare stats to
        let measuredQT = Stat()
        measuredQT.key = "QT"
        measuredQT.value = formattedValue(qtMeasurement.qt)
        measurements.append(measuredQT)
        let measuredRR = Stat()
        measuredRR.key = "RR"
        measuredRR.value = formattedValue(qtMeasurement.rrInterval())
        measurements.append(measuredRR)
        
        // See if mean is abnormal
        if let mean = mean, let median = median, formulaType == .qtc {
            let meanSeverity = Calculator.resultSeverity(result: mean, qtMeasurement: qtMeasurement, formulaType: formulaType, qtcLimits: preferences.qtcLimits)
            let medianSeverity = Calculator.resultSeverity(result: median, qtMeasurement: qtMeasurement, formulaType: formulaType, qtcLimits: preferences.qtcLimits)
            let meanSeverityStat = Stat()
            meanSeverityStat.key = "Mean QTc"
            meanSeverityStat.value = meanSeverity.string
            interpretations.append(meanSeverityStat)
            let medianSeverityStat = Stat()
            medianSeverityStat.key = "Median QTc"
            medianSeverityStat.value = medianSeverity.string
            interpretations.append(medianSeverityStat)
            let abnormalCountStat = Stat()
            abnormalCountStat.key = "Number abnormal QTc"
            abnormalCountStat.value = abnormalResultsCountString()
            interpretations.append(abnormalCountStat)
            let abnormalResultsPercentStat = Stat()
            abnormalResultsPercentStat.key = "Percent abnormal QTc"
            abnormalResultsPercentStat.value = abnormalResultsPercentString()
            interpretations.append(abnormalResultsPercentStat)
        }
        else if let qt = qtMeasurement.qt, let minQTp = minimum, let maxQTp = maximum, formulaType == .qtp {
            let meanSeverityStat = Stat()
            meanSeverityStat.key = "QT vs QTp"
            let qtIsAbnormal = qt < minQTp || qt > maxQTp
            if qtIsAbnormal {
                meanSeverityStat.value = Severity.abnormal.string
            }
            else {
                meanSeverityStat.value = Severity.normal.string
            }
            interpretations.append(meanSeverityStat)
            if qtIsAbnormal {
                let deltaQTpStat = Stat()
                if qt > maxQTp {
                    deltaQTpStat.key = "Δ(QT-QTpMax)"
                    deltaQTpStat.value = deltaString(qt: qt, qtp: maxQTp)
                }
                else {  // must be less than minQTp, since already know isAbnormal
                    deltaQTpStat.key = "Δ(QT-QTpMin)"
                    deltaQTpStat.value = deltaString(qt: qt, qtp: minQTp)
                }
            interpretations.append(deltaQTpStat)
            }
        }
    }
    
    func deltaString(qt: Double, qtp: Double) -> String {
        return String(format: "%.f", qt - qtp)
    }
    
    func abnormalResultsPercentage() -> Double {
        return Double(abnormalResultsCount() * 100 / results.count)
    }
    
    func abnormalResultsCount() -> Int {
        var count = 0
        for result in results {
            let isAbnormal = Calculator.resultSeverity(result: result, qtMeasurement: qtMeasurement, formulaType: .qtc, qtcLimits: preferences.qtcLimits).isAbnormal()
            if isAbnormal {
                count += 1
            }
        }
        return count
    }
    
    func abnormalResultsCountString() -> String {
        return String(format: "%d/%d", abnormalResultsCount(), count)
    }
    
    func abnormalResultsPercentString() -> String {
        return String(format: "%.f%%", abnormalResultsPercentage())
    }
    
    private func formattedValue(_ value: Double?) -> String {
        guard let value = value else { return "Error" }
        return precision.formattedMeasurement(measurement: value, units: units, intervalRateType: .interval)
    }

}

class Stat {
    var key: String?
    var value: String?
}

