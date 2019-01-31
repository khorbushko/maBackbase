//
//  maBackbaseTests.swift
//  maBackbaseTests
//
//  Created by Kirill Gorbushko on 1/30/19.
//  Copyright © 2019 - present. All rights reserved.
//

import XCTest

final class DatFileReadingTests: XCTestCase {

    // MARK: - DatFileReading preformance

    func testDataFileObject() {

        let fileObjec = DataFile(.cities)
        XCTAssert(fileObjec?.extension == "json", "invalid extension for selcted object")
        XCTAssert(fileObjec?.url != nil, "invalid url for selcted object")
        XCTAssert(fileObjec?.name == "cities", "invalid name for selcted object")
        XCTAssert(fileObjec?.fileType.rawValue == "cities", "invalid name for selcted object")
        XCTAssert(fileObjec?.rawData != nil, "invalid data for selcted object")
    }

    func testDataFileObjectFailrReading() {

        let fileObjec = DataFile(.undefined)
        XCTAssert(fileObjec == nil, "invalid object for not existing file")
    }

    func testPerformanceFileReading() {
        self.measure {
            let _ = DataFile(.cities)
        }
    }
}
