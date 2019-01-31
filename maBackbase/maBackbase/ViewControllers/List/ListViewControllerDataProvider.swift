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
}

final class ListViewControllerDataProvider: TableViewDataProvider {

    weak var delegate: ListViewControllerDataProviderDelegate?

    override internal var buildItemTypes: [TableViewCollectionBuildItem.Type] {
        get {
            return [
                CityTableViewCellBuildItem.self
            ]
        }
    }

    private var cities: [City] = []

    // MARK: - Public

    func loadData(_ completion: ((Bool) -> ())?) {
        DispatchQueue.global().async { [weak self] in
            if let dataFile = DataFile(.cities) {
                do  {
                    var cities: [City] = try JSONDecoder().decode([City].self, from: dataFile.rawData)
                    cities.sort()

                    DispatchQueue.main.async {
                        self?.populateInitialData(cities)
                        completion?(true)
                    }

                } catch {
                    DispatchQueue.main.async {
                        completion?(false)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion?(false)
                }
            }
        }
    }

    private func populateInitialData(_ cities: [City]) {
        self.cities = cities

        let section = CityTableViewSectionItem(cities)
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
