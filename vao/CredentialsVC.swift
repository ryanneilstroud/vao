//
//  CredentialsVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 11/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class CredentialsVC: UIViewController, UITextFieldDelegate {
    
    let screenRect : CGRect = UIScreen.mainScreen().bounds
    
    let STORYBOARD_NAME_VOL = "Main"
    let STORYBOARD_NAME_ORG = "Organizations"
    let VC_IDENTIFIER = "mainScreen"
    
    var volunteersTabIsSelected = true
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var backgroundColorImageView: UIImageView!
//    @IBOutlet var volunteerButton: UIButton!
//    @IBOutlet var organizationButton: UIButton!
//    @IBOutlet var pointerImageView: UIImageView!
    
    @IBOutlet var logInButton: UIButton!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            attemptLogIn()
        }
        return true
    }

    
    func attemptLogIn() {
        
        PFUser.logInWithUsernameInBackground(emailTextField.text!, password:passwordTextField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                
                var storyboardName : String
                let userType = user!["userTypeIsVolunteer"] as! Int
                
                if userType == 1 {
                    storyboardName = self.STORYBOARD_NAME_VOL
                } else {
                    storyboardName = self.STORYBOARD_NAME_ORG
                }
                
                let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier(self.VC_IDENTIFIER) as UIViewController
                self.presentViewController(vc, animated: true, completion: nil)

            } else {
                // The login failed. Check error to see why.
                print("log in failed")
            }
        }
    }
    
//    @IBAction func displayVolunteerSignIn(sender: AnyObject) {
//        volunteersTabIsSelected = true
//        moveImage()
//    }
//    
//    @IBAction func displayOrganizationSignIn(sender: AnyObject) {
//        volunteersTabIsSelected = false
//        moveImage()
//    }
    
//    func moveImage(){
//        var multiplier : CGFloat = 1
//        
//        if volunteersTabIsSelected == false {
//            multiplier = 3.5
//        }
//        
//        pointerImageView.frame = CGRectMake(screenRect.width / 6 * multiplier, backgroundColorImageView.frame.size.height - 25, pointerImageView.frame.size.width, pointerImageView.frame.size.height)
//    }
    
    @IBAction func logIn(sender: AnyObject) {
        attemptLogIn()
    }
    
    @IBAction func signUp(sender: AnyObject) {
        let nib = SignUpVC(nibName:"SignUp", bundle: nil) as SignUpVC
        self.presentViewController(nib, animated: true, completion: nil)
    }
    
    @IBAction func recoverPassword(sender: AnyObject) {
        let nib = RecoverPasswordVC(nibName: "RecoverPassword", bundle: nil)
        presentViewController(nib, animated: true, completion: nil)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
                print("Swiped down")
                passwordTextField.resignFirstResponder()
                emailTextField.resignFirstResponder()
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.Up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        logInButton.layer.cornerRadius = 5
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(swipeDown)
        
        // Do any additional setup after loading the view, typically from a nib.
        backgroundColorImageView.translatesAutoresizingMaskIntoConstraints = true
        backgroundColorImageView.frame = CGRectMake(backgroundColorImageView.frame.origin.x, backgroundColorImageView.frame.origin.y, screenRect.width, screenRect.height/2)
        
//        volunteerButton.translatesAutoresizingMaskIntoConstraints = true
//        volunteerButton.frame = CGRectMake(screenRect.width/6, backgroundColorImageView.frame.size.height - 50, 100, 50)
//        
//        organizationButton.translatesAutoresizingMaskIntoConstraints = true
//        organizationButton.frame = CGRectMake(screenRect.width/6 * 3.5, volunteerButton.frame.origin.y, 100, 50)
//        
//        pointerImageView.translatesAutoresizingMaskIntoConstraints = true
//        pointerImageView.frame = CGRectMake(screenRect.width/6, backgroundColorImageView.frame.size.height - 25, pointerImageView.frame.size.width, pointerImageView.frame.size.height)
    }
}
