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

public enum IntervalRate {
    case interval
    case rate
}

public enum Sex {
    case male
    case female
    case unspecified
}

public struct QtMeasurement {
    var qt: Double
    var rrRate: Double
    var units: Units
    var intervalRate: IntervalRate
    var sex: Sex?
    var age: Double?
    
    public func qtInSec() -> Double {
        return 0
    }
    
    public func rrInSec() -> Double {
        return 0
    }
    
    public func qtInMsec() -> Double {
        return 0
    }
    
    public func rrInMsec() -> Double {
        return 0
    }
    
    public func isValid() -> Bool {
        // validateQt
        // validateRrRate
        return true
    }
    
}
