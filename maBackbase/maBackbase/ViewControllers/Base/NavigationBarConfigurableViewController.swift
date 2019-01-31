//
//  NavigationBarConfigurableViewController.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

class NavigationBarConfigurableViewController: UIViewController {

    // MARK: - LifeCYcle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackButton()
    }

    // MARK: - IBActions

    @objc internal func backAction() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Private

    internal func configureBackButton() {
        navigationItem.addBackButton(#selector(NavigationBarConfigurableViewController.backAction), target: self, tintColor: .white)
    }
}
