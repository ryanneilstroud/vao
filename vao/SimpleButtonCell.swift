//
//  SimpleButtonCell.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 19/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class SimpleButtonCell: UITableViewCell {
    
    @IBOutlet var basicButton: UIButton!
    @IBAction func handleButtonClick(sender: AnyObject) {
    }
    
    func refreshCellWithButtonData(buttonText: String) {        
        basicButton.setTitle(buttonText, forState: .Normal)
    }
}
