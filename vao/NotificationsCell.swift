//
//  NotificationsCell.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 18/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class NotificationsCell: UITableViewCell {

    @IBOutlet var notificationText: UITextView!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    
    func refreshNotificationsCellWithData(_file: PFFile?, _text: String) {
    
        notificationText.text = _text
        
        if let userImageFile = _file {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        print("hello")
                        self.profilePicture.image = UIImage(data:imageData)
                        
                    }
                }
            }
        }
        
        profilePicture.clipsToBounds = true

        profilePicture.layer.cornerRadius = 27
        profilePicture.layer.borderColor = UIColor.grayColor().CGColor
        profilePicture.layer.borderWidth = 0.5
    }
}
