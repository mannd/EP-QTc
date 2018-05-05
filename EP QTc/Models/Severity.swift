//
//  Severity.swift
//  EP QTc
//
//  Created by David Mann on 5/4/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

import Foundation
import QTc

extension Severity {
    
    var string: String {
        switch self {
        case .normal:
            return "Normal"
        case .borderline:
            return "Borderline prolongation"
        case .abnormal:
            return "Abnormal"
        case .mild:
            return "Mildly prolonged"
        case .moderate:
            return "Moderately prolonged"
        case .severe:
            return "Severely prolonged"
        case .undefined:
            return "Undefined"
        case .error:
            fallthrough
        default:
            return "Error"
        }
    }
    
    func interpretation(formulaType: FormulaType) -> String {
        if self == .error {
            return string
        }
        switch formulaType {
        case .qtp:
            return string + " QT"
        case .qtc:
            return string + " QTc"
        }
    }
}
