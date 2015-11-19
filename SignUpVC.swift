//
//  SignUpVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 19/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    let screenRect : CGRect = UIScreen.mainScreen().bounds
    
    var volunteersTabIsSelected = true
    
    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    @IBOutlet var backgroundColorImageView: UIImageView!
    @IBOutlet var volunteerButton: UIButton!
    @IBOutlet var organizationButton: UIButton!
    @IBOutlet var pointerImageView: UIImageView!
    @IBOutlet var signUpButton: UIButton!
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        if textField == emailTextField {
//            passwordTextField.becomeFirstResponder()
//        } else if textField == passwordTextField {
//            passwordTextField.resignFirstResponder()
//            attemptLogIn()
//        }
//        return true
//    }
    
    @IBAction func displayVolunteerSignUp(sender: AnyObject) {
        volunteersTabIsSelected = true
        fullNameTextField.placeholder = "full name"
        moveImage()
    }
    
    @IBAction func displayOrganizationSignUp(sender: AnyObject) {
        volunteersTabIsSelected = false
        fullNameTextField.placeholder = "Organization's Name"
        moveImage()
    }
    
    @IBAction func signUp(sender: AnyObject) {
    
    }
    
    @IBAction func cancelSignUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
