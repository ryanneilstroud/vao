//
//  RateCell.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 19/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell {
    
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var firstStar: UIButton!
    @IBOutlet var secondStar: UIButton!
    @IBOutlet var thirdStar: UIButton!
    @IBOutlet var fourthStar: UIButton!
    @IBOutlet var fifthStar: UIButton!
    
    func manageTextView() {
        commentTextView.layer.borderColor = UIColor.grayColor().CGColor
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.cornerRadius = 5
    }
    
    func manageButton() {
        submitButton.layer.cornerRadius = 5
    }
}
