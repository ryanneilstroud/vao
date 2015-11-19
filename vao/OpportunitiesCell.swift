//
//  OpportunitiesCell.swift
//  vao
//
//  Created by Ryan Neil Stroud on 11/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class OpportuntiesCell: UITableViewCell {
    
    @IBOutlet var categoriesImageView: UIImageView!
    @IBOutlet var categoriesLabel: UILabel!
    
    @IBOutlet var opportunityImageView: UIImageView!
    @IBOutlet var opportunityTitle: UILabel!
    @IBOutlet var opportunityDateAndTime: UILabel!
    @IBOutlet var opportunityLocation: UILabel!
    
    func refreshCellWithOpportunityData(title: String, dateAndTime: String, location: String, summary: String, picture: UIImage) {
        opportunityImageView.image = picture
        opportunityTitle.text = title
        
        opportunityImageView.layer.cornerRadius = 33
        opportunityImageView.clipsToBounds = true
    }
    
    func refreshCellWithCategoryData(icon: UIImage, categoryName: String) {
        categoriesImageView.image = icon
        categoriesLabel.text = categoryName
        
        categoriesImageView.layer.cornerRadius = 10
        categoriesImageView.clipsToBounds = true
    }
}