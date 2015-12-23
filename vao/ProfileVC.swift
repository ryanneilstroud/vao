//
//  ProfileVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 5/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class ProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SendToOrgViewingVolunteerProfile {
    
    let EVENT_PARTICIPANT_VALIDATION = "EventParticipantValidation"
    let EVENT_ID = "event"
    let VOLUNTEER = "volunteer"
    let VOLUNTEERS = "volunteers"
    let ORGANIZATION = "organization"
    let INITIATOR_TYPE_IS_VOLUNTEER = "initiatorTypeIsVolunteer"
    
    let EVENT_CLASS = "Event"
    
    let STATUS = "status"
    let PENDING = "pending"
    let ACCEPTED = "accepted"
    let DECLINED = "declined"
    
    let CANCEL_INVITE = "Cancel Invite"
    let ACCEPT_REQUEST = "Accept Request"
    //        let DECLINE_REQUEST = "Decline Request"
    let LEAVE_EVENT = "Leave Event"
    let JOIN_EVENT = "Join Event"
    let VOLUNTEER_DECLINED = "You were declined from this event"
    let REVIEW_INVITES = "Review Invites"
    let INVITE = "Invite"
    
    var profilePic : UIImage?
    var userNumberOfProjects : Int!
    var userNumberOfEvents : Int!
    var userRatingScore : Double!
    
    var reviewsObjects = [PFObject]()
    
    var button: UIButton?
    
    var eventParticipantValidationButtonText = ""
    var orgIsViewing = false
    var volObject: PFObject!
    var volEvents = [String]()
    
    var eventIds = [String]()
    var projectIds = [String]()
    
    var selectedEventForVolunteer = ""
    
    var tableview: UITableView!
    
    let iconImagesArray = [UIImage(named: "ion-ios-telephone-outline_256_0_c3c3c3_none.png"), UIImage(named: "ion-ios-email-outline_256_0_c3c3c3_none.png")]
    var iconLabelArray = ["", ""]
    
    var labelArray = [String]()
    var labelValueArray = [String]()
    
    var skills = ""
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if orgIsViewing {
            return 5
        } else {
            return 4
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            let returnValue = labelArray.count != 0 ? labelArray.count : 0
            return returnValue
//        }
//        else if section == 2 {
//            return 1
        } else if section == 3 {
            return iconImagesArray.count;
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableview = tableView
        
        if indexPath.section == 0 {
            var cell : AttributeValueCells!
            let nib = UINib(nibName:"ProfileSummary", bundle: nil);
            
            tableView.rowHeight = 100
            tableView.registerNib(nib, forCellReuseIdentifier: "summary")
            cell = tableView.dequeueReusableCellWithIdentifier("summary", forIndexPath: indexPath) as! AttributeValueCells;
            cell.selectionStyle = .None
            
            cell.projectsButton.addTarget(self, action: "checkButtonClick:", forControlEvents: .TouchUpInside)
            cell.eventsButton.addTarget(self, action: "checkButtonClick:", forControlEvents: .TouchUpInside)
            cell.ratingsButton.addTarget(self, action: "checkButtonClick:", forControlEvents: .TouchUpInside)

            if profilePic != nil {
                cell.refreshProfileSummaryCellWithData(profilePic!, userProjectCount: userNumberOfProjects, userEventCount: userNumberOfEvents, userRating: userRatingScore)
            } else {
                cell.refreshProfileSummaryCellWithData(userNumberOfProjects, userEventCount: userNumberOfEvents, userRating: userRatingScore)
            }
            
            return cell
        } else if indexPath.section == 1 {
            var cell : AttributeValueCells!
            let nib = UINib(nibName:"AttributeValue", bundle: nil);
            
            tableView.rowHeight = 50
            tableView.registerNib(nib, forCellReuseIdentifier: "details")
            cell = tableView.dequeueReusableCellWithIdentifier("details", forIndexPath: indexPath) as! AttributeValueCells
            cell.selectionStyle = .None
            
            if labelArray.count != 0 {
                cell.refreshProfileAboutCellWithData(labelArray[indexPath.row], attributeValue: labelValueArray[indexPath.row])            
            }
            
            return cell
        } else if indexPath.section == 2 {
            var cell : AttributeValueCells!
            let nib = UINib(nibName:"AttributeValue", bundle: nil);
            
            tableView.rowHeight = 50
            tableView.registerNib(nib, forCellReuseIdentifier: "details")
            cell = tableView.dequeueReusableCellWithIdentifier("details", forIndexPath: indexPath) as! AttributeValueCells
            cell.selectionStyle = .None
            
            cell.refreshProfileAboutCellWithData("skills", attributeValue: skills)
            
            return cell
        } else if indexPath.section == 3 {
            let nib = UINib(nibName:"IconLabelCell", bundle: nil);
            
            tableView.rowHeight = 50
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IconLabelCell
            
            cell.refreshCellWithData(iconImagesArray[indexPath.row]!, text: iconLabelArray[indexPath.row])
            return cell
        } else {
            var cell : SimpleButtonCell!
            let nib = UINib(nibName:"SimpleButtonCell", bundle: nil);
            
            tableView.rowHeight = 50
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SimpleButtonCell
            
            cell.basicButton.addTarget(self, action: "handleEventParticipantValidation:", forControlEvents: UIControlEvents.TouchUpInside)
            button = cell.basicButton
            
            if eventParticipantValidationButtonText == "" {
                cell.refreshCellWithButtonData("invite to event")
            } else {
                cell.refreshCellWithButtonData(eventParticipantValidationButtonText)
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 {
            if labelArray.count != 0 {
                return "about"
            } else {
                return nil
            }
        } else if section == 2 {
            return "skills"
        } else if section == 3 {
            return "contact"
        } else {
            return nil
        }
    }
    
    func checkButtonClick(sender:UIButton!) {
        let vc = SummaryViewController(nibName:"TableView", bundle: nil)
        
        if sender.tag == 0 {
            vc.objectIds = projectIds
            vc.target = 0
        } else if sender.tag == 1 {
            vc.objectIds = eventIds
            vc.target = 1
        } else {
            print("review objects", reviewsObjects)
            vc.ratingObjects = reviewsObjects
            vc.target = 2
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 3 {
            if indexPath.row == 0 {
                UIApplication.sharedApplication().openURL(NSURL(string:"telprompt:" + iconLabelArray[0])!)
            } else if indexPath.row == 1 {
                let email = iconLabelArray[1]
                let url = NSURL(string: "mailto:\(email)")
                UIApplication.sharedApplication().openURL(url!)
            }
        }
    }
    
    func didReceiveAtOrgViewingVolunteerProfile(_eventId: String) {
        selectedEventForVolunteer = _eventId
//        handleEventParticipantValidation(button!)
    }
    
    func getUserData() {
        
        if orgIsViewing == true {
            
            navigationItem.title = volObject["fullName"] != nil ? volObject["fullName"] as! String : ""
            
            iconLabelArray[0] = volObject["phoneNumber"] as! String
            iconLabelArray[1] = volObject["email"] as! String
            if volObject["skills"] != nil {
                skills = volObject["skills"] as! String
            }
            
            let array = ["gender", "age", "religion", "languages", "location"]
            
            for index in 0...4 {
                if volObject[array[index]] != nil {
                    if volObject[array[index]] as! String != "" {
                        labelArray.append(array[index])
                        labelValueArray.append(volObject[array[index]] as! String)
                    }
                }
            }
            
            let userImageFile = volObject["orgImage"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.profilePic = UIImage(data:imageData)
                        
                        self.tableview.reloadData()
                        self.loadStatusOfEventParticipantForOrganization(self.volObject)
                        
                        //get eventParticipantValidationStatus
                    }
                }
            }
            
        } else {
            let volunteer = PFUser.currentUser()
            
            navigationItem.title = volunteer!["fullName"] != nil ? volunteer!["fullName"] as! String : ""
            
            iconLabelArray[0] = volunteer!["phoneNumber"] != nil ? volunteer!["phoneNumber"] as! String : ""
            iconLabelArray[1] = volunteer!["email"] != nil ? volunteer!["email"] as! String : ""
            skills = volunteer!["skills"] != nil ? volunteer!["skills"] as! String : ""
            
            let array = ["gender", "age", "religion", "languages", "location"]
            
            for index in 0...4 {
                if volunteer![array[index]] != nil {
                    if volunteer![array[index]] as! String != "" {
                        labelArray.append(array[index])
                        labelValueArray.append(volunteer![array[index]] as! String)
                    }
                }
            }
            
            let userImageFile = volunteer!["orgImage"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.profilePic = UIImage(data:imageData)
                        
                        self.tableview.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNumberOfProjects = 0
        userNumberOfEvents = 0
        userRatingScore = 0
        
        var volunteer: PFObject!
        if PFUser.currentUser()!["userTypeIsVolunteer"] as! Bool {
            volunteer = PFUser.currentUser()
        } else {
            volunteer = volObject
        }
        
        var events = [PFObject]()
        
        let eventParticipantValidation = PFQuery(className: "EventParticipantValidation")
        eventParticipantValidation.whereKey("volunteer", equalTo: volunteer)
        eventParticipantValidation.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            for object in objects! {
                if object["status"] as! String == "accepted" {
                    events.append(object)
                    
//                    let 
                }
            }
        }
        
        getUserData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getSummary() {
        
        let query = PFQuery(className: "Event")
        
        var userId = ""
        if PFUser.currentUser()!["userTypeIsVolunteer"] as! Bool {
            userId = (PFUser.currentUser()?.objectId)!
        } else {
            userId = volObject.objectId!
        }

        query.whereKey("volunteers", equalTo: userId)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print(objects)
                for object in objects! {
                    if object["frequency"] as! String == "don't repeat" {
                        self.userNumberOfEvents! += 1
                        self.eventIds.append(object.objectId!)
                        self.tableview.reloadData()
                    } else {
                        self.projectIds.append(object.objectId!)
                        self.userNumberOfProjects! += 1
                        self.tableview.reloadData()
                    }
                }
            } else {
                print("oh nooooo")
                print(error)
            }
        }
        
        let reviewsQuery = PFQuery(className: "Review")
        if PFUser.currentUser()!["userTypeIsVolunteer"] as! Bool {
            reviewsQuery.whereKey("volunteer", equalTo: PFUser.currentUser()!)
        } else {
            reviewsQuery.whereKey("volunteer", equalTo: volObject)
        }
        reviewsQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil {
                // There was an error
                print("reviews: ", objects)
                
                self.reviewsObjects.removeAll()
                
                var ratingArray = [Double]()
                
                for review in objects! {
                    if review["reviewerIsVolunteer"] as! Bool == false {
                        self.reviewsObjects.append(review)
                        ratingArray.append(review["rating"] as! Double)
                    }
                }
                
                var orgScore = Double()
                
                for score in ratingArray {
                    orgScore += score
                }
                
                self.userRatingScore = orgScore / Double(ratingArray.count)
                if isnan(self.userRatingScore) {
                    self.userRatingScore = 0
                }
                self.tableview.reloadData()
                
            } else {
                // objects has all the Posts the current user liked.
                print(error)
            }
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        labelArray.removeAll()
        labelValueArray.removeAll()
        getUserData()
        
        eventIds.removeAll()
        projectIds.removeAll()
        
        userNumberOfProjects = 0
        userNumberOfEvents = 0
        userRatingScore = 0
        getSummary()
    }
    
    func loadStatusOfEventParticipantForOrganization(_volunteerObject: PFObject) {
        //get volunteer
        let volunteer = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
        volunteer.whereKey(self.VOLUNTEER, equalTo: _volunteerObject)
        volunteer.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil {
                print(objects)
                
                    self.eventParticipantValidationButtonText = self.REVIEW_INVITES
                    self.tableview.reloadData()
                
            } else {
                print(error)
            }
        }
    }
    
    func handleEventParticipantValidation(_button: UIButton) {
        let volunteer = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
        volunteer.whereKey(self.VOLUNTEER, equalTo: volObject)
        volunteer.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil {
                print(objects)

                    let vc = OrgHandlesEventInvites(nibName:"TableView", bundle: nil)
                    vc.eventValidationObjects = objects!
                    vc.volunteerObject = self.volObject
                    self.navigationController?.pushViewController(vc, animated: true)
                    
            } else {
                print(error)
            }
        }
    }
    
}