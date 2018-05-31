//
//  EP_QTcTests.swift
//  EP QTcTests
//
//  Created by David Mann on 12/2/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

import XCTest
@testable import EP_QTc
@testable import QTc

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
        qtMeasurement = QtMeasurement(qt: 500, intervalRate: 600, units: .msec, intervalRateType: .rate, sex: .unspecified, age: nil)
        XCTAssert(qtMeasurement.intervalRateUnits() == "bpm")
        qtMeasurement = QtMeasurement(qt: 500, intervalRate: 600, units: .sec, intervalRateType: .rate, sex: .unspecified, age: nil)
        XCTAssert(qtMeasurement.intervalUnits() == "sec")
        XCTAssert(qtMeasurement.intervalRateUnits() == "bpm")
        qtMeasurement = QtMeasurement(qt: 500, intervalRate: 600, units: .sec, intervalRateType: .interval, sex: .unspecified, age: nil)
        XCTAssert(qtMeasurement.intervalRateUnits() == "sec")
        XCTAssert(qtMeasurement.heartRateUnits() == "bpm")
    }
    
    func testFormatString() {
        var double: Double = 1.0 / 3.0
        var precision: Precision = .raw
        XCTAssertEqual(precision.formattedDouble(double), "0.33333333")
        precision = .roundFourPlaces
        XCTAssertEqual(precision.formattedDouble(double), "0.3333")
        precision = .roundOnePlace
        XCTAssertEqual(precision.formattedDouble(double), "0.3")
        precision = .roundToInteger
        XCTAssertEqual(precision.formattedDouble(double), "0")
        double = 3.3
        XCTAssertEqual(precision.formattedDouble(double), "3")
        double = 3.6
        XCTAssertEqual(precision.formattedDouble(double), "4")
        double = 3.555
        precision = .roundOnePlace
        XCTAssertEqual(precision.formattedDouble(double), "3.6")
        double = 3.4999
        XCTAssertEqual(precision.formattedDouble(double), "3.5")
        precision = .roundFourPlaces
        XCTAssertEqual(precision.formattedDouble(double), "3.4999")
        double = 3.49999
        XCTAssertEqual(precision.formattedDouble(double), "3.5000")
        double = 3.49995
        XCTAssertEqual(precision.formattedDouble(double), "3.5000")
        double = 3.499945
        XCTAssertEqual(precision.formattedDouble(double), "3.4999")
        double = 3.4999001
        XCTAssertEqual(precision.formattedDouble(double), "3.4999")
        double = 3.49986
        XCTAssertEqual(precision.formattedDouble(double), "3.4999")
        double = 3.5
        precision = .roundToInteger
        XCTAssertEqual(precision.formattedDouble(double), "4")
        double = 3.49999999999
        XCTAssertEqual(precision.formattedDouble(double), "3")
        precision = .roundFourFigures
        XCTAssertEqual(precision.formattedDouble(double), "3.5")
        double = 3.4333333
        XCTAssertEqual(precision.formattedDouble(double), "3.433")
        double = 455.16
        XCTAssertEqual(precision.formattedDouble(double), "455.2")


        // test formattedMeasurement() which takes into account units and rate/interval in formatting
        double = 3.49999999999
        precision = .roundToInteger
        var formattedMeasurement = precision.formattedMeasurement(measurement: double, units: .sec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "3.5000")
        formattedMeasurement = precision.formattedMeasurement(measurement: double, units: .msec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "3")
        precision = .roundOnePlace
        formattedMeasurement = precision.formattedMeasurement(measurement: double, units: .msec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "3.5")
        formattedMeasurement = precision.formattedMeasurement(measurement: double, units: .msec, intervalRateType: .rate)
        XCTAssertEqual(formattedMeasurement, "3.5")
        double = 431.67
        formattedMeasurement = precision.formattedMeasurement(measurement: double, units: .msec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "431.7")
        double = 431.66666
        precision = .roundFourPlaces
        formattedMeasurement = precision.formattedMeasurement(measurement: double, units: .msec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "431.6667")
        precision = .raw
        double = 431.77777777
        formattedMeasurement = precision.formattedMeasurement(measurement: double, units: .msec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "431.77777777")
        formattedMeasurement = precision.formattedMeasurement(measurement: double, units: .sec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "431.77777777")
        precision = .roundFourFigures
        formattedMeasurement = precision.formattedMeasurement(measurement: double, units: .sec, intervalRateType: .interval)
        XCTAssertEqual(formattedMeasurement, "431.8")

        
    }
    
    func testFormattedMeasurement() {
        var qtMeasurement = QtMeasurement(qt: 333, intervalRate: 444, units: .msec, intervalRateType: .interval, sex: .unspecified, age: nil)
        var precision: Precision = .roundToInteger
        XCTAssertEqual(precision.formattedMeasurementWithUnits(measurement:qtMeasurement.qt, units: .msec, intervalRateType: .interval), "333 msec")
        XCTAssertEqual(precision.formattedMeasurementWithUnits(measurement:qtMeasurement.qt, units: .msec, intervalRateType: .rate), "333 bpm")
        qtMeasurement = QtMeasurement(qt: 3.333, intervalRate: 444, units: .sec, intervalRateType: .interval, sex: .unspecified, age: nil)
        XCTAssertEqual(precision.formattedMeasurementWithUnits(measurement:qtMeasurement.qt, units: qtMeasurement.units, intervalRateType: qtMeasurement.intervalRateType), "3.3330 sec")
        precision = .roundFourFigures
        XCTAssertEqual(precision.formattedMeasurementWithUnits(measurement:qtMeasurement.qt, units: qtMeasurement.units, intervalRateType: qtMeasurement.intervalRateType), "3.333 sec")
        qtMeasurement = QtMeasurement(qt: 440.12, intervalRate: 444, units: .msec, intervalRateType: .interval, sex: .unspecified, age: nil)
        XCTAssertEqual(precision.formattedMeasurementWithUnits(measurement:qtMeasurement.qt, units: qtMeasurement.units, intervalRateType: qtMeasurement.intervalRateType), "440.1 msec")
    }
    
    func testAgeString() {
        var qtMeasurement = QtMeasurement(qt: 333, intervalRate: 444, units: .msec, intervalRateType: .interval, sex: .unspecified, age: nil)
        XCTAssertEqual(qtMeasurement.ageString(), "unspecified")
        qtMeasurement = QtMeasurement(qt: 333, intervalRate: 444, units: .msec, intervalRateType: .interval, sex: .unspecified, age: 33)
        XCTAssertEqual(qtMeasurement.ageString(), "33")

    }
    
    func testPreferences() {
        let preferences = Preferences()
        preferences.precision = Precision.roundFourPlaces
        preferences.sortOrder = SortOrder.byDate
        preferences.save()
        preferences.load()
        let precision = preferences.precision
        let sortOrder = preferences.sortOrder
        XCTAssertEqual(precision, Precision.roundFourPlaces)
        XCTAssertEqual(sortOrder, SortOrder.byDate)
    }
    
    func testFormulaSorting() {
        let qtFormulas = QtFormulas()
        let bigFour = qtFormulas.bigFourFormulas()
        let trueBigFour: [Formula] = [.qtcBzt, .qtcFrd, .qtcHdg, .qtcFrm]
        for idx in [0..<4] {
            XCTAssertEqual(bigFour[idx], trueBigFour[idx])
        }
        let trueSortedByDate: [Formula] = [.qtcBzt, .qtcFrd, .qtcMyd, .qtcAdm, .qtcHdg, .qtcKwt]
        let sortedByDate = qtFormulas.sortedByDate(formulas: trueSortedByDate)
        for idx in [0..<6] {
            XCTAssertEqual(sortedByDate[idx], trueSortedByDate[idx])
        }
        let trueSortedByName: [Formula] = [.qtcAdm, .qtcArr, .qtcBzt, .qtcDmt, .qtcFrm, .qtcFrd]
        let sortedByName = qtFormulas.sortedByName(formulas: trueSortedByName)
        for idx in [0..<6] {
            XCTAssertEqual(sortedByName[idx], trueSortedByName[idx])
        }
        let trueBigFourFirstByDate: [Formula] = [.qtcBzt, .qtcFrd, .qtcHdg, .qtcFrm, .qtcMyd, .qtcAdm]
        let bigFourFirstByDate = qtFormulas.bigFourFirstSortedByDate(formulas: trueBigFourFirstByDate, formulaType: .qtc)
        for idx in [0..<6] {
            XCTAssertEqual(bigFourFirstByDate[idx], trueBigFourFirstByDate[idx])
        }
        let trueBigFourFirstByName: [Formula] = [.qtcBzt, .qtcFrm, .qtcFrd, .qtcHdg, .qtcAdm, .qtcArr]
        let bigFourFirstByName = qtFormulas.bigFourFirstSortedByName(formulas: trueBigFourFirstByName, formulaType: .qtc)
        for idx in [0..<6] {
            XCTAssertEqual(bigFourFirstByName[idx], trueBigFourFirstByName[idx])
        }
    }
    
    func testAbnormalQTc() {
        var qtMeasurement = QtMeasurement(qt: nil, intervalRate: 400, units: .msec, intervalRateType: .interval)
        var severity = Calculator.resultSeverity(result: 450, qtMeasurement: qtMeasurement, formulaType: .qtc, qtcLimits: [.schwartz1985])
        XCTAssertEqual(severity, .abnormal)
        severity = Calculator.resultSeverity(result: 450, qtMeasurement: qtMeasurement, formulaType: .qtc, qtcLimits: [.aha2009]) // requires sex M or F
        XCTAssertEqual(severity, .undefined)
        // now make sure two test suites together work ok
        severity = Calculator.resultSeverity(result: 450, qtMeasurement: qtMeasurement, formulaType: .qtc, qtcLimits: [.schwartz1985, .aha2009])
        XCTAssertEqual(severity, .abnormal)
        severity = Calculator.resultSeverity(result: 430, qtMeasurement: qtMeasurement, formulaType: .qtc, qtcLimits: [.schwartz1985, .aha2009])
        XCTAssertEqual(severity, .normal)
        qtMeasurement = QtMeasurement(qt: nil, intervalRate: 400, units: .msec, intervalRateType: .interval, sex: .male)
        severity = Calculator.resultSeverity(result: 480, qtMeasurement: qtMeasurement, formulaType: .qtc, qtcLimits: [.aha2009])
        XCTAssertEqual(severity, .abnormal)
        qtMeasurement = QtMeasurement(qt: nil, intervalRate: 400, units: .msec, intervalRateType: .interval, sex: .unspecified)
        severity = Calculator.resultSeverity(result: 480, qtMeasurement: qtMeasurement, formulaType: .qtc, qtcLimits: [.aha2009])
        XCTAssertEqual(severity, .undefined)
        qtMeasurement = QtMeasurement(qt: nil, intervalRate: 400, units: .msec, intervalRateType: .interval, sex: .unspecified)
        severity = Calculator.resultSeverity(result: 485, qtMeasurement: qtMeasurement, formulaType: .qtc, qtcLimits: [.fda2005])
        XCTAssertEqual(severity, .moderate)
        qtMeasurement = QtMeasurement(qt: nil, intervalRate: 0.400, units: .sec, intervalRateType: .interval, sex: .unspecified)
        severity = Calculator.resultSeverity(result: 0.485, qtMeasurement: qtMeasurement, formulaType: .qtc, qtcLimits: [.fda2005])
        XCTAssertEqual(severity, .moderate)
        qtMeasurement = QtMeasurement(qt: nil, intervalRate: 0.400, units: .sec, intervalRateType: .interval, sex: .unspecified)
        severity = Calculator.resultSeverity(result: 0.445, qtMeasurement: qtMeasurement, formulaType: .qtc, qtcLimits: [.schwartz1985, .fda2005])
        XCTAssertEqual(severity, .abnormal)
        qtMeasurement = QtMeasurement(qt: nil, intervalRate: 0.500, units: .sec, intervalRateType: .interval, sex: .unspecified)
        severity = Calculator.resultSeverity(result: 0.500, qtMeasurement: qtMeasurement, formulaType: .qtc, qtcLimits: [.schwartz1985, .fda2005])
        XCTAssertEqual(severity, .moderate)
        qtMeasurement = QtMeasurement(qt: nil, intervalRate: 0.500, units: .sec, intervalRateType: .interval, sex: .unspecified)
        severity = Calculator.resultSeverity(result: 0.501, qtMeasurement: qtMeasurement, formulaType: .qtc, qtcLimits: [.schwartz1985, .fda2005])
        XCTAssertEqual(severity, .severe)
    }

    // Make sure all formulas have number of subjects
    func testNumberOfSubjects() {
        let qtcFormulas = QtFormulas().formulas[.qtc]
        let qtpFormulas = QtFormulas().formulas[.qtp]
        for formula in qtcFormulas! {
            XCTAssert(QTc.qtcCalculator(formula: formula).numberOfSubjects! > 0)
        }
        for formula in qtpFormulas! {
            XCTAssert(QTc.qtpCalculator(formula: formula).numberOfSubjects! > 0)
        }
    }

}
