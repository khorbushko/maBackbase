//
//  SearchCachedValueTest.swift
//  maBackbaseTests
//
//  Created by Kirill Gorbushko on 2/1/19.
//  Copyright © 2019 - present. All rights reserved.
//

import XCTest

/**
 Provide unit tests, that your search algorithm is displaying the correct results giving different inputs, including invalid inputs.
 */

final class SearchCachedValueTest: XCTestCase {

    private enum Constants {

        static let expectedObjectsCount = 209557
    }

    // MARK: - Setup

    private var searchCache: SearchCachedValue?

    override func setUp() {
        super.setUp()

        let dataFile: DataFile? = DataFile(.cities)
        XCTAssertNotNil(dataFile)

        var cities: [City] = try! JSONDecoder().decode([City].self, from: dataFile!.rawData)
        XCTAssertNotNil(cities)
        XCTAssertTrue(cities.count == Constants.expectedObjectsCount, "invalid parse of objects q-ty")
        cities.sort()
        XCTAssertTrue(cities.count == Constants.expectedObjectsCount, "invalid parse of objects q-ty")

        searchCache = SearchCachedValue(cities)
        XCTAssertTrue(searchCache?.state == .pending, "invalid state for searchCache")

        XCTAssertNotNil(searchCache)
        searchCache?.compute({ _ in
            XCTAssertTrue(self.searchCache?.state == .inProgress, "invalid state for searchCache")
        }, completion: nil)
    }

    override func tearDown() {
        searchCache = nil

        super.tearDown()
    }

    func testSearchCacheState() {
        XCTAssertTrue(searchCache?.state == .ready, "invalid state for searchCache")
        XCTAssertTrue(searchCache?.allObjects.count == Constants.expectedObjectsCount, "invalid cache for objects q-ty")
    }

    func testNotExistingItemSearch() {
        let searchResultNoExist: [City] = searchCache!["Ababa"]
        XCTAssertNotNil(searchResultNoExist)
        XCTAssertTrue(searchResultNoExist.count == 0, "invalid search")

        let searchResultNoExistLowerCase: [City] = searchCache!["ababa"]
        XCTAssertNotNil(searchResultNoExistLowerCase)
        XCTAssertTrue(searchResultNoExistLowerCase.count == 0, "invalid search")
    }

    func testNotExistingItemSearchWithEmojiInput() {
        let searchResultNoExist: [City] = searchCache!["⦿⦿⦿⦿"]
        XCTAssertNotNil(searchResultNoExist)
        XCTAssertTrue(searchResultNoExist.count == 0, "invalid search")

        let searchResultNoExistLowerCase: [City] = searchCache!["⌘⌘"]
        XCTAssertNotNil(searchResultNoExistLowerCase)
        XCTAssertTrue(searchResultNoExistLowerCase.count == 0, "invalid search")
    }

    func testExistingItemSearchWithNonLatinSymbols() {
        let searchResultExist: [City] = searchCache!["Bāgmatī"]
        XCTAssertNotNil(searchResultExist)
        XCTAssertTrue(searchResultExist.count == 1, "invalid search")

        let searchResultExistlowercase: [City] = searchCache!["BāgMAtī"]
        XCTAssertNotNil(searchResultExistlowercase)
        XCTAssertTrue(searchResultExistlowercase.count == 1, "invalid search")

        let searchResultExistmixedCase: [City] = searchCache!["bāgmatī"]
        XCTAssertNotNil(searchResultExistmixedCase)
        XCTAssertTrue(searchResultExistmixedCase.count == 1, "invalid search")

        let isAllSearchCountSame = searchResultExistmixedCase.count == searchResultExistlowercase.count &&
            searchResultExistmixedCase.count == searchResultExist.count
        XCTAssertTrue(isAllSearchCountSame, "invalid search")

        let ids = [searchResultExist, searchResultExistmixedCase, searchResultExistlowercase].flatMap({ $0 }).compactMap({ $0.uniqId })
        XCTAssertTrue(ids.count == searchResultExistmixedCase.count + searchResultExistlowercase.count + searchResultExist.count, "invalid comparison transform for testing existing search")
        let set = Set(ids)
        XCTAssertTrue(set.count == 1, "invalid search result")
        XCTAssertTrue(set.first == 1283710, "invalid search result id's value")
    }

