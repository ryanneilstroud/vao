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
    
    let SELECTED_STAR = "ion-ios-star_100_0_e4e400_none.png"
    
    func manageTextView(_text: String?) {
        commentTextView.layer.borderColor = UIColor.grayColor().CGColor
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.cornerRadius = 5
        
        if _text != "" {
            commentTextView.text = _text
        }
    }
    
    func manageButton() {
        submitButton.layer.cornerRadius = 5
    }
    
    func manageRating(_score: Int) {
        
        let array = [firstStar, secondStar, thirdStar, fourthStar, fifthStar]
        
        for index in 0..._score - 1 {
            array[index].setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
        }
    }
}
