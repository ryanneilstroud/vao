//
//  VolunteersTVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 17/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class VolunteersTVC: UITableViewCell {

    @IBOutlet var volunteerProfilePictureImageView: UIImageView!
    @IBOutlet var volunteerFullName: UILabel!
    @IBOutlet var volunteerAboutDetails: UILabel!
    @IBOutlet var volunteerVaoHistory: UILabel!
    
    func refreshCellWithVolunteerData(_profileImage: UIImage, _fullName: String) {
    
        volunteerProfilePictureImageView.image = _profileImage
        volunteerProfilePictureImageView.layer.cornerRadius = 35
        volunteerProfilePictureImageView.clipsToBounds = true
        
        volunteerFullName.text = _fullName
        
    }
    
    func refreshCellWithVolunteer(_volunteer: PFObject) {
        
        let userImageFile = _volunteer["orgImage"] as! PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    self.volunteerProfilePictureImageView.image = UIImage(data:imageData)
                }
            }
        }
        
        volunteerProfilePictureImageView.layer.cornerRadius = 35
        volunteerProfilePictureImageView.clipsToBounds = true
        
        volunteerFullName.text = _volunteer["fullName"] as? String
        
        var aboutVolunteerArray = [String]()
        
        if _volunteer["age"] != nil {
            print("true")
        } else {
            print("false")
        }
        
        if _volunteer["age"] != nil && aboutVolunteerArray.count < 3 {
            if _volunteer["age"] as! String != "" {
                aboutVolunteerArray.append(_volunteer["age"] as! String + " years old")
            }
        }
        
        if _volunteer["gender"] != nil && aboutVolunteerArray.count < 3 {
            if _volunteer["gender"] as! String != "" {
                aboutVolunteerArray.append(_volunteer["gender"] as! String)
            }
        }
        
        if _volunteer["religion"] != nil && aboutVolunteerArray.count < 3 {
            if _volunteer["religion"] as! String != "" {
                aboutVolunteerArray.append(_volunteer["religion"] as! String)
            }
        }
        
        if _volunteer["languages"] != nil && aboutVolunteerArray.count < 3 {
            if _volunteer["languages"] as! String != "" {
                aboutVolunteerArray.append(_volunteer["languages"] as! String)
            }
        }

        if aboutVolunteerArray.count == 1 {
            volunteerAboutDetails.text = aboutVolunteerArray[0]
        } else if aboutVolunteerArray.count == 2 {
            volunteerAboutDetails.text = aboutVolunteerArray[0] + " || " + aboutVolunteerArray[1]
        } else if aboutVolunteerArray.count == 3 {
            volunteerAboutDetails.text = aboutVolunteerArray[0] + " || " + aboutVolunteerArray[1] + " || " + aboutVolunteerArray[2]
        }
    }
}
