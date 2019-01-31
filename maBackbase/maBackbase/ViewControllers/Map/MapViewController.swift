//
//  MapViewController.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: NavigationBarConfigurableViewController {

    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }

    private (set) var dataProvider: MapViewControllerDataProvider?

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        localizeUI()
        displaySelectedCity()
    }

    // MARK: - Private

    private func localizeUI() {
        if let dataProvider = dataProvider {
            configureMultiLineTitle(dataProvider.mainTitle, subHeaderText: dataProvider.subTitle)
        } else {
            assertionFailure("data provider nil for selected city")
        }
    }

    // MARK: - MapConfiguration

    private func displaySelectedCity() {

        guard let dataProvider = dataProvider else {
            assertionFailure("data provider nil for selected city - map config")
            return
        }

        let region = dataProvider.cityRegion()
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(dataProvider.annotation())
    }
}

extension MapViewController: MKMapViewDelegate {

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CityCenterPointAnnotation else {
            return nil
        }

        let identifier = CityCenterPointAnnotation.identifier
        var view: MKAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = nil
            view.image = annotation.image
        }
        return view
    }
}

extension MapViewController {

    // MARK: - MapViewController+Create

    class func create(_ city: City) -> MapViewController {
        let dataProvider = MapViewControllerDataProvider(city: city)

        if let controller = Storyboard.main.board?
                .instantiateViewController(withIdentifier: String(describing: MapViewController.self)) as? MapViewController {
            controller.dataProvider = dataProvider
            return controller
        }

        assertionFailure("can't create MapViewController")
        fatalError("can't create MapViewController")
    }
}
