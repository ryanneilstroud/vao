//
//  OrgEditProfileVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 30/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class OrgEditProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var tableview: UITableView!
    
    var tv: UITableView!
    
    var currentUser = PFUser.currentUser()
    var imagePicker : UIImagePickerController!
    var orgImage: UIImage?
    
    var name = ""
    
    let about = ["location", "languages"]
    let aboutPlaceHolders = ["Hong Kong", "English"]
    var aboutTextFieldText = ["",""]
    
    let icons = [UIImage(named: "ion-ios-telephone-outline_256_0_c3c3c3_none.png"), UIImage(named: "ion-ios-email-outline_256_0_c3c3c3_none.png"), UIImage(named: "ion-ios-world-outline_256_0_c3c3c3_none.png")]
    let placeholders = ["phone number","email","website"]
    var iconTextFieldText = ["","",""]
    let keyboardType = [UIKeyboardType.NumbersAndPunctuation, UIKeyboardType.EmailAddress, UIKeyboardType.URL]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tv = tableView
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return about.count
        } else {
            return icons.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let nib = UINib(nibName: "TextFieldCell", bundle: nil)
            
            tableView.registerNib(nib, forCellReuseIdentifier: "textfieldCell")
            tableView.rowHeight = 100
            
            let cell : NewEventCell = tableView.dequeueReusableCellWithIdentifier("textfieldCell", forIndexPath: indexPath) as! NewEventCell
            cell.eventImageButton.addTarget(self, action: "getPicture", forControlEvents: .TouchUpInside)
            cell.titleTextField.delegate = self
            cell.titleTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            
            print("did begin")
            
            if orgImage != nil {
                print("not nil")
                cell.refreshCellWithEventImageAndText(orgImage!, _text: name)
                print("successfully refreshed cell")
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
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.editTextField.delegate = self
            cell.editTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)

            cell.refreshCellWithLabel(about[indexPath.row], _labelValues: aboutTextFieldText[indexPath.row] , _placeholder: aboutPlaceHolders[indexPath.row])
            
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
                
        self.tv.reloadData()
//        self.tableview.beginUpdates()
//        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
//        self.tableview.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
//        self.tableview.endUpdates()
    }
    
    func textFieldDidChange(textField: UITextField) {
        if textField.placeholder == "phone number" {
            iconTextFieldText[0] = textField.text!
        } else if textField.placeholder == "email" {
            iconTextFieldText[1] = textField.text!
        } else if textField.placeholder == "website" {
            iconTextFieldText[2] = textField.text!
        } else if textField.placeholder == "Hong Kong" {
            aboutTextFieldText[0] = textField.text!
        } else if textField.placeholder == "English" {
            aboutTextFieldText[1] = textField.text!
        } else {
            name = textField.text!
        }
    }
    
    func validatePhoneNumber(_url: String) -> Bool {
        let phoneNumberRegExArray = ["\\(\\d{3}\\)\\s\\d{3}-\\d{4}","\\(\\d{3}\\)\\d{3}-\\d{4}","^\\d{3}-\\d{3}-\\d{4}$","1-\\d{3}-\\d{3}-\\d{4}","\\d{3}\\.\\d{3}\\.\\d{4}"]
        
        for x in 0...phoneNumberRegExArray.count - 1 {
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegExArray[x])
            let result = phoneTest.evaluateWithObject(_url)
            
            if result == true {
                return true
            }
        }
        
        return false
    }
    
    func validateUrl(_url: String) -> Bool {
        let urlRegExArray = ["www\\.[a-z0-9_~-]*\\.(?:com|net|org|edu|gov)",
            "[a-z0-9_~-]*\\.(?:com|net|org|edu|gov)",
            "(http://|https://)www\\.[a-z0-9_~-]*\\.(?:com|net|org|edu|gov)",
            "(http://|https://)[a-z0-9_~-]*\\.(?:com|net|org|edu|gov)"]
        
        for x in 0...urlRegExArray.count - 1 {
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", urlRegExArray[x])
            let result = phoneTest.evaluateWithObject(_url.lowercaseString)
            
            if result == true {
                print(x)
                return true
            }
        }
        
        return false
    }
    
    func saveUserData() {

        if validatePhoneNumber(iconTextFieldText[0]) {
            if validateUrl(iconTextFieldText[2]){
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
                currentUser!["website"] = iconTextFieldText[2]
                
                currentUser!["location"] = aboutTextFieldText[0]
                currentUser!["languages"] = aboutTextFieldText[1]
                
                currentUser?.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The score key has been incremented
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    } else {
                        // There was a problem, check error.description
                        let alert = UIAlertController(title: "Error: " + String(error?.code), message: error?.description, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            } else {
                let alert = UIAlertController(title: "Invalid Web Address", message: "Please enter a valid web address. Example: www.example.com", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }

        } else {
            let alert = UIAlertController(title: "Invalid Phone Number", message: "Please enter a valid phone number. Example: 555-123-1234", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    
    override func viewDidLoad() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveUserData")
        navigationItem.setRightBarButtonItem(saveButton, animated: true)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        name = currentUser?["fullName"] != nil ? currentUser!["fullName"] as! String : ""
        
        let number = currentUser?["phoneNumber"] != nil ? currentUser!["phoneNumber"] : ""
        let mail = currentUser?.email != nil ? currentUser!.email! : ""
        let website = currentUser?["website"] != nil ? currentUser!["website"] : ""
        
        let location = currentUser?["location"] != nil ? currentUser!["location"] : ""
        let languages = currentUser?["languages"] != nil ? currentUser!["languages"] : ""
        
        if let userImageFile = currentUser!["orgImage"] as? PFFile {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.orgImage = UIImage(data:imageData)
                        self.tv.reloadData()
                    }
                } else {
                    print(error)
                }
            }
        } else {
            print("nil")
        }
        
        aboutTextFieldText[0] = location as! String
        aboutTextFieldText[1] = languages as! String
        
        iconTextFieldText[0] = number as! String
        iconTextFieldText[1] = mail
        iconTextFieldText[2] = website as! String
    }
}

