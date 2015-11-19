//
//  ProfileCells.swift
//  vao
//
//  Created by Ryan Neil Stroud on 11/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class AttributeValueCells: UITableViewCell {
    
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var projectCount: UILabel!
    @IBOutlet var eventCount: UILabel!
    @IBOutlet var ratingScore: UILabel!
    
    @IBOutlet var projectsButton: UIButton!
    @IBOutlet var eventsButton: UIButton!
    @IBOutlet var ratingsButton: UIButton!
    
    @IBOutlet var labelAttribute: UILabel!
    @IBOutlet var labelValue: UILabel!
    
    func refreshProfileSummaryCellWithData(userProfilePic: UIImage, userProjectCount: Int, userEventCount: Int, userRating: Double) {        
        profilePic.image = userProfilePic
        projectCount.text = String(userProjectCount)
        eventCount.text = String(userEventCount)
        ratingScore.text = String(userRating)
        
        profilePic.layer.cornerRadius = 40;
        profilePic.clipsToBounds = true;
    }
    
    func refreshProfileAboutCellWithData(attributeName: String, attributeValue: String) {
        labelAttribute.text = attributeName
        labelValue.text = attributeValue
    }
}