//
//  QtMeasurement.swift
//  EP QTc
//
//  Created by David Mann on 12/2/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import Foundation
import QTc

public enum Units {
    case msec
    case sec
}

public enum IntervalRateType {
    case interval
    case rate
}

//public enum Sex {
//    case male
//    case female
//    case unspecified
//}

public struct QtMeasurement {
    var qt: Double
    var intervalRate: Double
    var units: Units
    var intervalRateType: IntervalRateType
    var sex: Sex
    var age: Double?
    
}
