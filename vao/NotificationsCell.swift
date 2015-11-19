//
//  NotificationsCell.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 18/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {

    @IBOutlet var notificationText: UITextView!
    @IBOutlet var profilePicture: UIImageView!
    
    func refreshNotificationsCellWithData(image: UIImage, text: String) {
        notificationText.text = text
        profilePicture.image = image

        profilePicture.clipsToBounds = true

        profilePicture.layer.cornerRadius = 27
        profilePicture.layer.borderColor = UIColor.grayColor().CGColor
        profilePicture.layer.borderWidth = 0.5
    }
}
