//
//  VolunteersTVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 17/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

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
}
