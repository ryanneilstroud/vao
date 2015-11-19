//
//  EventPhotoCell.swift
//  vao
//
//  Created by Ryan Neil Stroud on 15/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class EventPhotoCell: UITableViewCell {

    @IBOutlet var coverPhotoImageView: UIImageView!
    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var eventHostButton: UIButton!
    
    func refreshPhotoCoverWithData(image: UIImage, title: String, host: String){
        coverPhotoImageView.image = image
        eventTitleLabel.text = title
        eventHostButton.setTitle("hosted by " + host, forState: .Normal)
    }
}
