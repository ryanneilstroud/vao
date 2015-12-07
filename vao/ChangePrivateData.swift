//
//  ChangePrivateData.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 3/12/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class ChangePrivateData: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var viewIndentifier = 0
    let passwordTextfieldPlaceholders = ["new password", "confirm new password"]
    
    var currentPasswordTextFieldText = ""
    var newPasswordTextFieldText = ""
    var newConfirmedPasswordTextFieldText = ""
    var newEmailTextFieldText = ""
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if viewIndentifier == 1 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewIndentifier == 1 {
            if section == 0 {
                return 1
            } else {
                return 2
            }
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let nib = UINib(nibName: "IconTextFieldCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        let cell: EditCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! EditCell
        cell.editIconTextField.delegate = self
        cell.editIconTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        if viewIndentifier == 1 {
            if indexPath.section == 0 {
                cell.refreshCellWithSecureDataOptions(UIImage(named: "ion-ios-locked-outline_256_0_c3c3c3_none.png")!, _secureTextEntry: true, _placeHolder: "current password")
            } else {
                cell.refreshCellWithSecureDataOptions(UIImage(named: "ion-ios-locked-outline_256_0_c3c3c3_none.png")!, _secureTextEntry: true, _placeHolder: passwordTextfieldPlaceholders[indexPath.row])
            }
        } else {
            cell.refreshCellWithSecureDataOptions(UIImage(named: "ion-ios-email-outline_256_0_c3c3c3_none.png")!, _secureTextEntry: false, _placeHolder: "new email")
        }
        
        return cell
    }
    
    func textFieldDidChange(textField: UITextField) {
        if textField.placeholder == "current password" {
            currentPasswordTextFieldText = textField.text!
        } else if textField.placeholder == "new password" {
            newPasswordTextFieldText = textField.text!
        } else if textField.placeholder == "confirm new password" {
            newConfirmedPasswordTextFieldText = textField.text!
        } else if textField.placeholder == "new email" {
            newEmailTextFieldText = textField.text!
        }
    }
    
    func saveUserData() {
        let user = PFUser.currentUser()

        if viewIndentifier == 1 {
            PFUser.logInWithUsernameInBackground(user!.username!, password:currentPasswordTextFieldText) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    print(self.checkPassword())
                } else {
                    // The login failed. Check error to see why.
                }
            }
        } else if viewIndentifier == 2 {
            if checkEmail() {
                user?.username = newEmailTextFieldText
                user?.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        print(success)
                        self.navigationController?.popViewControllerAnimated(true)
                    } else {
                        // There was a problem, check error.description
                        print(error)
                    }
                }
            }
        }
    }
    
    func checkPassword() -> (Bool, String) {
        let user = PFUser.currentUser()
        
        if newPasswordTextFieldText.characters.count < 8 {
            //needs longer password
            return (false, "password too short")
        } else if newPasswordTextFieldText != newConfirmedPasswordTextFieldText {
            //passwords don't match
            return (false, "passwords don't match")
        } else {
            user?.password = newPasswordTextFieldText
            user?.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print(success)
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    // There was a problem, check error.description
                    print(error)
                }
            }
            return (true, "success")
        }
    }
    
    func checkEmail() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return (emailTest.evaluateWithObject(newEmailTextFieldText))
    }
    
    override func viewDidLoad() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveUserData")
        navigationItem.setRightBarButtonItem(saveButton, animated: true)
    }
}