//
//  LabelTextview.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 19/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class GenericLabelTextviewCell: UITableViewCell {
    
    @IBOutlet var textview: UITextView!
    
    func refreshCellWithTextviewText(multiLineText: String) {
        textview.text = multiLineText
    }
    
    func refreshCellWithEmptyCell() {
        textview.editable = true
    }
}
