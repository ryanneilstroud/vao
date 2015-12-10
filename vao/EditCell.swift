//
//  EditCell.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 26/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class EditCell: UITableViewCell {

    @IBOutlet var editTextField: UITextField!
    @IBOutlet var label: UILabel!
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var editIconTextField: UITextField!
    
    func refreshCellWithLabel(_label: String, _labelValues: String, _placeholder: String) {
        label.text = _label
        editTextField.placeholder = _placeholder
        editTextField.text = _labelValues
        
        if _placeholder == "22" {
            editTextField.keyboardType = UIKeyboardType.NumberPad
        }
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    func refreshCellWithIcon(_icon: UIImage, _keyboardType: UIKeyboardType, _placeHolder: String) {
        iconImageView.image = _icon
        editIconTextField.placeholder = _placeHolder
        editIconTextField.keyboardType = _keyboardType
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    func refreshCellWithIcon(_icon: UIImage, _keyboardType: UIKeyboardType, _text: String, _placeHolder: String) {
        iconImageView.image = _icon
        editIconTextField.placeholder = _placeHolder
        editIconTextField.text = _text
        editIconTextField.keyboardType = _keyboardType
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    func refreshCellWithSecureDataOptions(_icon: UIImage, _secureTextEntry: Bool, _placeHolder:String) {
        iconImageView.image = _icon
        editIconTextField.secureTextEntry = _secureTextEntry
        editIconTextField.placeholder = _placeHolder
    }
}
