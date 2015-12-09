//
//  MapViewCell.swift
//  vao
//
//  Created by Ryan Neil Stroud on 11/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import MapKit

class MapViewCell: UITableViewCell {
    @IBOutlet var mapView: MKMapView!

    func refreshCellWithMapData(_location: CLLocationCoordinate2D) {
        
        let location = CLLocationCoordinate2D(
            latitude: _location.latitude,
            longitude: _location.longitude
        )
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
//        annotation.title = "Big Ben"
//        annotation.subtitle = "London"
        mapView.addAnnotation(annotation)

    }

}