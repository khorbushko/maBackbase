//
//  UITableView+Reload.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

extension TableViewDataProvider {

    // MARK: - UITableView+Reload

    func animatedTableViewReload() {
        tableView.reloadData()

        let visibleCell = tableView.visibleCells

        visibleCell.forEach({ (cell) in
            if let indexPath = tableView.indexPath(for: cell) {
                let currentItem = items[indexPath.section][indexPath.row]
                let height = currentItem.expectedHeight()

                cell.transform = CGAffineTransform(translationX: 0, y: height / 2)
                cell.alpha = 0
            }
        })

        visibleCell.forEach({ (cell) in
            if let indexPath = tableView.indexPath(for: cell) {

                let cell = tableView.cellForRow(at: indexPath)

                UIView.animate(withDuration: 0.3, delay: 0.03 * Double(indexPath.row), options: [.curveEaseInOut], animations: {
                    cell?.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell?.alpha = 1
                }, completion: nil)
            }
        })
    }
}
