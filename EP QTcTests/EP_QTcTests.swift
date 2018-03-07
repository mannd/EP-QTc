//
//  EP_QTcTests.swift
//  EP QTcTests
//
//  Created by David Mann on 12/2/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_QTc

class EP_QTcTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testStringToDouble() {
        let vc = CalculatorViewController()
        XCTAssertNil(vc.stringToDouble(nil))
        XCTAssert(vc.stringToDouble("0") == 0.0)
        XCTAssertEqual(vc.stringToDouble("123.45")!, 123.45, accuracy: 0.001)
        XCTAssertNil(vc.stringToDouble("ABCCD"))
        XCTAssertNotNil(vc.stringToDouble("-345.0"))
        XCTAssertEqual(vc.stringToDouble("345"), 345)
        XCTAssertNil(vc.stringToDouble("-+345.0.1"))
    }
    
    func testUnits() {
        var qtMeasurement = QtMeasurement(qt: 500, intervalRate: 600, units: .msec, intervalRateType: .interval, sex: .unspecified, age: nil)
        XCTAssert(qtMeasurement.intervalUnits() == "msec")
        XCTAssert(qtMeasurement.intervalRateUnits() == "msec")
        qtMeasurement.intervalRateType = .rate
        XCTAssert(qtMeasurement.intervalRateUnits() == "bpm")
        qtMeasurement.units = .sec
        XCTAssert(qtMeasurement.intervalUnits() == "sec")
        XCTAssert(qtMeasurement.intervalRateUnits() == "bpm")
        qtMeasurement.intervalRateType = .interval
        XCTAssert(qtMeasurement.intervalRateUnits() == "sec")
        XCTAssert(qtMeasurement.heartRateUnits() == "bpm")
    }
    
}
