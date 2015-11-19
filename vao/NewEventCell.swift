//
//  NewEventCell.swift
//  vao
//
//  Created by Ryan Neil Stroud on 15/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import MapKit

class NewEventCell: UITableViewCell {

    @IBOutlet var pickerLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var mapView: MKMapView!
    
    @IBAction func pickStartDate(sender: AnyObject) {
    }

    func refreshCellWithTitle() {
    
    }
    
    func refreshCellWithButtonLabel(_label: String, _icon: UIImage) {
        NSLog("%@", _label);
        pickerLabel.text = _label
        iconImageView.image = _icon
    }

}
