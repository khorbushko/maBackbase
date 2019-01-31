//
//  ListViewController.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {

    @IBOutlet weak var loadingContentView: UIView!
    @IBOutlet weak var loadingContentInfoLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private var dataProvider: ListViewControllerDataProvider! {
        didSet {
            dataProvider.delegate = self
        }
    }

    // MARK: - NavigationBar

    private var navigationBarSearchBar: UISearchBar = UISearchBar()
    private var viewForNavigationBar:UIView?
    private var closeButton:UIButton?

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotificaitions()
        setupAppearence()
        setupInactiveBar()
        setupNavigationBar()
        setupSearchDelegate()
        localizeUI()

        fetchInitialData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.applyDefaultStyle()
    }

    deinit {
        unregisterNotifications()
    }

    // MARK: - IBAction

    @objc private func addSearchBar() {
        navigationItem.setRightBarButton(nil, animated:true)
        title = nil
        presentSearchBarIfPossible()
    }

    @objc private func closeButtonAction(_ sender: AnyObject) {
        guard let viewForNavigationBar = viewForNavigationBar else {
            return
        }
        navigationBarSearchBar.text = nil
        setupInactiveBar()

        UIView.transition(with: viewForNavigationBar, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut],
                          animations: { [weak self] in
                            self?.viewForNavigationBar?.removeFromSuperview()
            }, completion: nil)
    }

    // MARK: - Private

    private func localizeUI() {
        loadingContentInfoLabel.text = NSLocalizedString("listViewContoroller.loading.info", comment: "")
    }

    private func hideInfoView(_ hide: Bool) {
        Animator.fadeView(loadingContentView, isFade: hide)
    }

    private func setupAppearence() {
        tableView.tableFooterView = UIView()

        setupAppearenceForSearchBar()
    }

    private func setupAppearenceForSearchBar() {
        navigationBarSearchBar.setBackgroundImage(nil, for: .any, barMetrics: .default)
        navigationBarSearchBar.tintColor = UIColor.white

        let textFieldInsideUISearchBar = navigationBarSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.white
        textFieldInsideUISearchBar?.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        let textFieldPlaceholder = NSLocalizedString("listViewController.searchView.placeholder", comment: "")
        textFieldInsideUISearchBar?.attributedPlaceholder = NSAttributedString(string: textFieldPlaceholder, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)
            ])

        let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideUISearchBarLabel?.textColor = UIColor.lightGray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).clearButtonMode = .never
    }

    private func setupInactiveBar() {
        title = NSLocalizedString("listViewController.title", comment: "")
        let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self,
                                          action: #selector(ListViewController.addSearchBar))
        navigationItem.setRightBarButton(rightButton, animated: true)
    }

    private func setupNavigationBar() {
        if var frameForNavBar = navigationController?.navigationBar.frame {
            frameForNavBar = CGRect(x:0, y:0, width: frameForNavBar.width, height: frameForNavBar.height)
            let closeButton = UIButton(type: .system)
            closeButton.addTarget(self, action: #selector(ListViewController.closeButtonAction(_:)), for: .touchUpInside)
            closeButton.setTitle(NSLocalizedString("listViewContoroller.searchView.cancelButton.title", comment: ""), for: .normal)
            closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            closeButton.tintColor = UIColor.white

            self.closeButton = closeButton
            let viewForNavigationBar = UIView(frame: frameForNavBar)
            navigationBarSearchBar.delegate = self

            let views: [String: UIView] = [
                "searchBar" : navigationBarSearchBar,
                "closeButton" : closeButton
            ]

            navigationBarSearchBar.translatesAutoresizingMaskIntoConstraints = false
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            viewForNavigationBar.addSubview(navigationBarSearchBar)
            viewForNavigationBar.addSubview(closeButton)

            let metrics: [String: Any] = [
                "offset" : 8,
                "buttonWidth" : 70
            ]

            let constrainsVerticalPositionForSearchBar = NSLayoutConstraint
                .constraints(withVisualFormat: "V:|-offset-[searchBar]-offset-|",
                             options: .alignAllCenterY, metrics: metrics, views: views)
            let constrainsVerticalPositionForCloseButton = NSLayoutConstraint
                .constraints(withVisualFormat: "V:|-offset-[closeButton]-offset-|",
                             options: .alignAllCenterY, metrics: metrics, views: views)
            let constrainsHorizontalPosition = NSLayoutConstraint
                .constraints(withVisualFormat: "H:|-offset-[searchBar]-offset-[closeButton(buttonWidth)]-offset-|",
                             options: [], metrics: metrics, views: views)
            NSLayoutConstraint.activate([
                constrainsVerticalPositionForSearchBar,
                constrainsVerticalPositionForCloseButton,
                constrainsHorizontalPosition]
                .flatMap({$0}))

            UIView.performWithoutAnimation { [weak self] in
                self?.navigationController?.navigationBar.layoutIfNeeded()
            }
            self.viewForNavigationBar = viewForNavigationBar
        }
    }

    private func presentSearchBarIfPossible() {
        if let viewForNavigationBar = viewForNavigationBar {
            navigationBarSearchBar.becomeFirstResponder()
            UIView.transition(with: viewForNavigationBar, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut],
                              animations: { [weak self] in
                                self?.navigationController?.navigationBar.addSubview(viewForNavigationBar)
                }, completion: nil)
        }
    }

    private func setupSearchDelegate() {
        navigationBarSearchBar.delegate = self
    }

    // MARK: - Data

    private func fetchInitialData() {
        dataProvider.loadData { [weak self] (completed) in
            self?.hideInfoView(completed)

            if !completed {
                self?.loadingContentInfoLabel.text = NSLocalizedString("listViewContoroller.loading.info.failure", comment: "")
                self?.view.layoutIfNeeded()
            }
        }
    }

    // MARK: - Notifications

    private func registerNotificaitions() {
        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController.keyboardWillAppear(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController.keyboardWillDisappear),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillAppear(_ notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    @objc private func keyboardWillDisappear() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.contentInset = UIEdgeInsets.zero
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension ListViewController: UISearchBarDelegate {
    // MARK: - UISearchBarDelegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // todo
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        closeButtonAction(searchBar)
    }
}

extension ListViewController: ListViewControllerDataProviderDelegate {
    
    // MARK: - ListViewControllerDataProviderDelegate

    func didSelecteItem(_ city: City) {
        // todo
    }
}
