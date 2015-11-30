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
    }
}
