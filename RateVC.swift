//
//  RateVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 18/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class RateVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    let USER_TYPE_IS_VOLUNTEER = "userTypeIsVolunteer"
    
    let REVIEW = "Review"
    let ORGANIZATION = "organization"
    let VOLUNTEER = "volunteer"
    let EVENT = "event"
    let REVIEWER_IS_VOLUNTEER = "reviewerIsVolunteer"
    let COMMENT = "comment"
    let RATING = "rating"
    
    let CREATED_BY = "createdBy"
    
    let SELECTED_STAR = "ion-ios-star_100_0_e4e400_none.png"
    let UNSELECTED_STAR = "ion-ios-star-outline_100_0_a3a3a3_none.png"
    
    let OKAY = "okay"
    let CANCEL = "cancel"
    
    let SUBMIT = "submit"
    let EMPTY_COMMENT_TEXT = "The comment box below is empty, are you sure you don't want to say a few words?"
    
    var eventObject: PFObject!
    var volunteer: PFObject?
    var rateCell: RateCell!
    
    var previousReview: PFObject?
    
    var tableview: UITableView!
    var activeTextView: UITextView?
    
    var commentText = ""
    var userScore = 10

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableview = tableView
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if PFUser.currentUser()![USER_TYPE_IS_VOLUNTEER] as! Bool {
                let nib = UINib(nibName:"OpportunitiesCell", bundle: nil);
                tableView.rowHeight = 160
                tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
                
                let cell: OpportuntiesCell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
                cell.refreshCellWithObject(eventObject)
                
                return cell
            } else {
                let nib = UINib(nibName: "VolunteersCell", bundle: nil)
                
                tableView.rowHeight = 100
                tableView.registerNib(nib, forCellReuseIdentifier: "volunteer")
                
                let cell : VolunteersTVC = tableView.dequeueReusableCellWithIdentifier("volunteer", forIndexPath: indexPath) as! VolunteersTVC
                
                if volunteer != nil {
                    cell.refreshCellWithVolunteer(volunteer!)
                }
                return cell
            }
        } else if indexPath.section == 1 {
            
            let nib = UINib(nibName: "ScoreCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "scoreCell")
            tableView.rowHeight = 100
            
            let cell = tableView.dequeueReusableCellWithIdentifier("scoreCell", forIndexPath: indexPath) as! RateCell
            cell.firstStar.addTarget(self, action: "handleRatings:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.secondStar.addTarget(self, action: "handleRatings:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.thirdStar.addTarget(self, action: "handleRatings:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.fourthStar.addTarget(self, action: "handleRatings:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.fifthStar.addTarget(self, action: "handleRatings:", forControlEvents: UIControlEvents.TouchUpInside)

            cell.selectionStyle = .None
            rateCell = cell
            
            if previousReview != nil {
                cell.manageRating(previousReview![RATING] as! Int)
            }
            
            return cell
        } else if indexPath.section == 2 {
            
            let nib = UINib(nibName: "CommentCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "commentCell")
            tableView.rowHeight = 200
            
            let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! RateCell
            cell.commentTextView.delegate = self
            cell.selectionStyle = .None

            if previousReview != nil {
                cell.manageTextView(previousReview![COMMENT] as? String)
            } else {
                cell.manageTextView("")
            }
            
            return cell
        } else {
            let nib = UINib(nibName: "FullButtonCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "buttonCell")
            tableView.rowHeight = 50
            
            let cell = tableView.dequeueReusableCellWithIdentifier("buttonCell", forIndexPath: indexPath) as! RateCell
            cell.selectionStyle = .None
            cell.submitButton.addTarget(self, action: "submitReview", forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.manageButton()
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            if PFUser.currentUser()![USER_TYPE_IS_VOLUNTEER] as! Bool {
                let vc = OpportunitiesDetailVC(nibName:"OpportunitiesDetailVC", bundle: nil)
                vc.objectEvent = eventObject
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = ProfileVC(nibName:"ProfileView", bundle: nil)
                vc.orgIsViewing = true
                vc.volObject = volunteer
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func submitReview() {
        
        //create Review
        
        if userScore == 10 {
            createAlert("Alert", _message: "Please rate this event", _cancelText: OKAY, _secondParam: "")
        } else if commentText == "" {
            print("commentText = ", commentText)
            createAlert("Are you sure?", _message: EMPTY_COMMENT_TEXT, _cancelText: CANCEL, _secondParam: SUBMIT)
        } else {
            createAlert("Confirmation", _message: "Are you sure you want to submit this review?", _cancelText: CANCEL, _secondParam: SUBMIT)
        }
    }
    
    func saveReview() {
        
        if previousReview == nil {
            
            let review = PFObject(className: REVIEW)
            review[COMMENT] = commentText
            review[RATING] = userScore
            review[REVIEWER_IS_VOLUNTEER] = PFUser.currentUser()![USER_TYPE_IS_VOLUNTEER]
            review[EVENT] = eventObject
            
            if PFUser.currentUser()![USER_TYPE_IS_VOLUNTEER] as! Bool {
                review[ORGANIZATION] = eventObject[CREATED_BY]
                review[VOLUNTEER] = PFUser.currentUser()
            } else {
                review[ORGANIZATION] = PFUser.currentUser()
                review[VOLUNTEER] = volunteer
            }

            review.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The post has been added to the user's likes relation.
                    self.navigationController?.popToRootViewControllerAnimated(true)
                } else {
                    self.createAlert("Error " + String(error?.code), _message: error!.description, _cancelText: "", _secondParam: "")
                    // There was a problem, check error.description
                }
            }
        } else {
            previousReview![COMMENT] = commentText
            previousReview![RATING] = userScore
            
            previousReview!.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The post has been added to the user's likes relation.
                    self.navigationController?.popToRootViewControllerAnimated(true)
                } else {
                    self.createAlert("Error " + String(error?.code), _message: error!.description, _cancelText: "", _secondParam: "")
                    // There was a problem, check error.description
                }
            }
        }
    }
    
    func createAlert(_title: String, _message: String, _cancelText: String, _secondParam: String) {
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: _cancelText, style: UIAlertActionStyle.Default, handler: nil))
        
        if _secondParam != "" {
            alert.addAction(UIAlertAction(title: _secondParam, style: UIAlertActionStyle.Default, handler: { action in
                if _secondParam == self.SUBMIT {
                    self.saveReview()
                }
            }))
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleRatings(_button: UIButton) {
        
        let array = [rateCell.firstStar, rateCell.secondStar, rateCell.thirdStar, rateCell.fourthStar, rateCell.fifthStar]
        
        for button in array {
            button.setImage(UIImage(named: UNSELECTED_STAR), forState: UIControlState.Normal)
        }
        
        switch (_button.tag) {
        case 1:
            _button.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
        case 2:
            rateCell.firstStar.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
            _button.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
        case 3:
            rateCell.firstStar.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
            rateCell.secondStar.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
            _button.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
        case 4:
            rateCell.firstStar.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
            rateCell.secondStar.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
            rateCell.thirdStar.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
            _button.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
        case 5:
            rateCell.firstStar.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
            rateCell.secondStar.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
            rateCell.thirdStar.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
            rateCell.fourthStar.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
            _button.setImage(UIImage(named: SELECTED_STAR), forState: UIControlState.Normal)
        default:
            break
        }
        
        userScore = _button.tag
    }
    
    func textViewDidBeginEditing (textView: UITextView) {
        activeTextView = textView
    }
    
    func textViewDidChange(textView: UITextView) {
        print(textView.text)
        commentText = textView.text
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
            
            if self.activeTextView != nil {
                activeTextFieldRect = self.activeTextView?.superview?.superview?.frame
                self.tableview!.scrollRectToVisible(activeTextFieldRect!, animated:true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: self.tableview!.contentInset.top, left: 0, bottom: 0, right: 0)
        self.tableview!.contentInset = contentInsets
        self.activeTextView = nil
    }
    
    override func viewDidLoad() {
        navigationItem.title = "Review"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
        print(eventObject)
        
        let review = PFQuery(className: REVIEW)
        review.whereKey(EVENT, equalTo: eventObject)
        review.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil {
                print(objects)
                
                if PFUser.currentUser()![self.USER_TYPE_IS_VOLUNTEER] as! Bool {
                    for object in objects! {
                        if object[self.VOLUNTEER] as! PFUser == PFUser.currentUser()! && object[self.REVIEWER_IS_VOLUNTEER] as! Bool {
                            self.previousReview = object
                            self.commentText = self.previousReview![self.COMMENT] as! String
                            self.tableview.reloadData()
                        }
                    }
                } else {
                    for object in objects! {
                        if object[self.VOLUNTEER] as! PFUser == self.volunteer && object[self.REVIEWER_IS_VOLUNTEER] as! Bool == false {
                            self.previousReview = object
                            self.commentText = self.previousReview![self.COMMENT] as! String
                            self.tableview.reloadData()
                        }
                    }
                }
        
                
            } else {
                print("no previous review")
            }
        }
    }
    
}
