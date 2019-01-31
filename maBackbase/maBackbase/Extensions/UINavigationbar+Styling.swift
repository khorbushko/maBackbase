//
//  UINavigationbar+Styling.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

extension UINavigationBar {

    // MARK: - UINavigationBar + Styling

    func applyDefaultStyle() {
        setBackgroundImage(nil, for: .default)
        barTintColor =  UIColor.black
        tintColor = UIColor.white
        isTranslucent = false
        titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,
                               NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)
        ]
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.clear.cgColor
        shadowImage = UIImage()
    }
}
