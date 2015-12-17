//
//  RatedCell.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 19/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class RatedCell: UITableViewCell {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var ratedForLabel: UILabel!
    @IBOutlet var byOrgLabel: UILabel!

    @IBOutlet var starOne: UIImageView!
    @IBOutlet var starTwo: UIImageView!
    @IBOutlet var starThree: UIImageView!
    @IBOutlet var starFour: UIImageView!
    @IBOutlet var starFive: UIImageView!
    
    func refreshCellWithObject(_review: PFObject) {
        
        let event = _review["event"] as! PFObject
        ratedForLabel.text = "Rated for " + String(event["title"])
        
        let org = _review["organization"] as! PFUser
        byOrgLabel.text = "By " + String(org["fullName"])
        
        if let userImageFile = event["eventImage"] as? PFFile {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.profileImage.image = UIImage(data:imageData)!
                    }
                }
            }
        } else {
            profileImage.image = UIImage(named: "pe-7s-user_256_0_606060_none.png")!
        }
        
        let array = [starOne, starTwo, starThree, starFour, starFive]
        let rating = _review["rating"] as! Int
        
        for index in 0...rating - 1 {
            array[index].image = UIImage(named: "ion-ios-star_100_0_e4e400_none.png")
        }

    }
}