    func testExistingItemSearchWithCyrylicSymbols() {
        let searchResultExist: [City] = searchCache!["Федоровка"]
        XCTAssertNotNil(searchResultExist)
        XCTAssertTrue(searchResultExist.count == 1, "invalid search")

        let searchResultExistlowercase: [City] = searchCache!["ФЕДОРОВка"]
        XCTAssertNotNil(searchResultExistlowercase)
        XCTAssertTrue(searchResultExistlowercase.count == 1, "invalid search")

        let searchResultExistmixedCase: [City] = searchCache!["федоРОВка"]
        XCTAssertNotNil(searchResultExistmixedCase)
        XCTAssertTrue(searchResultExistmixedCase.count == 1, "invalid search")

        let isAllSearchCountSame = searchResultExistmixedCase.count == searchResultExistlowercase.count &&
            searchResultExistmixedCase.count == searchResultExist.count
        XCTAssertTrue(isAllSearchCountSame, "invalid search")

        let ids = [searchResultExist, searchResultExistmixedCase, searchResultExistlowercase].flatMap({ $0 }).compactMap({ $0.uniqId })
        XCTAssertTrue(ids.count == searchResultExistmixedCase.count + searchResultExistlowercase.count + searchResultExist.count, "invalid comparison transform for testing existing search")
        let set = Set(ids)
        XCTAssertTrue(set.count == 1, "invalid search result")
        XCTAssertTrue(set.first == 820073, "invalid search result id's value")
    }

    func testExistingItemSearch() {
        let searchResultExist: [City] = searchCache!["Habban"]
        XCTAssertNotNil(searchResultExist)
        XCTAssertTrue(searchResultExist.count == 1, "invalid search")

        let searchResultExistlowercase: [City] = searchCache!["habban"]
        XCTAssertNotNil(searchResultExistlowercase)
        XCTAssertTrue(searchResultExistlowercase.count == 1, "invalid search")

        let searchResultExistmixedCase: [City] = searchCache!["haBBaN"]
        XCTAssertNotNil(searchResultExistmixedCase)
        XCTAssertTrue(searchResultExistmixedCase.count == 1, "invalid search")

        let isAllSearchCountSame = searchResultExistmixedCase.count == searchResultExistlowercase.count &&
            searchResultExistmixedCase.count == searchResultExist.count
        XCTAssertTrue(isAllSearchCountSame, "invalid search")

        let ids = [searchResultExist, searchResultExistmixedCase, searchResultExistlowercase].flatMap({ $0 }).compactMap({ $0.uniqId })
        XCTAssertTrue(ids.count == searchResultExistmixedCase.count + searchResultExistlowercase.count + searchResultExist.count, "invalid comparison transform for testing existing search")
        let set = Set(ids)
        XCTAssertTrue(set.count == 1, "invalid search result")
        XCTAssertTrue(set.first == 75518, "invalid search result id's value")
    }

    func testExistingItemSearchAlphabetOrder() {
        let expectedObjectCount = 5

        let searchResultExist: [City] = searchCache!["Fint"]
        XCTAssertNotNil(searchResultExist)
        XCTAssertTrue(searchResultExist.count == expectedObjectCount, "invalid search")

        let searchResultExistlowercase: [City] = searchCache!["fint"]
        XCTAssertNotNil(searchResultExistlowercase)
        XCTAssertTrue(searchResultExistlowercase.count == expectedObjectCount, "invalid search")

        let searchResultExistmixedCase: [City] = searchCache!["fINT"]
        XCTAssertNotNil(searchResultExistmixedCase)
        XCTAssertTrue(searchResultExistmixedCase.count == expectedObjectCount, "invalid search")

        let isAllSearchCountSame = searchResultExistmixedCase.count == searchResultExistlowercase.count &&
            searchResultExistmixedCase.count == searchResultExist.count
        XCTAssertTrue(isAllSearchCountSame, "invalid search")

        let ids = [searchResultExist, searchResultExistmixedCase, searchResultExistlowercase].flatMap({ $0 }).compactMap({ $0.uniqId })
        XCTAssertTrue(ids.count == searchResultExistmixedCase.count + searchResultExistlowercase.count + searchResultExist.count, "invalid comparison transform for testing existing search")
        let set = Set(ids)
        XCTAssertTrue(set.count == expectedObjectCount, "invalid search result")

        func checkOrder(_ searchResultArray: [City]) {
            let item0 = searchResultArray[0]
            let item1 = searchResultArray[1]
            let item2 = searchResultArray[2]
            let item3 = searchResultArray[3]
            let item4 = searchResultArray[4]

            XCTAssertTrue(item0.name == "finta mare", "invalid order in searched results")
            XCTAssertTrue(item1.name == "fintel", "invalid order in searched results")
            XCTAssertTrue(item2.name == "fintel", "invalid order in searched results")
            XCTAssertTrue(item3.name == "fintona", "invalid order in searched results")
            XCTAssertTrue(item4.name == "fintown", "invalid order in searched results")

            XCTAssertTrue(item0.country == "ro", "invalid order in searched results")
            XCTAssertTrue(item1.country == "de", "invalid order in searched results")
            XCTAssertTrue(item2.country == "de", "invalid order in searched results")
            XCTAssertTrue(item3.country == "gb", "invalid order in searched results")
            XCTAssertTrue(item4.country == "ie", "invalid order in searched results")
        }

        checkOrder(searchResultExist)
        checkOrder(searchResultExistlowercase)
        checkOrder(searchResultExistmixedCase)
    }
}
