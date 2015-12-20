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
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var facebookName: UILabel!
    
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
        
        if let userImageFile = object["eventImage"] as? PFFile {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.opportunityImageView.image = UIImage(data:imageData)!
                    }
                }
            }
        } else {
            opportunityImageView.image = UIImage(named: "pe-7s-user_256_0_606060_none.png")!
        }

        
        opportunitySummary.text = object["summary"] as! String
        
        opportunityImageView.layer.cornerRadius = 33
        opportunityImageView.clipsToBounds = true
        
        opportunityLocation.text = object["locationName"] as? String
        
        if object["frequency"] as! String != "don't repeat" {
            let formatter = NSDateFormatter()
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
            let dateString = formatter.stringFromDate(object["time"] as! NSDate)
            
            opportunityDateAndTime.text = object["frequency"] as! String + " at " + dateString
        } else {
            let formatter = NSDateFormatter()
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            
            let timeString = formatter.stringFromDate(object["time"] as! NSDate)
            let dateString = dateFormatter.stringFromDate(object["date"] as! NSDate)
            
            opportunityDateAndTime.text = timeString + " on " + dateString
        }
    }
    
    func refreshFacebookFriendCell(_dictionary: NSDictionary) {
        facebookName.text = _dictionary.objectForKey("name") as? String
        let picture = _dictionary.objectForKey("picture")?.objectForKey("data")?.objectForKey("url")
        print(picture)
        
        let url = NSURL(string: picture as! String)
        let data = NSData(contentsOfURL: url!)
        profilePicture.image = UIImage(data: data!)

    }
}