//
//  DetailsViewModel.swift
//  EP QTc
//
//  Created by David Mann on 3/1/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import UIKit
import QTc

enum DetailsViewModelItemType {
    case formulaName
    case parameters
    case result
    case formulaDetails
}

protocol DetailsViewModelItem {
    var type: DetailsViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String { get }
}

extension DetailsViewModelItem {
    var rowCount: Int {
        return 1
    }
}

class DetailsViewModelFormulaNameItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .formulaName
    }
    
    var sectionTitle: String {
        return "Formula"
    }
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

class DetailsViewModelParametersModelItem: DetailsViewModelItem {
    var type: DetailsViewModelItemType {
        return .parameters
    }
    
    var sectionTitle: String {
        return "Parameters"
    }
    
//    var rowCount: Int {
//        
//    }
//    
//    init(
    
    
}

class DetailsViewModel: NSObject {
   
    var items = [DetailsViewModelItem]()
    
    let formula: QTcFormula
    let qtMeasurement: QtMeasurement
    let qtcCalculator: QTcCalculator
    
    
    init(formula: QTcFormula, qtMeasurement: QtMeasurement) {
        self.formula = formula
        self.qtMeasurement = qtMeasurement
        qtcCalculator = QTc.qtcCalculator(formula: formula)
        
        let name = qtcCalculator.longName
        let nameItem = DetailsViewModelFormulaNameItem(name: name)
        items.append(nameItem)
        
    }
    
    func title() -> String {
        return "Details \(qtcCalculator.shortName)"
    }
    

}
