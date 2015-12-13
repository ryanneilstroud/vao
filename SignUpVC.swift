//
//  SignUpVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 19/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    let screenRect : CGRect = UIScreen.mainScreen().bounds
    
    var volunteersTabIsSelected = true
    
    let STORYBOARD_NAME_VOL = "Main"
    let STORYBOARD_NAME_ORG = "Organizations"
    let VC_IDENTIFIER = "mainScreen"
    
    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    @IBOutlet var backgroundColorImageView: UIImageView!
    @IBOutlet var volunteerButton: UIButton!
    @IBOutlet var organizationButton: UIButton!
    @IBOutlet var pointerImageView: UIImageView!
    @IBOutlet var signUpButton: UIButton!
    
    @IBAction func displayVolunteerSignUp(sender: AnyObject) {
        volunteersTabIsSelected = true
        fullNameTextField.placeholder = "full name"
        moveImage()
    }
    
    @IBAction func displayOrganizationSignUp(sender: AnyObject) {
        volunteersTabIsSelected = false
        fullNameTextField.placeholder = "organization's name"
        moveImage()
    }
    
    @IBAction func signUp(sender: AnyObject) {
        if checkFullName() == true && checkEmail() == true && checkPassword().0 == true {
            signUpWithParse()
            print("true: ", checkFullName(), checkEmail(), checkPassword())
        } else {
            print("one or more are false")
        }
    }
    
    @IBAction func cancelSignUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkFullName() -> Bool {
        if fullNameTextField.text?.characters.count < 3 {
            //input name
            return false
        } else {
            //good to go!
            return true
        }
    }
    
    func checkPassword() -> (Bool, String) {
        if passwordTextField.text?.characters.count < 8 {
            //needs longer password
            let alert = UIAlertController(title: "oh no!", message: "your password must be at least 8 characters long", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return (false, "password too short")
        } else if passwordTextField.text != confirmPasswordTextField.text {
            //passwords don't match
            let alert = UIAlertController(title: "oh no!", message: "your passwords do not match", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return (false, "passwords don't match")
        } else {
            return (true, "success")
        }
    }
    
    func checkEmail() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return (emailTest.evaluateWithObject(emailTextField.text))
    }
    
    func signUpWithParse() {
        
        let user = PFUser()
        user.username = emailTextField.text
        user.password = passwordTextField.text
        user.email = user.username
        // other fields can be set just like with PFObject
        user["fullName"] = fullNameTextField.text
        
        let imageData = UIImageJPEGRepresentation(UIImage(named: "pe-7s-user_256_0_606060_none.png")!, 0.5)
        let imageFile = PFFile(name:"image.png", data:imageData!)
        
        user["orgImage"] = imageFile
        
        user["phoneNumber"] = ""
        user["website"] = ""
        
        user["userTypeIsVolunteer"] = volunteersTabIsSelected
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print(errorString)
            } else {
                // Hooray! Let them use the app now.
                
                var storyboardName : String
                
                if self.volunteersTabIsSelected == true {
                    storyboardName = self.STORYBOARD_NAME_VOL
                } else {
                    storyboardName = self.STORYBOARD_NAME_ORG
                }
                
                let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier(self.VC_IDENTIFIER) as UIViewController
                self.presentViewController(vc, animated: true, completion: nil)

            }
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
                print("Swiped down")
                fullNameTextField.resignFirstResponder()
                passwordTextField.resignFirstResponder()
                emailTextField.resignFirstResponder()
                confirmPasswordTextField.resignFirstResponder()
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.Up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func moveImage(){
        var multiplier : CGFloat = 1
        
        if volunteersTabIsSelected == false {
            multiplier = 3.5
        }
        
        pointerImageView.frame = CGRectMake(screenRect.width / 6 * multiplier, backgroundColorImageView.frame.size.height - 25, pointerImageView.frame.size.width, pointerImageView.frame.size.height)
    }
    
    override func viewDidLoad() {
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        signUpButton.layer.cornerRadius = 5
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(swipeDown)
        
        // Do any additional setup after loading the view, typically from a nib.
        backgroundColorImageView.translatesAutoresizingMaskIntoConstraints = true
        backgroundColorImageView.frame = CGRectMake(backgroundColorImageView.frame.origin.x, backgroundColorImageView.frame.origin.y, screenRect.width, screenRect.height/2)
        
        volunteerButton.translatesAutoresizingMaskIntoConstraints = true
        volunteerButton.frame = CGRectMake(screenRect.width/6, backgroundColorImageView.frame.size.height - 50, 100, 50)
        
        organizationButton.translatesAutoresizingMaskIntoConstraints = true
        organizationButton.frame = CGRectMake(screenRect.width/6 * 3.5, volunteerButton.frame.origin.y, 100, 50)
        
        pointerImageView.translatesAutoresizingMaskIntoConstraints = true
        pointerImageView.frame = CGRectMake(screenRect.width/6, backgroundColorImageView.frame.size.height - 25, pointerImageView.frame.size.width, pointerImageView.frame.size.height)
    }
}
