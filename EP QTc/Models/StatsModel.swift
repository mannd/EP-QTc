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
    
    let mean: Double?
    let median: Double?
    let minimum: Double?
    let maximum: Double?
    let sd: Double?
    let variance: Double?
    let count: Int
    var simpleStats: [Stat] = []
    
    var measurements: [Stat] = []
    
    
    init(results: [Double], qtMeasurement: QtMeasurement) {
        let preferences = Preferences()
        preferences.load()
        let morePrecise = preferences.precision?.morePrecise()
        self.precision = morePrecise ?? .roundOnePlace
        self.units = qtMeasurement.units
        self.results = results
        
        count = results.count
        mean = Sigma.average(results)
        median = Sigma.median(results)
        minimum = Sigma.min(results)
        maximum = Sigma.max(results)
        sd = Sigma.standardDeviationPopulation(results)
        variance = Sigma.variancePopulation(results)
        let countStat = Stat()
        countStat.key = "N"
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
        let minStat = Stat()
        minStat.key = "Minimum value"
        minStat.value = formattedValue(minimum)
        simpleStats.append(minStat)
        let maxStat = Stat()
        maxStat.key = "Maximum value"
        maxStat.value = formattedValue(maximum)
        simpleStats.append(maxStat)
        let sdStat = Stat()
        sdStat.key = "Standard deviation"
        sdStat.value = formattedValue(sd)
        simpleStats.append(sdStat)
        let varianceStat = Stat()
        varianceStat.key = "Variance"
        varianceStat.value = formattedValue(variance)
        simpleStats.append(varianceStat)
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
        
    }
    
    private func formattedValue(_ value: Double?) -> String {
        guard let value = value else { return "Error" }
        return precision.formattedMeasurementWithUnits(measurement: value, units: units, intervalRateType: .interval)
    }

}

class Stat {
    var key: String?
    var value: String?
}

