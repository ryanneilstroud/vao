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
        
    var profilePic : UIImage?
    var userNumberOfProjects : Int!
    var userNumberOfEvents : Int!
    var userRatingScore : Double!
    
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
        } else if section == 2 {
            return 1
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
            var cell : TextviewCell
            let nib = UINib(nibName:"TextviewCell", bundle: nil);
            
            tableView.rowHeight = 50
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TextviewCell
            cell.selectionStyle = .None
            
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
            
//            cell.basicButton.addTarget(self, action: "handleEventParticipantValidation:", forControlEvents: UIControlEvents.TouchUpInside)
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
        let vc = SummaryVC(nibName:"Summary", bundle: nil)
        
        if sender.tag == 0 {
            vc.objectIds = projectIds
            vc.target = 0
        } else if sender.tag == 1 {
            vc.objectIds = eventIds
            vc.target = 1
        } else {
            
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
        handleEventParticipantValidation(button!)
    }
    
    func handleEventParticipantValidation(_button: UIButton) {
        let EVENT_PARTICIPANT_VALIDATION = "EventParticipantValidation"
        let VOLUNTEER = "volunteer"
        let ORGANIZATION = "organization"
        let EVENT = "event"
        
        let user = PFUser.currentUser()
        
        let volunteerQuery = PFQuery(className: EVENT_PARTICIPANT_VALIDATION)
        volunteerQuery.whereKey(VOLUNTEER, equalTo: volObject)
        
        print("volObject = ", volObject)
        
        let organizationQuery = PFQuery(className: EVENT_PARTICIPANT_VALIDATION)
        organizationQuery.whereKey(ORGANIZATION, equalTo: user!)
        
        print("volEvents = ", volEvents)
        
        let eventQuery = PFQuery(className: EVENT_PARTICIPANT_VALIDATION)
        if volEvents.isEmpty == false {
            eventQuery.whereKey(EVENT, equalTo: volEvents[0])
            print("not empty")
        } else {
            eventQuery.whereKey(EVENT, equalTo: "0")
            print("empty")
        }
        
        let compoundQuery = PFQuery.orQueryWithSubqueries([volunteerQuery, organizationQuery, eventQuery])
        compoundQuery.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if results?.count == 0 {
                    print("results count 0")
                    if self.selectedEventForVolunteer == "" {
                        print("no event selected")
                        let eventParticipantValidation = PFObject(className: EVENT_PARTICIPANT_VALIDATION)
                        
                        if user!["userTypeIsVolunteer"] as! Bool == false {
                            eventParticipantValidation[ORGANIZATION] = user!
                            eventParticipantValidation["status"] = "pending"
                            eventParticipantValidation[VOLUNTEER] = self.volObject
                            eventParticipantValidation["event"] = self.selectedEventForVolunteer
                            eventParticipantValidation["initiatorTypeIsVolunteer"] = false
                            
                            eventParticipantValidation.saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // The object has been saved.
                                    
                                    _button.setTitle("cancel request", forState: UIControlState.Normal)
                                    
                                } else {
                                    // There was a problem, check error.description
                                }
                            }
                        } else {
                            print("true")
                        }
                    } else {
                        print("event selected")
                        let vc = OpportunitiesVC(nibName: "TableView", bundle: nil)
                        vc.delegate = self
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    print("results count is greater than 0")
                    print("results = ", results)
                    let query = PFQuery(className: "Event")
                    query.getObjectInBackgroundWithId(self.volEvents[0]) {
                        (event: PFObject?, error: NSError?) -> Void in
                        if error == nil {
                            print("not nil")
                            
                            let eventTitle =  event!["title"] as! String
                            
                            let alertTitle = "Alert!"
                            var alertMessage = ""
                            var alertButtonTitleArray = [String]()
                            
                            if results![0]["status"] as! String == "pending" {
                                //confirm
                                if results![0]["initiatorTypeIsVolunteer"] as! Bool {
                                    alertMessage = "accept this person as a volunteer for " + eventTitle
                                    alertButtonTitleArray.append("decline")
                                    alertButtonTitleArray.append("accept")
                                } else {
                                    alertMessage = "cancel invitation"
                                    alertButtonTitleArray.append("uninvite")
                                }
                            } else if results![0]["status"] as! String == "confirmed" {
                                //cancel
                                alertMessage = "univite this person as a volunteer for " + eventTitle
                                alertButtonTitleArray.append("uninvite")
                            } else if results![0]["status"] as! String == "declined" {
                                //invite
                                
                                print("declined status")
                                
                                if self.selectedEventForVolunteer != "" {
                                    print("no event selected")
                                    let eventParticipantValidation = PFObject(className: EVENT_PARTICIPANT_VALIDATION)
                                    
                                    if user!["userTypeIsVolunteer"] as! Bool == false {
                                        eventParticipantValidation[ORGANIZATION] = user!
                                        eventParticipantValidation["status"] = "pending"
                                        eventParticipantValidation[VOLUNTEER] = self.volObject
                                        eventParticipantValidation["event"] = self.selectedEventForVolunteer
                                        eventParticipantValidation["initiatorTypeIsVolunteer"] = false
                                        
                                        eventParticipantValidation.saveInBackgroundWithBlock {
                                            (success: Bool, error: NSError?) -> Void in
                                            if (success) {
                                                // The object has been saved.
                                                
                                                _button.setTitle("cancel request", forState: UIControlState.Normal)
                                                
                                            } else {
                                                // There was a problem, check error.description
                                            }
                                        }
                                    } else {
                                        print("true")
                                    }
                                } else {
                                    print("event selected")
                                    let vc = OpportunitiesVC(nibName: "TableView", bundle: nil)
                                    vc.delegate = self
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                
//                                alertMessage = "invite this person to be a volunteer for " + eventTitle
//                                alertButtonTitleArray.append("invite")
                            }
                            
                            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
                            
                            for _title in alertButtonTitleArray {
                                alert.addAction(UIAlertAction(title: _title, style: UIAlertActionStyle.Default, handler: { action in
                            
                                    var status = ""
                                    var buttonText = ""
                                    var addVolunteerToEvent = false
                                    
                                    switch action.title {
                                    case "accept"?:
                                        status = "confirmed"
                                        buttonText = "uninvite volunteer "
                                        addVolunteerToEvent = true
                                    case "decline"?:
                                        status = "declined"
                                        buttonText = "invite volunteer "
                                        addVolunteerToEvent = false
                                    case "uninvite"?:
                                        status = "declined"
                                        buttonText = "invite volunteer "
                                        addVolunteerToEvent = false
                                    case "invite"?:
                                        status = "pending"
                                        buttonText = "cancel invite "
                                        results![0]["initiatorTypeIsVolunteer"] = false
                                    default:
                                        print("cancel")
                                        break
                                    }
                                                                        
                                    if (event!.valueForKey("volunteers") != nil) {
                                        print("not nil")
                                        
                                        if addVolunteerToEvent {
                                            if event!["volunteers"].containsObject(self.volObject) {
                                                
                                            } else {
                                                event!["volunteers"].addObject(self.volObject)
                                            }
                                        } else {
                                            if event!["volunteers"].containsObject(self.volObject) {

                                            } else {
                                                event!["volunteers"].removeObject(self.volObject)
                                            }
                                        }
                                    } else {
                                        print("nil")
                                        event!["volunteers"] = [PFObject]()
                                        event?.saveInBackgroundWithBlock {
                                            (success: Bool, error: NSError?) -> Void in
                                            if (success) {
                                                // The object has been saved.
                                                if addVolunteerToEvent {
                                                    if event!["volunteers"].containsObject(self.volObject) {
                                                        
                                                    } else {
                                                        event!["volunteers"].addObject(self.volObject)
                                                    }
                                                } else {
                                                    if event!["volunteers"].containsObject(self.volObject) {
                                                        
                                                    } else {
                                                        event!["volunteers"].removeObject(self.volObject)
                                                    }
                                                }
                                            } else {
                                                // There was a problem, check error.description
                                            }
                                        }
                                    }

                                    event?.saveInBackgroundWithBlock {
                                        (success: Bool, error: NSError?) -> Void in
                                        if (success) {
                                        
                                            results![0]["status"] = status
                                            results![0].saveInBackgroundWithBlock {
                                                (success: Bool, error: NSError?) -> Void in
                                                if (success) {
                                                    self.eventParticipantValidationButtonText = buttonText + eventTitle
                                                    
                                                    self.tableview.reloadData()
                                                } else {
                                                    print(error)
                                                }
                                            }
                                        
                                        } else {
                                            // There was a problem, check error.description
                                            print(error)
                                        }
                                    }

                                }))
                            }
                            
                            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                        } else {
                            print(error)
                        }
                    }
                }
            } else {
                print("error = ",error)
            }
        }
    }
    
    func getEventParticipantValidationStatus(_volunteerObject: PFObject) {
        
        let EVENT_PARTICIPANT_VALIDATION = "EventParticipantValidation"
        let VOLUNTEER = "volunteer"
        let ORGANIZATION = "organization"
        
        let user = PFUser.currentUser()
        let volunteer = volObject
        
        let volunteerQuery = PFQuery(className: EVENT_PARTICIPANT_VALIDATION)
        volunteerQuery.whereKey(VOLUNTEER, equalTo: volunteer)
        
        let organizationQuery = PFQuery(className: EVENT_PARTICIPANT_VALIDATION)
        organizationQuery.whereKey(ORGANIZATION, equalTo: user!)
        
        let query = PFQuery.orQueryWithSubqueries([volunteerQuery, organizationQuery])
        query.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // results contains players with lots of wins or only a few wins.
                print("results = ",results)
                if results!.count == 0 {
                    
                } else {
//                    if results![0]["initiatorTypeIsVolunteer"] as! Bool {
                    
                        if results!.count == 1 {
                            
                            for result in results! {
                                let query = PFQuery(className: "Event")
                                query.getObjectInBackgroundWithId(result["event"] as! String) {
                                    (event: PFObject?, error: NSError?) -> Void in
                                    if error == nil {
                                        print(event)
                                        
                                        self.volEvents.append(event!.objectId!)
                                        
                                        if result["status"] as! String == "pending" {
                                            
                                            let eventTitle =  event!["title"] as! String
                                            self.eventParticipantValidationButtonText = "accept request for " + eventTitle
                                            self.tableview.reloadData()
                                            
                                        } else if result["status"] as! String == "confrimed" {
                                        
                                            let eventTitle =  event!["title"] as! String
                                            self.eventParticipantValidationButtonText = "remove volunteer from " + eventTitle
                                            self.tableview.reloadData()
                                            
                                        } else if result["status"] as! String == "declined" {
                                            
                                            let eventTitle =  event!["title"] as! String
                                            self.eventParticipantValidationButtonText = "invite volunteer to " + eventTitle
                                            self.tableview.reloadData()
                                        }
                                    } else {
                                        print(error)
                                    }
                                }
                            }
//                        } else {
//                        
//                        }
                    }
                }
            } else {
                print("error = ",error)
            }
        }
    }
    
    func getUserData() {
        
        if orgIsViewing == true {
            
            navigationItem.title = volObject["fullName"] != nil ? volObject["fullName"] as! String : ""
            
            iconLabelArray[0] = volObject["phoneNumber"] as! String
            iconLabelArray[1] = volObject["email"] as! String
            
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
                        
                        //get eventParticipantValidationStatus
                        self.getEventParticipantValidationStatus(self.volObject)
                    }
                }
            }
            
        } else {
            let volunteer = PFUser.currentUser()
            
            navigationItem.title = volunteer!["fullName"] != nil ? volunteer!["fullName"] as! String : ""
            
            iconLabelArray[0] = volunteer!["phoneNumber"] != nil ? volunteer!["phoneNumber"] as! String : ""
            iconLabelArray[1] = volunteer!["email"] != nil ? volunteer!["email"] as! String : ""
            
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
        getUserData()
        // Do any additional setup after loading the view, typically from a nib.

        userNumberOfProjects = 0
        userNumberOfEvents = 0
        userRatingScore = 0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}