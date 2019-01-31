//
//  UINavigationItem+BackButton.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

extension UINavigationItem {

    // MARK: - UINavigationItem+BackButton

    fileprivate enum ImageName {

        static let BackIndicatorName = "icBack"
    }

    @discardableResult func addBackButton(_ selector: Selector, target: UIViewController, tintColor: UIColor = UIColor.white) -> Bool {
        if let backImage = UIImage(named: ImageName.BackIndicatorName)?.withRenderingMode(.alwaysTemplate) {
            let backButton = UIBarButtonItem(image: backImage, style: .done, target: target, action: selector)
            backButton.tintColor = tintColor
            backButton.imageInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
            hidesBackButton = true
            leftBarButtonItem = backButton
            return true
        }
        return false
    }
}
