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
            return "Borderline"
        case .abnormal:
            return "Abnormal"
        case .mild:
            return "Mildly abnormal"
        case .moderate:
            return "Moderately abnormal"
        case .severe:
            return "Severely abnormal"
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
    
    func fontWeight() -> UIFont.Weight {
        if self.isAbnormal() {
            return UIFont.Weight.bold
        } else {
            return UIFont.Weight.light
        }
    }
    
    func color() -> UIColor {
        let errorColor = UIColor.blue
        let normalColor: UIColor
        if #available(iOS 13.0, *) {
            normalColor = UIColor.label
        } else {
            normalColor = UIColor.black // green doesn't look good
        }
        let borderlineColor = UIColor.orange
        let mildColor = UIColor.orange
        let moderateColor = UIColor.red
        let severeColor = UIColor.purple
        let abnormalColor = UIColor.red
        let defaultColor = UIColor.black
        let undefinedColor = UIColor.gray
        switch self {
        case .error:
            return errorColor
        case .normal:
            return normalColor
        case .borderline:
            return borderlineColor
        case .mild:
            return mildColor
        case .moderate:
            return moderateColor
        case .severe:
            return severeColor
        case .abnormal:
            return abnormalColor
        case .undefined:
            return undefinedColor
        default:
            // above should be exhaustive, but compiler can't check this
            assertionFailure("Unknown severity.")
            return defaultColor
        }
    }
}
