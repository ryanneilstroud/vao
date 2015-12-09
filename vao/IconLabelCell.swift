//
//  IconLabelCell.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 18/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class IconLabelCell: UITableViewCell {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var iconLabel: UILabel!
    
    func refreshCellWithData(icon: UIImage, text: String) {
        iconImageView.image = icon
    
        if text == "don't repeat" {
            iconLabel.text = "doesn't repeat"
        } else {
            iconLabel.text = text
        }
    }
}
