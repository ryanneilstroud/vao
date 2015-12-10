//
//  RecoverPasswordVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 15/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class RecoverPasswordVC: UIViewController, UITextFieldDelegate {
    
    let screenRect : CGRect = UIScreen.mainScreen().bounds
    var volunteersTabIsSelected = true
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var backgroundColorImageView: UIImageView!
    @IBOutlet var recoverPasswordButton: UIButton!
    
    @IBOutlet var organizationButton: UIButton!
    @IBOutlet var volunteerButton: UIButton!
    @IBOutlet var pointerImage: UIImageView!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField {
            attemptRetrievePassword()
        }
        return true
    }
    
    func attemptRetrievePassword() {
        
        if Reachability.isConnectedToNetwork() == true {
            PFUser.requestPasswordResetForEmailInBackground(emailTextField.text!.lowercaseString)
            
            let alert = UIAlertController(title: "Success", message: "an email has been sent with a link to reset your password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.Default, handler: { action in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        } else {
            let alert = UIAlertController(title: "Error", message: "unable to connect to the internet", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        
        emailTextField.delegate = self
        
        recoverPasswordButton.layer.cornerRadius = 5
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(swipeDown)
        
        backgroundColorImageView.translatesAutoresizingMaskIntoConstraints = true
        backgroundColorImageView.frame = CGRectMake(backgroundColorImageView.frame.origin.x, backgroundColorImageView.frame.origin.y, screenRect.width, screenRect.height/2)
    }
    
    @IBAction func recoverPassword(sender: AnyObject) {
        attemptRetrievePassword()
    }
    
    @IBAction func cancelRecoverPassword(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
                print("Swiped down")
                emailTextField.resignFirstResponder()
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
    
}
