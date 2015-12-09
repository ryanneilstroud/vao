//
//  EventClass.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 25/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse
import MapKit

class EventClass {

    var title: String?
    var date: NSDate?
    var time: NSDate?
    var frequency: String?
    var summary: String?
    var eventImage: UIImage?
    var location: CLLocationCoordinate2D?
    var locationName: String?
    
    var createdBy: PFUser!
    
    func setTitle(_title: String){
        title = _title
    }
    
    func setDate(_date: NSDate){
        date = _date
    }
    
    func setTime(_time: NSDate){
        time = _time
    }
    
    func setFrequency(_frequency: String){
        frequency = _frequency
    }
    
    func setEventImage(_image: UIImage) {
        eventImage = _image
    }
    
    func setSummary(_summary: String) {
        summary = _summary
    }
}
