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
    
    func testFormatString() {
        var double: Double = 1.0 / 3.0
        var formatType: FormatType = .raw
        XCTAssertEqual(formatType.formattedDouble(double), "0.33333333")
        formatType = .roundFourPlaces
        XCTAssertEqual(formatType.formattedDouble(double), "0.3333")
        formatType = .roundOnePlace
        XCTAssertEqual(formatType.formattedDouble(double), "0.3")
        formatType = .roundToInteger
        XCTAssertEqual(formatType.formattedDouble(double), "0")
        double = 3.3
        XCTAssertEqual(formatType.formattedDouble(double), "3")
        double = 3.6
        XCTAssertEqual(formatType.formattedDouble(double), "4")
        double = 3.555
        formatType = .roundOnePlace
        XCTAssertEqual(formatType.formattedDouble(double), "3.6")
        double = 3.4999
        XCTAssertEqual(formatType.formattedDouble(double), "3.5")
        formatType = .roundFourPlaces
        XCTAssertEqual(formatType.formattedDouble(double), "3.4999")
        double = 3.49999
        XCTAssertEqual(formatType.formattedDouble(double), "3.5000")
        double = 3.49995
        XCTAssertEqual(formatType.formattedDouble(double), "3.5000")
        double = 3.499945
        XCTAssertEqual(formatType.formattedDouble(double), "3.4999")
        double = 3.4999001
        XCTAssertEqual(formatType.formattedDouble(double), "3.4999")
        double = 3.49986
        XCTAssertEqual(formatType.formattedDouble(double), "3.4999")
        double = 3.5
        formatType = .roundToInteger
        XCTAssertEqual(formatType.formattedDouble(double), "4")
        double = 3.49999999999
        XCTAssertEqual(formatType.formattedDouble(double), "3")
        // test formattedMeasurement() which takes into account units and rate/interval in formatting
        var formattedMeasurement = formatType.formattedMeasurement(measurement: double, units: .sec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "3.5000")
        formattedMeasurement = formatType.formattedMeasurement(measurement: double, units: .msec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "3")
        formatType = .roundOnePlace
        formattedMeasurement = formatType.formattedMeasurement(measurement: double, units: .msec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "3.5")
        formattedMeasurement = formatType.formattedMeasurement(measurement: double, units: .msec, intervalRateType: .rate)
        XCTAssertEqual(formattedMeasurement, "3.5")
        double = 431.67
        formattedMeasurement = formatType.formattedMeasurement(measurement: double, units: .msec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "431.7")
        double = 431.66666
        formatType = .roundFourPlaces
        formattedMeasurement = formatType.formattedMeasurement(measurement: double, units: .msec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "431.6667")
        formatType = .raw
        double = 431.77777777
        formattedMeasurement = formatType.formattedMeasurement(measurement: double, units: .msec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "431.77777777")
        formattedMeasurement = formatType.formattedMeasurement(measurement: double, units: .sec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "431.77777777")


    }
    
}
