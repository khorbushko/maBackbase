//
//  UIViewController+MultiLineTitle.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

extension UIViewController {

    // MARK: - UIViewController+MultiLineTitle

    func configureMultiLineTitle(_ headerText: String, subHeaderText: String) {
        let titleParameters = [NSAttributedString.Key.foregroundColor: UIColor.white,
                               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        let subtitleParameters = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]

        let title: NSMutableAttributedString = NSMutableAttributedString(string: headerText, attributes: titleParameters)
        let subtitle: NSAttributedString = NSAttributedString(string: subHeaderText, attributes: subtitleParameters)

        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)

        let size = title.size()

        let width = size.width
        guard let height = navigationController?.navigationBar.frame.size.height else { return }

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        navigationItem.titleView = titleLabel

        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.3
        fadeTextAnimation.type = CATransitionType.fade
        fadeTextAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

        navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: nil)
    }
}
