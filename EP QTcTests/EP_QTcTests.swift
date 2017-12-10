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
        XCTAssertNil(vc.stringToDouble(string: nil))
        XCTAssert(vc.stringToDouble(string: "0") == 0.0)
        XCTAssertEqual(vc.stringToDouble(string: "123.45")!, 123.45, accuracy: 0.001)
        XCTAssertNil(vc.stringToDouble(string: "ABCCD"))
        XCTAssertNotNil(vc.stringToDouble(string: "+345."))
        XCTAssertEqual(vc.stringToDouble(string: "+345.")!, 345)
        XCTAssertNil(vc.stringToDouble(string: "-+345.0.1"))
    }
    
}
