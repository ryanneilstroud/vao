//
//  RecoverPasswordVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 15/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

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
        if volunteersTabIsSelected == true {
        
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
        
        volunteerButton.translatesAutoresizingMaskIntoConstraints = true
        volunteerButton.frame = CGRectMake(screenRect.width/6, backgroundColorImageView.frame.size.height - 50, 100, 50)
        
        organizationButton.translatesAutoresizingMaskIntoConstraints = true
        organizationButton.frame = CGRectMake(screenRect.width/6 * 3.5, volunteerButton.frame.origin.y, 100, 50)
        
        pointerImage.translatesAutoresizingMaskIntoConstraints = true
        pointerImage.frame = CGRectMake(screenRect.width/6, backgroundColorImageView.frame.size.height - 25, pointerImage.frame.size.width, pointerImage.frame.size.height)
    }
    
    @IBAction func displayRecoverVolunteerPassword(sender: AnyObject) {
        volunteersTabIsSelected = true
        moveImage()
        
    }
    @IBAction func displayRecoverOrganizationPassword(sender: AnyObject) {
        volunteersTabIsSelected = false
        moveImage()

    }
    
    func moveImage(){
        var multiplier : CGFloat = 1
        
        if volunteersTabIsSelected == false {
            multiplier = 3.5
        }
        
        pointerImage.frame = CGRectMake(screenRect.width / 6 * multiplier, backgroundColorImageView.frame.size.height - 25, pointerImage.frame.size.width, pointerImage.frame.size.height)
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
