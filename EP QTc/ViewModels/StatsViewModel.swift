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
    case simpleStats
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
        return "Pooled \(formulaType.name) Formulas Statistics"
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

class StatsViewModel: NSObject {
    var items: [StatsViewModelItem] = []
    let simpleStats: [Stat]
    let formulaType: FormulaType
    
    init(formulas: [Formula], qtMeasurement: QtMeasurement, formulaType: FormulaType) {
        self.formulaType = formulaType
        var results: [Double] = []
        for formula in formulas {
            let calculator = QTc.calculator(formula: formula)
            if let result = try? calculator.calculate(qtMeasurement: qtMeasurement) {
                    results.append(result!)
            }
        }
        let model = StatsModel(results: results, units: qtMeasurement.units)
        simpleStats = model.simpleStats
        let simpleStatsItem = SimpleStatsItem(simpleStats: simpleStats, formulaType: formulaType)
        items.append(simpleStatsItem)
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


