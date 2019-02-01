//
//  SearchValue.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import Foundation

enum SearchCachedValueState {

    case pending
    case inProgress
    case ready
}

/**
 SearchCachedValue - class that chached all search results possible

 Memoty optimization required
 Used only for demo
 */
final class SearchCachedValue {

    subscript (_ serachableValue: String) -> [City] {
        get {
            let serachKey = serachableValue.lowercased()
            let objectToReturn: [City] = searchableCache[serachKey] ?? []
            return objectToReturn
        }
    }

    var allObjects: [City] {
        get {
            return cities
        }
    }

    private (set) var state: SearchCachedValueState = .pending

    private var searchableCache: [String: [City]] = [: ]

    private let accessQueue = DispatchQueue(label: "com.accessWriteQueue")
    private var cities: [City] = []

    private var expectedRequests: Int = 0
    private var capturedCompletion: Int = -1

    private var progress: ((Float) -> ())?

    // MARK: - LifeCycle

    init(_ cities: [City]) {

        self.cities = cities
    }

    // MARK: - Public

    func compute(_ progress: ((Float) -> ())?, completion: (() -> ())?) {
        state = .inProgress
        self.progress = progress

        processData()

        let uniqueInitialIds = Set(cities
            .map({ $0.uniqId })
        )

        let indexedIds = Set(searchableCache.values
            .flatMap({ $0 })
            .map({ $0.uniqId })
        )

        assert(uniqueInitialIds.count == indexedIds.count, "invalid query preparation process")
        assert(indexedIds.count == cities.count, "invalid query preparation process")

        completion?()
        state = .ready

        cleanUp()
    }

    // MARK: - Private

    private func captureRequestCompletion() {
        accessQueue.sync {
            capturedCompletion += 1

            if capturedCompletion > expectedRequests {
                assertionFailure("invalid progress computation")
            }

            let progress: Float = Float(capturedCompletion) / Float(expectedRequests)
            self.progress?(progress)
        }
    }

    private func cleanUp() {
        progress = nil
        expectedRequests = 0
        capturedCompletion = -1
    }

    // MARK: - Cache

    private func processData() {
        let firchCharSet: Set<String> = Set(cities.compactMap({ $0.name.first }).map({ String($0) }))
        expectedRequests = firchCharSet.count

        let ordered = Array(firchCharSet)
        DispatchQueue.concurrentPerform(iterations: firchCharSet.count) { [weak self] (itemIndex) in
            if ordered.count < itemIndex {
                assertionFailure("fail :( - invalid bounds request for array during chaching")
            } else {
                let currentSearchKey = ordered[itemIndex]
                self?.analyzeValuesBy(currentSearchKey, cities: cities)
                self?.captureRequestCompletion()
            }
        }
    }

    private func analyzeValuesBy(_ searchValue: String, cities: [City]) {
        let affectedItems = cities.filter({ $0.name.hasPrefix(searchValue) })
        accessQueue.sync {
            searchableCache[searchValue] = affectedItems
        }

        let maxNameLengthInCategory = affectedItems.max(by: { $0.name.count < $1.name.count })?.name.count ?? 0

        let sartInspectIndex = searchValue.count + 1
        if maxNameLengthInCategory >= searchValue.count + 1 {
            let affectedBySearchLengthItems: [City] = affectedItems.filter({ $0.name.count >= sartInspectIndex })

            let currentInspectedRange = Range(uncheckedBounds: (lower: 0, upper: sartInspectIndex))
            let currentLengthPossibleSet: Set<String> = Set(affectedBySearchLengthItems
                .compactMap({ $0.name[currentInspectedRange] })
                .map({ String($0) })
            )

            currentLengthPossibleSet.forEach { (value) in
                analyzeValuesBy(value, cities: affectedBySearchLengthItems)
            }
        }
    }
}
