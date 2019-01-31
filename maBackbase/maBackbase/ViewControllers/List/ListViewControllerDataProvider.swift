//
//  ListViewControllerDataProvider.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

protocol ListViewControllerDataProviderDelegate: class {

    func didSelecteItem(_ city: City)
    func didLoadDataProgress(_ progress: Float)
}

final class ListViewControllerDataProvider: TableViewDataProvider {

    weak var delegate: ListViewControllerDataProviderDelegate?

    override internal var buildItemTypes: [TableViewCollectionBuildItem.Type] {
        get {
            return [
                CityTableViewCellBuildItem.self,
                NoResultFoundTableViewCellBuildItem.self
            ]
        }
    }

    private var searchCache: SearchCachedValue?

    private (set) var currentSearchValue: String?

    var isSearchActive: Bool {
        get {
            return currentSearchValue != nil
        }
    }

    var isDataAvailable: Bool {
        get {
            return searchCache?.state == .ready
        }
    }

    // MARK: - Public

    func loadData(_ completion: ((Bool) -> ())?) {

        let notifyFailure: (() -> ()) = {
            DispatchQueue.main.async {
                completion?(false)
            }
        }

        delegate?.didLoadDataProgress(0.01)

        DispatchQueue.global().async { [weak self] in
            if let dataFile = DataFile(.cities) {
                do {
                    self?.delegate?.didLoadDataProgress(0.02)

                    var cities: [City] = try JSONDecoder().decode([City].self, from: dataFile.rawData)
                    cities.sort()

                    self?.delegate?.didLoadDataProgress(0.03)

                    self?.searchCache = SearchCachedValue(cities)
                    self?.searchCache?.compute({ (progress) in
                        self?.delegate?.didLoadDataProgress(progress / 1.05)
                    }, completion: {
                        DispatchQueue.main.async {
                            if let all = self?.searchCache?.allObjects {
                                self?.populateInitialData(all)
                                completion?(true)
                            } else {
                                notifyFailure()
                            }
                        }
                    })
                } catch {
                    notifyFailure()
                }
            } else {
                notifyFailure()
            }
        }
    }

    // MARK: - Search

    func searchValue(_ string: String) {
        currentSearchValue = string

        if string.isEmpty {
            displayAllData()
        } else {
            let searchResult: [City] = searchCache?[string] ?? []
            populateInitialData(searchResult)
        }
    }

    func displayAllData() {
        currentSearchValue = nil

        let all: [City] = searchCache?.allObjects ?? []
        populateInitialData(all)
    }

    // MARK: - Private

    private func populateInitialData(_ cities: [City]) {

        let isEmptyUpdate = cities.isEmpty && !items[0].items.filter({ $0 is NoResultFoundTableViewCellBuildItem }).isEmpty

        if isEmptyUpdate {
            return
        }

        let section = CityTableViewSectionItem(cities)
        items.removeAll()
        items.append(section)
        animatedTableViewReload()
    }
}

extension ListViewControllerDataProvider: UITableViewDataSource {

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItemsCount = items[section].itemsInSection
        return sectionItemsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = items[indexPath.section][indexPath.row]
        let cell = currentItem.dequeueCell(tableView, at: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentItem = items[indexPath.section][indexPath.row]
        let height = currentItem.expectedHeight()
        return height
    }
}

extension ListViewControllerDataProvider: UITableViewDelegate {

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let section = items[indexPath.section]
        let item = section[indexPath.row] as? CityTableViewCellBuildItem

        if let city = item?.city {
            delegate?.didSelecteItem(city)
        }
    }
}
