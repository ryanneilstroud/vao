//
//  EditProfileVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 17/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class EditProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var tableview: UITableView?
    
    var currentUser = PFUser.currentUser()
    var imagePicker : UIImagePickerController!
    var orgImage: UIImage?
    
    var name = ""
    
    let about = ["location", "gender", "age", "religion", "languages"]
    let icons = [UIImage(named: "ion-ios-telephone-outline_256_0_c3c3c3_none.png"), UIImage(named: "ion-ios-email-outline_256_0_c3c3c3_none.png")]
    var iconTextFieldText = ["",""]
    let placeholders = ["phone number","email"]
    let keyboardType = [UIKeyboardType.PhonePad, UIKeyboardType.EmailAddress, UIKeyboardType.URL]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return about.count
        } else {
            return icons.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("hello!")
        
        tableview = tableView
        
        if indexPath.section == 0 {
            let nib = UINib(nibName: "TextFieldCell", bundle: nil)
            
            tableView.registerNib(nib, forCellReuseIdentifier: "textfieldCell")
            tableView.rowHeight = 100
            
            let cell : NewEventCell = tableView.dequeueReusableCellWithIdentifier("textfieldCell", forIndexPath: indexPath) as! NewEventCell
            cell.eventImageButton.addTarget(self, action: "getPicture", forControlEvents: .TouchUpInside)
            cell.titleTextField.delegate = self
            cell.titleTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            
            if orgImage != nil {
                print("not nil ",orgImage)
                cell.refreshCellWithEventImageAndText(orgImage!, _text: name)
            } else {
                print("nil")
                cell.titleTextField.text = name
            }
            
            return cell

        } else if indexPath.section == 1 {
            let nib = UINib(nibName: "LabelTextFieldCell", bundle: nil)
            
            tableView.rowHeight = 50
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            
            let cell: EditCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! EditCell
//            cell.selectionStyle = UITableViewCellSelectionStyle.None
//            cell.editTextField.delegate = self
            
            cell.refreshCellWithLabel(about[indexPath.row])
            
            return cell
        } else {
            let nib = UINib(nibName: "IconTextFieldCell", bundle: nil)
            
            tableView.rowHeight = 50
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            
            let cell: EditCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! EditCell
            cell.editIconTextField.delegate = self
            cell.editIconTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            
            cell.refreshCellWithIcon(icons[indexPath.row]!, _keyboardType: keyboardType[indexPath.row], _text: iconTextFieldText[indexPath.row], _placeHolder: placeholders[indexPath.row])
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 {
            return "about"
        } else {
            return "contact"
        }
    }
    
    func getPicture() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        orgImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.tableview!.beginUpdates()
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        self.tableview!.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        self.tableview!.endUpdates()
    }
    
    func textFieldDidChange(textField: UITextField) {
        if textField.placeholder == "phone number" {
            iconTextFieldText[0] = textField.text!
        } else if textField.placeholder == "email" {
            iconTextFieldText[1] = textField.text!
        } else {
            name = textField.text!
        }
    }
    
    func loadUserData() {
        name = currentUser?["fullName"] != nil ? currentUser!["fullName"] as! String : ""
        
        let number = currentUser?["phoneNumber"] != nil ? currentUser!["phoneNumber"] : ""
        let mail = currentUser?.email != nil ? currentUser!.email! : ""
        
        if let userImageFile = currentUser!["orgImage"] as? PFFile {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        print("not nil")
                        self.orgImage = UIImage(data:imageData)
                        self.tableview!.reloadData()
                    }
                }
            }
        }
        
        iconTextFieldText[0] = number as! String
        iconTextFieldText[1] = mail
    }
    
    func saveUserData() {
        let currentUser = PFUser.currentUser()
        currentUser!["fullName"] = name
            
        if orgImage != nil {
            let imageData = UIImageJPEGRepresentation(orgImage!, 0.5)
            let imageFile = PFFile(name: "orgProfilePhoto", data: imageData!)
            currentUser!["orgImage"] = imageFile
        }
            
        currentUser!["phoneNumber"] = iconTextFieldText[0]
        currentUser?.email = iconTextFieldText[1]
        currentUser?.username = iconTextFieldText[1]
    
        currentUser?.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                let alert = UIAlertController(title: "saved!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                
                let delay = 0.5 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alert.dismissViewControllerAnimated(true, completion: {(Bool) in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                })
            } else {
                // There was a problem, check error.description
            }

        }
    }
    
    override func viewDidLoad() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveUserData")
        navigationItem.setRightBarButtonItem(saveButton, animated: true)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        loadUserData()
    }
}
