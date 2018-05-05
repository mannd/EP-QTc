//
//  StatsViewModel.swift
//  EP QTc
//
//  Created by David Mann on 3/27/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import QTc

// Stats are a flat table, all with same cell type
enum StatsViewModelItemType {
    case measurements
    case simpleStats
    case interpretations
}

protocol StatsViewModelItem {
    var type: StatsViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String { get }
}

extension StatsViewModelItem {
    var rowCount: Int {
        return 1
    }
}

class SimpleStatsItem: StatsViewModelItem {
    var type: StatsViewModelItemType {
        return .simpleStats
    }
    
    var sectionTitle: String {
        return "\(formulaType.name) statistics"
    }
    
    var rowCount: Int {
        return simpleStats.count
    }
    
    var simpleStats: [Stat]
    let formulaType: FormulaType
    
    init(simpleStats: [Stat], formulaType: FormulaType) {
        self.simpleStats = simpleStats
        self.formulaType = formulaType
    }
}

class MeasurementsItem: StatsViewModelItem {
    var type: StatsViewModelItemType {
        return .measurements
    }
    
    var sectionTitle: String {
        return "Measured intervals"
    }
    
    var rowCount: Int {
        return measurements.count
    }
    
    var measurements: [Stat]
    let formulaType: FormulaType
    
    init(measurements: [Stat], formulaType: FormulaType) {
        self.measurements = measurements
        self.formulaType = formulaType
    }
}

class InterpretationItem: StatsViewModelItem {
    var type: StatsViewModelItemType {
        return .interpretations
    }
    
    var sectionTitle: String {
        return "Interpretation"
    }
    
    var rowCount: Int {
        return interpretations.count
    }
    
    var interpretations: [Stat]
    
    init(interpretations: [Stat]) {
        self.interpretations = interpretations
    }
}

class StatsViewModel: NSObject {
    var items: [StatsViewModelItem] = []
    let simpleStats: [Stat]
    let measurements: [Stat]
    let interpretations: [Stat]
    let formulaType: FormulaType
    
    init(results: [Double], qtMeasurement: QtMeasurement, formulaType: FormulaType) {
        self.formulaType = formulaType
        
        let model = StatsModel(results: results, qtMeasurement: qtMeasurement, formulaType: formulaType)
        measurements = model.measurements
        let measuredQtItem = MeasurementsItem(measurements: measurements, formulaType: formulaType)
        items.append(measuredQtItem)
        simpleStats = model.simpleStats
        let simpleStatsItem = SimpleStatsItem(simpleStats: simpleStats, formulaType: formulaType)
        items.append(simpleStatsItem)
        interpretations = model.interpretations
        let interpretationsItem = InterpretationItem(interpretations: interpretations)
        items.append(interpretationsItem)
    }
}

extension StatsViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .simpleStats:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SimpleStatsCell.identifier, for: indexPath) as? SimpleStatsCell {
                cell.item = simpleStats[indexPath.row]
                return cell
            }
        case .measurements:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SimpleStatsCell.identifier, for: indexPath) as? SimpleStatsCell {
                cell.item = measurements[indexPath.row]
                return cell
            }
        case .interpretations:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SimpleStatsCell.identifier, for: indexPath) as? SimpleStatsCell {
                cell.item = interpretations[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
}


