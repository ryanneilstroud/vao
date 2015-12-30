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
    
    var activeTextField: UITextField?
    
    var name = ""
    
    var saveButton = UIBarButtonItem()
    
    let about = ["location", "gender", "age", "religion", "languages"]
    let icons = [UIImage(named: "ion-ios-telephone-outline_256_0_c3c3c3_none.png"), UIImage(named: "ion-ios-email-outline_256_0_c3c3c3_none.png")]
    var iconTextFieldText = ["",""]
    var labelTextFieldText = ["","","","",""]
    
    let placeholders = ["phone number","email"]
    let aboutPlaceholders = ["Hong Kong", "Male", "22", "Christian", "English, Cantonese"]
    
    var skills = ""
    
    let keyboardType = [UIKeyboardType.PhonePad, UIKeyboardType.EmailAddress, UIKeyboardType.URL]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return about.count
        } else if section == 2 {
            return 1
        } else {
            return icons.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                
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
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.editTextField.delegate = self
            cell.editTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            
            cell.refreshCellWithLabel(about[indexPath.row], _labelValues:labelTextFieldText[indexPath.row] , _placeholder: aboutPlaceholders[indexPath.row])
            
            return cell
        } else if indexPath.section == 2 {
            let nib = UINib(nibName: "LabelTextFieldCell", bundle: nil)
            
            tableView.rowHeight = 50
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            
            let cell: EditCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! EditCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.editTextField.delegate = self
            cell.editTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            
            cell.refreshCellWithLabel("skills", _labelValues: skills, _placeholder: "singing, dancing, computers")
            
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
        } else if section == 2 {
            return "skills"
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
        } else if textField.placeholder == "Hong Kong" {
            labelTextFieldText[0] = textField.text!
        } else if textField.placeholder == "Male" {
            labelTextFieldText[1] = textField.text!
        } else if textField.placeholder == "22" {
            labelTextFieldText[2] = textField.text!
        } else if textField.placeholder == "Christian" {
            labelTextFieldText[3] = textField.text!
        } else if textField.placeholder == "English, Cantonese" {
            labelTextFieldText[4] = textField.text!
        } else if textField.placeholder == "singing, dancing, computers" {
            skills = textField.text!
        } else {
            name = textField.text!
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    func loadUserData() {
        name = currentUser?["fullName"] != nil ? currentUser!["fullName"] as! String : ""
        
        let number = currentUser?["phoneNumber"] != nil ? currentUser!["phoneNumber"] : ""
        let mail = currentUser?.email != nil ? currentUser!.email! : ""
        
        labelTextFieldText[0] = currentUser?["location"] != nil ? currentUser?["location"] as! String : ""
        labelTextFieldText[1] = currentUser?["gender"] != nil ? currentUser?["gender"] as! String : ""
        labelTextFieldText[2] = currentUser?["age"] != nil ? currentUser?["age"] as! String : ""
        labelTextFieldText[3] = currentUser?["religion"] != nil ? currentUser?["religion"] as! String : ""
        labelTextFieldText[4] = currentUser?["languages"] != nil ? currentUser?["languages"] as! String : ""
        skills = currentUser?["skills"] != nil ? currentUser?["skills"] as! String : ""
        
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
    
    func checkEmail() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return (emailTest.evaluateWithObject(iconTextFieldText[1]))
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
    
    func saveUserData() {
        
        saveButton.enabled = false
        
        if checkEmail() {
            if validatePhoneNumber(iconTextFieldText[0]){
                print("valid email: ", iconTextFieldText[1])
                if Reachability.isConnectedToNetwork() {
                    let currentUser = PFUser.currentUser()
                    currentUser!["fullName"] = name
                    
                    if orgImage != nil {
                        let imageData = UIImageJPEGRepresentation(orgImage!, 0.5)
                        let imageFile = PFFile(name: "orgProfilePhoto", data: imageData!)
                        currentUser!["orgImage"] = imageFile
                    }
                    
                    let oldEmail = currentUser?.username
                    
                    currentUser!["phoneNumber"] = iconTextFieldText[0] != "" ? iconTextFieldText[0] : ""
                    currentUser?.email = iconTextFieldText[1] != "" ? iconTextFieldText[1] : ""
                    currentUser?.username = iconTextFieldText[1] != "" ? iconTextFieldText[1] : ""
                    
                    currentUser?["location"] = labelTextFieldText[0] != "" ? labelTextFieldText[0] : ""
                    currentUser?["gender"] = labelTextFieldText[1] != "" ? labelTextFieldText[1] : ""
                    currentUser?["age"] = labelTextFieldText[2] != "" ? labelTextFieldText[2] : ""
                    currentUser?["religion"] = labelTextFieldText[3] != "" ? labelTextFieldText[3] : ""
                    currentUser?["languages"] = labelTextFieldText[4] != "" ? labelTextFieldText[4] : ""
                    currentUser?["skills"] = skills != "" ? skills : ""
                    
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
    //                        print(error)
    //                        let alert = UIAlertController(title: "Error: " + String(error?.code), message: error?.description, preferredStyle: UIAlertControllerStyle.Alert)
    //                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
    //                        self.presentViewController(alert, animated: true, completion: nil)
                            currentUser?.email = oldEmail
                            currentUser?.username = oldEmail
                            
                            let alert = UIAlertController(title: "Invalid Email", message: "Please enter a valid email address.", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                            self.saveButton.enabled = true
                        }
                        
                    }
                } else {
                    let alert = UIAlertController(title: "Internet Not Found", message: "We can't seem to connect to the Internet. Please double check your connection.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    self.saveButton.enabled = true
                }
            } else {
                let alert = UIAlertController(title: "Invalid Phone Number", message: "Please enter a phone number. Example: 555-123-1234", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                self.saveButton.enabled = true
            }
        } else {
            let alert = UIAlertController(title: "Invalid Email", message: "Please enter a valid email address.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.saveButton.enabled = true
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: self.tableview!.contentInset.top, left: 0, bottom: keyboardSize.height, right: 0)
            self.tableview!.contentInset = contentInsets
            
            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            let activeTextFieldRect: CGRect?
            
            if self.activeTextField != nil {
                activeTextFieldRect = self.activeTextField?.superview?.superview?.frame
                self.tableview!.scrollRectToVisible(activeTextFieldRect!, animated:true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: self.tableview!.contentInset.top, left: 0, bottom: 0, right: 0)
        self.tableview!.contentInset = contentInsets
        self.activeTextField = nil
    }
    
    override func viewDidLoad() {
        saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveUserData")
        navigationItem.setRightBarButtonItem(saveButton, animated: true)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        navigationController?.title = "edit"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
        loadUserData()
    }
}
