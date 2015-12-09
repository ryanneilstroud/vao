//
//  OpportunitiesCell.swift
//  vao
//
//  Created by Ryan Neil Stroud on 11/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class OpportuntiesCell: UITableViewCell {
    
    @IBOutlet var categoriesImageView: UIImageView!
    @IBOutlet var categoriesLabel: UILabel!
    
    @IBOutlet var opportunityImageView: UIImageView!
    @IBOutlet var opportunityTitle: UILabel!
    @IBOutlet var opportunityDateAndTime: UILabel!
    @IBOutlet var opportunityLocation: UILabel!
    @IBOutlet var opportunitySummary: UITextView!
    
    func refreshCellWithOpportunityData(title: String, date: NSDate, time: NSDate, frequency: String, location: String, summary: String, picture: UIImage) {
//        opportunityImageView.image = picture
        opportunityTitle.text = title
        opportunityImageView.image = picture
        opportunitySummary.text = summary
        opportunityLocation.text = location
        
        opportunityImageView.layer.cornerRadius = 33
        opportunityImageView.clipsToBounds = true
        
        if frequency == "don't repeat" {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            
            let dateString = formatter.stringFromDate(date)
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
            let timeString = timeFormatter.stringFromDate(time)
            
            opportunityDateAndTime.text = timeString + " on " + dateString
        } else {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            
            let dateString = formatter.stringFromDate(date)
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
            let timeString = timeFormatter.stringFromDate(time)
            
            opportunityDateAndTime.text = frequency + " on " + dateString + " at " + timeString

        }
    }
    
    func refreshCellWithCategoryData(icon: UIImage, categoryName: String) {
        categoriesImageView.image = icon
        categoriesLabel.text = categoryName
        
        categoriesImageView.layer.cornerRadius = 10
        categoriesImageView.clipsToBounds = true
    }
    
    func refreshCellWithObject(object: PFObject) {
        opportunityTitle.text = object["title"] as? String
//        opportunityImageView.image = picture
        opportunitySummary.text = object["summary"] as! String
        
        opportunityImageView.layer.cornerRadius = 33
        opportunityImageView.clipsToBounds = true
        
        if object["frequency"] as! String != "don't repeat" {
            let formatter = NSDateFormatter()
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
            let dateString = formatter.stringFromDate(object["time"] as! NSDate)
            
            opportunityDateAndTime.text = object["frequency"] as! String + " at " + dateString
        }
    }
}