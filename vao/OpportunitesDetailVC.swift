//
//  OpportunitesDetailVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 11/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseFacebookUtilsV4

class OpportunitiesDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let NOTIFICATION_CLASS = "Notification"
    
    let EVENT_PARTICIPANT_VALIDATION = "EventParticipantValidation"
    let EVENT_ID = "event"
    let VOLUNTEER = "volunteer"
    let VOLUNTEERS = "volunteers"
    let ORGANIZATION = "organization"
    let INITIATOR_TYPE_IS_VOLUNTEER = "initiatorTypeIsVolunteer"
    
    let USER_TYPE_IS_VOLUNTEER = "userTypeIsVolunteer"
    
    let EVENT_CLASS = "Event"
    
    let STATUS = "status"
    let PENDING = "pending"
    let ACCEPTED = "accepted"
    let DECLINED = "declined"
    
    let CANCEL_REQUEST = "Cancel Request"
    let ACCEPT_REQUEST = "Accept Request"
    let DECLINE_REQUEST = "Decline Request"
    let LEAVE_EVENT = "Leave Event"
    let JOIN_EVENT = "Join Event"
    let VOLUNTEER_DECLINED = "You were declined from this event"
    
    let RECEIVER = "receiver"
    let SENDER = "sender"
    let NOTIFICATION_TYPE = "type"
    let IS_READ = "isRead"
    
    let TYPE_EVENT_PARTICIPANT_VALIDATION = "eventParticipantValidation"
    let TYPE_REVIEW = "review"
    let NOTIFICATION_TYPE_POINTER_ID = "notificationTypePointerId"
    let NOTIFICATION_POINTER = "notifcationPointer"
    
    //        var buttonControlState = UIControlState.Normal
    
    var event = EventClass()
    var objectEvent: PFObject?
    
    var orgInvited = false
    
    var tableview: UITableView!
    
    @IBOutlet var requestIntivationButton: UIButton!
    var screenRect : CGRect = UIScreen.mainScreen().bounds
    
    var buttonTextArray = ["see friends going","join"]

    var timeAndDate = [String]()
    
    let timeAndDateIcons = [UIImage(named: "ion-ios-calendar-outline_256_0_c3c3c3_none.png")!,
                                UIImage(named: "ion-ios-clock-outline_256_0_c3c3c3_none.png")!,
                                UIImage(named:"pe-7s-repeat_256_0_c3c3c3_none.png")]
    
    var location = ""
    var locationGeoPoints: CLLocationCoordinate2D?
    
    let locationIcon = UIImage(named: "ion-ios-location-outline_256_0_c3c3c3_none.png")
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if PFUser.currentUser()![USER_TYPE_IS_VOLUNTEER] as! Bool {
            return 6
        } else {
            buttonTextArray[0] = "see volunteers list"
            return 5
        }
    }
    
    @IBAction func handleVolunteerInvitation(sender: AnyObject) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableview = tableView
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return timeAndDate.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell : EventPhotoCell!
            let nib = UINib(nibName:"EventPhoto", bundle: nil);
            
            tableView.rowHeight = 190
            tableView.registerNib(nib, forCellReuseIdentifier: "coverPhoto")
//            let (attr, value) = name[indexPath.row]
            cell = tableView.dequeueReusableCellWithIdentifier("coverPhoto", forIndexPath: indexPath) as! EventPhotoCell
            cell.eventHostButton.addTarget(self, action: "checkButtonClick:", forControlEvents: .TouchUpInside)
            cell.selectionStyle = .None
            
            
            let user = PFUser.query()
            user!.whereKey("objectId", equalTo:event.createdBy.objectId!)
            user?.findObjectsInBackgroundWithBlock {
                (results: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    print("myObject = ", results)
                    cell.refreshPhotoCoverWithData(self.event.eventImage!, title: self.event.title!, host: results![0]["fullName"] as! String)
                } else {
                    cell.refreshPhotoCoverWithData(self.event.eventImage!, title: self.event.title!, host: "")

                }
            }
            
            return cell
        }
        else if indexPath.section == 1 {
            var cell : IconLabelCell!
            let nib = UINib(nibName:"IconLabelCell", bundle: nil)
            
            tableView.rowHeight = 40
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IconLabelCell
            cell.selectionStyle = .None
            
            cell.refreshCellWithData(timeAndDateIcons[indexPath.row]!, text: timeAndDate[indexPath.row])
            
            return cell
        } else if indexPath.section == 2 {
            var cell : IconLabelCell!
            let nib = UINib(nibName:"IconLabelCell", bundle: nil)
            
            tableView.rowHeight = 40
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IconLabelCell
            cell.selectionStyle = .None
            
            cell.refreshCellWithData(locationIcon!, text: location)
            
            return cell
        } else if indexPath.section == 3 {
            tableView.rowHeight = 200
            
            let nib = UINib(nibName: "MapViewCell", bundle: nil)
            
            tableView.registerNib(nib, forCellReuseIdentifier: "mapCell")
            let cell : MapViewCell = tableView.dequeueReusableCellWithIdentifier("mapCell", forIndexPath: indexPath) as! MapViewCell
            
            if locationGeoPoints != nil {
                cell.refreshCellWithMapData(locationGeoPoints!)
            }
        
            return cell
//        }
//        else if indexPath.section == 4 {
//            print("4")
//            let nib = UINib(nibName:"IconLabelCell", bundle: nil)
//            
//            tableView.rowHeight = 40
//            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
//            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IconLabelCell
////            cell.selectionStyle = .None
//            
//            cell.refreshCellWithData(UIImage(named: "ion-ios-pricetag-outline_256_0_c3c3c3_none.png")!, text: "outgoing, friendly, committed")
//            
//            return cell
        } else if indexPath.section == 4 {
            print("4")
            let nib = UINib(nibName:"SimpleButtonCell", bundle: nil)
            
            tableView.rowHeight = 40
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SimpleButtonCell
            cell.basicButton.enabled = false

            cell.refreshCellWithButtonData(buttonTextArray[0])
            
            return cell
        } else {
            var cell : SimpleButtonCell!
            
            let nib = UINib(nibName:"SimpleButtonCell", bundle: nil)
            
            tableView.rowHeight = 40
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SimpleButtonCell
            cell.selectionStyle = .None
            
            cell.basicButton.enabled = true
            cell.basicButton.addTarget(self, action: "handleEventParticipantValidation:", forControlEvents: UIControlEvents.TouchUpInside)

            var buttonText = ""
            
            if orgInvited == true {
                buttonText = "accept invitation"
            } else {
                buttonText = buttonTextArray[1]
            }
            cell.refreshCellWithButtonData(buttonText)
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 {
            return nil
        } else if section == 2 {
            return " "
        } else if section == 3 {
            return nil
        } else {
            return " "
        }
    }
    
    func checkButtonClick(sender:UIButton!) {
        let vc = OrgProfileVC(nibName:"ProfileView", bundle: nil)
        vc.orgId = event.createdBy.objectId!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("hello there ", indexPath.section)
        if indexPath.section == 4 {
            let user = PFUser.currentUser()
            
            print("hello!")
            
            let request = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields":"name, id, picture"], HTTPMethod: "GET")
            request.startWithCompletionHandler({
                (connection, results, error: NSError!) -> Void in
                if error == nil {
                    let resultsDict = results as! NSDictionary
                    print("results: ", resultsDict)
                                        
                    let vc = FacebookFriendsPageList(nibName: "TableView", bundle: nil)
                    vc.friendsDictionary = resultsDict
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    print("error: ", error)
                }
            })
            
            if user![USER_TYPE_IS_VOLUNTEER] as! Bool {
                if !PFFacebookUtils.isLinkedWithUser(user!) {
                    PFFacebookUtils.linkUserInBackground(user!, withReadPermissions: ["user_friends"], block: {
                        (succeeded: Bool?, error: NSError?) -> Void in
                        if succeeded == true {
                            print("Woohoo, the user is linked with Facebook!")
                        } else {
                            print(error)
                        }
                    })
                } else {
                    //load friend cell
                }
            } else {
                //go to volunteer list
                if objectEvent!["volunteers"] != nil {
                    if objectEvent!["volunteers"].count != 0 {
                        let vc = VolunteerListVC(nibName:"TableView", bundle: nil)
                        vc.eventObject = objectEvent!
                        navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Alert", message: "There are currently no volunteers for this event", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                } else {
                    let alert = UIAlertController(title: "Alert", message: "There are currently no volunteers for this event", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func editEvent() {
        let vc = NewEventVC(nibName:"TableView", bundle: nil)
        vc.editEvent = objectEvent
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    override func viewDidAppear(animated: Bool) {
//        tableview.reloadData()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if PFUser.currentUser()![USER_TYPE_IS_VOLUNTEER] as! Bool == false {
            let editEventButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editEvent")
            self.navigationItem.setRightBarButtonItem(editEventButton, animated: true)
        }
        
        if objectEvent != nil {
            
            print("EVENT = ", objectEvent)
            
            event.title = objectEvent!["title"] as? String
            event.date = objectEvent!["date"] as? NSDate
            event.time = objectEvent!["time"] as? NSDate
            event.locationName = objectEvent!["locationName"] as? String
            if let loc = objectEvent!["location"] as? PFGeoPoint {
                let latitude: CLLocationDegrees = loc.latitude
                let longtitude: CLLocationDegrees = loc.longitude
                
                let newLoc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                event.location = newLoc
            } else {
                let newLoc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                event.location = newLoc
            }

            event.objectId = objectEvent!.objectId
            event.createdBy = objectEvent!["createdBy"] as? PFUser
            if let userImageFile = objectEvent!["eventImage"] as? PFFile {
                userImageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            self.event.setEventImage(UIImage(data:imageData)!)
                        }
                    }
                }
            } else {
                event.setEventImage(UIImage(named: "pe-7s-user_256_0_606060_none.png")!)
            }
            
            event.summary = objectEvent!["summary"] as? String
            event.frequency = objectEvent!["frequency"] as? String
            
        }
        
        navigationItem.title = event.title
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        let dateString = formatter.stringFromDate(event.date!)
        timeAndDate.append(dateString)
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let timeString = timeFormatter.stringFromDate(event.time!)
        timeAndDate.append(timeString)
        timeAndDate.append(event.frequency!)
        
        location = event.locationName!
        
        if event.location != nil {
            locationGeoPoints = event.location
        }
        
        loadStatusOfEventParticipantForVolunteer(event.objectId, _eventCreatedBy: event.createdBy)
    }
    
    //methods for volunteers
    
    //should come from Opportunity Detail View Controller
    func loadStatusOfEventParticipantForVolunteer(_eventId: String, _eventCreatedBy: PFUser) {
        
        print("CALLING: loadStatusOfEventParticipantForVolunteer()")
        
        //get event
        print("event id = ", _eventId)
        let event = PFQuery(className: EVENT_PARTICIPANT_VALIDATION)
        event.whereKey(EVENT_ID, equalTo: _eventId)
        event.getFirstObjectInBackgroundWithBlock {
            (eventObject:PFObject?, error: NSError?) -> Void in
            
            if error == nil {
                print("eventObject: ", eventObject)
                
                //check volunteer and organization
                if eventObject![self.VOLUNTEER] as! PFUser == PFUser.currentUser()! && eventObject![self.ORGANIZATION] as! PFUser == _eventCreatedBy {
                    let eventParticipantValidationStatus = eventObject![self.STATUS] as! String
                    
                    //check initiatorTypeIsVolunteer
                    if eventObject![self.INITIATOR_TYPE_IS_VOLUNTEER] as! Bool {
                        print(self.INITIATOR_TYPE_IS_VOLUNTEER, eventObject![self.INITIATOR_TYPE_IS_VOLUNTEER] as! Bool)
                        
                        if eventParticipantValidationStatus == self.PENDING {
                            //if pending (cancel)
                            print("pending")
                            self.buttonTextArray[1] = self.CANCEL_REQUEST
                            
                        } else if eventParticipantValidationStatus == self.PENDING {
                            //if confirmed (cancel)
                            print("confirmed")
                            self.buttonTextArray[1] = self.LEAVE_EVENT
                            
                        } else if eventParticipantValidationStatus == self.DECLINED {
                            self.buttonTextArray[1] = self.JOIN_EVENT
                        } else if eventParticipantValidationStatus == self.ACCEPTED {
                            self.buttonTextArray[1] = self.LEAVE_EVENT
                        }
                    } else {
                        //initiatorTypeIsVolunteer is FALSE
                        print(self.INITIATOR_TYPE_IS_VOLUNTEER, eventObject![self.INITIATOR_TYPE_IS_VOLUNTEER] as! Bool)
                        if eventParticipantValidationStatus == self.PENDING {
                            //if pending (confirm, decline)
                            print("pending")
                            self.buttonTextArray[1] = self.ACCEPT_REQUEST
                            
                        } else if eventParticipantValidationStatus == self.ACCEPTED {
                            //if confirmed (cancel)
                            print("confirmed")
                            self.buttonTextArray[1] = self.LEAVE_EVENT
                            
                        } else if eventParticipantValidationStatus == self.DECLINED {
                            //if declined (cannot request again)[email them to find out why]
                            print("declined")
                            self.buttonTextArray[1] = self.VOLUNTEER_DECLINED
//                            buttonControlState = UIControlState.Disabled
                        }
                    }
                }
                self.tableview.reloadData()

            } else {
                print("event_query_error: ", error)
                self.buttonTextArray[1] = self.JOIN_EVENT
                self.tableview.reloadData()
            }
        }
    }
    
    func handleEventParticipantValidation(_button: UIButton) {
        
        //get event
        let event = PFQuery(className: EVENT_PARTICIPANT_VALIDATION)
        event.whereKey(EVENT_ID, equalTo: self.event.objectId)
        event.getFirstObjectInBackgroundWithBlock {
            (eventObject:PFObject?, error: NSError?) -> Void in
            
            if error == nil {
                print("eventObject: ", eventObject)
                
                //check volunteer and organization
                if eventObject![self.VOLUNTEER] as! PFUser == PFUser.currentUser()! && eventObject![self.ORGANIZATION] as! PFUser == self.event.createdBy {
                    let eventParticipantValidationStatus = eventObject![self.STATUS] as! String
                    
                    
                    self.createAlertForHandlingEventParticipantValidation(eventObject![self.INITIATOR_TYPE_IS_VOLUNTEER] as! Bool, _eventParticipantValidationStatus: eventParticipantValidationStatus, _eventParticipantValidationEvent: eventObject!)
                }
            } else {
                print("event_query_error: ", error)
                
                //true for volunteer
                let myPFObject = PFObject(className: self.EVENT_PARTICIPANT_VALIDATION)
                self.createAlertForHandlingEventParticipantValidation(true, _eventParticipantValidationStatus: "", _eventParticipantValidationEvent: myPFObject)
            }
        }
    }
    
    func createAlertForHandlingEventParticipantValidation(_initiatorTypeIsVolunteer: Bool, _eventParticipantValidationStatus: String, _eventParticipantValidationEvent: PFObject) {
        
        print(INITIATOR_TYPE_IS_VOLUNTEER, _initiatorTypeIsVolunteer)
        
        //check initiatorTypeIsVolunteer
        if _initiatorTypeIsVolunteer {
            print(INITIATOR_TYPE_IS_VOLUNTEER, _initiatorTypeIsVolunteer)
            
            if _eventParticipantValidationStatus == PENDING {
                //if pending (cancel)
                print("pending")
                
                let alert = UIAlertController(title: "Alert", message: "Are you sure you want to cancel your request?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: { action in
                
                    print("cancelled")
                    
                    _eventParticipantValidationEvent[self.STATUS] = self.DECLINED
                    _eventParticipantValidationEvent[self.INITIATOR_TYPE_IS_VOLUNTEER] = true
                    _eventParticipantValidationEvent.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The post has been added to the user's likes relation.
                            self.loadStatusOfEventParticipantForVolunteer(self.event.objectId, _eventCreatedBy: self.event.createdBy)
                        } else {
                            // There was a problem, check error.description
                            print(error)
                        }
                    }
                    
                    
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else if _eventParticipantValidationStatus == PENDING {
                //if confirmed (cancel)
                print("confirmed")
                
                let alert = UIAlertController(title: "Alert", message: "Are you sure you want to leave this event?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: { action in
                    
                    print("left event")
                    
                    _eventParticipantValidationEvent[self.STATUS] = self.DECLINED
                    _eventParticipantValidationEvent[self.INITIATOR_TYPE_IS_VOLUNTEER] = true
                    _eventParticipantValidationEvent.saveInBackground()
                    
                    let event = PFQuery(className: self.EVENT_CLASS)
                    event.getObjectInBackgroundWithId(_eventParticipantValidationEvent[self.EVENT_ID] as! String) {
                        (event: PFObject?, error: NSError?) -> Void in
                        if error == nil && event != nil {
                            print("this event", event)
                            
                            //add person to volunteers list
                            //check if volunteers array exists
                            if (event!.valueForKey(self.VOLUNTEERS) != nil) {
                                print("not nil")
                                
                                let currentUserId = PFUser.currentUser()?.objectId
                                event!.removeObjectsInArray([currentUserId!], forKey: self.VOLUNTEERS)

                                event?.saveInBackgroundWithBlock {
                                    (success: Bool, error: NSError?) -> Void in
                                    if (success) {
                                            // The object has been saved.
                                        print("success")
                                        self.loadStatusOfEventParticipantForVolunteer(self.event.objectId, _eventCreatedBy: self.event.createdBy)
                                    } else {
                                        // There was a problem, check error.description
                                        print(error)
                                    }
                                }
                                
                            } else {
                                print("nil")
                                event![self.VOLUNTEERS] = [String]()
                                event?.saveInBackgroundWithBlock {
                                    (success: Bool, error: NSError?) -> Void in
                                    if (success) {
                                        // The object has been saved.
                                        print("success")
                                        self.loadStatusOfEventParticipantForVolunteer(self.event.objectId, _eventCreatedBy: self.event.createdBy)
                                    } else {
                                        // There was a problem, check error.description
                                        print(error)
                                    }
                                }
                                
                            }
                            
                        } else {
                            print(error)
                        }
                    }
                    
                    
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Alert", message: "Are you sure you want to join this event?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
                    
                    print("request to join")
                    _eventParticipantValidationEvent[self.VOLUNTEER] = PFUser.currentUser()
                    _eventParticipantValidationEvent[self.ORGANIZATION] = self.event.createdBy
                    _eventParticipantValidationEvent[self.STATUS] = self.PENDING
                    _eventParticipantValidationEvent[self.INITIATOR_TYPE_IS_VOLUNTEER] = true
                    _eventParticipantValidationEvent[self.EVENT_ID] = self.event.objectId
                    _eventParticipantValidationEvent.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The post has been added to the user's likes relation.
                            self.setNotification(_eventParticipantValidationEvent, _notficationType: self.TYPE_EVENT_PARTICIPANT_VALIDATION, _dismiss: true)
                        } else {
                            // There was a problem, check error.description
                            print(error)
                        }
                    }
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            //initiatorTypeIsVolunteer is FALSE
            print(INITIATOR_TYPE_IS_VOLUNTEER, _initiatorTypeIsVolunteer)
            if _eventParticipantValidationStatus == PENDING {
                //if pending (confirm, decline)
                print("pending")
                print("NOT REMOVED")
                
                let alert = UIAlertController(title: "Alert", message: "Would you like to accept this invite?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
                    
                    print("joined event")
                    
                    _eventParticipantValidationEvent[self.STATUS] = self.ACCEPTED
                    _eventParticipantValidationEvent[self.INITIATOR_TYPE_IS_VOLUNTEER] = true
                    _eventParticipantValidationEvent.saveInBackground()
                    
                    let parseEvent = PFQuery(className: self.EVENT_CLASS)
                    parseEvent.getObjectInBackgroundWithId(_eventParticipantValidationEvent[self.EVENT_ID] as! String) {
                        (parseEventObject: PFObject?, error: NSError?) -> Void in
                        if error == nil && parseEventObject != nil {
                            print("this event", parseEventObject)
                            
                            //add person to volunteers list
                            //check if volunteers array exists
                            if (parseEventObject!.valueForKey(self.VOLUNTEERS) != nil) {
                                print("not nil")
                                    
                                let currentUserId = PFUser.currentUser()?.objectId
                                parseEventObject!.addObject(currentUserId!, forKey: self.VOLUNTEERS)
                                    
                                parseEventObject?.saveInBackgroundWithBlock {
                                    (success: Bool, error: NSError?) -> Void in
                                    if (success) {
                                            // The object has been saved.
                                        print("success")
                                        self.setNotification(_eventParticipantValidationEvent, _notficationType: self.TYPE_EVENT_PARTICIPANT_VALIDATION, _dismiss: true)
                                    } else {
                                            // There was a problem, check error.description
                                        print(error)
                                    }
                                }
                                
                            } else {
                                print("this____is____nil")
                                parseEventObject![self.VOLUNTEERS] = [String]()
                                let currentUserId = PFUser.currentUser()?.objectId
                                parseEventObject!.addObject(currentUserId!, forKey: self.VOLUNTEERS)
                                parseEventObject?.saveInBackgroundWithBlock {
                                    (success: Bool, error: NSError?) -> Void in
                                    if (success) {
                                        // The object has been saved.
                                        print("success")

                                        self.loadStatusOfEventParticipantForVolunteer(self.event.objectId, _eventCreatedBy: self.event.createdBy)
                                    } else {
                                        // There was a problem, check error.description
                                        print(error)
                                    }
                                }
                                
                            }
                            
                        } else {
                            print(error)
                        }
                    }
                    
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else if _eventParticipantValidationStatus == ACCEPTED {
                //if confirmed (cancel)
                print("confirmed")
                
                let alert = UIAlertController(title: "Alert", message: "Are you sure you want to leave this event?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: { action in
                    
                    print("left event")
                    
                    _eventParticipantValidationEvent[self.STATUS] = self.DECLINED
                    _eventParticipantValidationEvent[self.INITIATOR_TYPE_IS_VOLUNTEER] = true
                    _eventParticipantValidationEvent.saveInBackground()
                    
                    let event = PFQuery(className: self.EVENT_CLASS)
                    event.getObjectInBackgroundWithId(_eventParticipantValidationEvent[self.EVENT_ID] as! String) {
                        (event: PFObject?, error: NSError?) -> Void in
                        if error == nil && event != nil {
                            print("this event", event)
                            
                            //add person to volunteers list
                            //check if volunteers array exists
                            if (event!.valueForKey(self.VOLUNTEERS) != nil) {
                                print("not nil")
                                
                                let currentUserId = PFUser.currentUser()?.objectId
                                event!.removeObject(currentUserId!, forKey: self.VOLUNTEERS)
                                //                                event!.removeObjectsInArray([currentUserId!], forKey: self.VOLUNTEERS)
                                print("REMOVED!!")
                                event?.saveInBackgroundWithBlock {
                                    (success: Bool, error: NSError?) -> Void in
                                    if (success) {
                                        // The object has been saved.
                                        print("success: removed from event")
                                        self.loadStatusOfEventParticipantForVolunteer(self.event.objectId, _eventCreatedBy: self.event.createdBy)
                                    } else {
                                        // There was a problem, check error.description
                                        print(error)
                                    }
                                }
                                

                            } else {
                                print("nil")
                                event![self.VOLUNTEERS] = [String]()
                                event?.saveInBackgroundWithBlock {
                                    (success: Bool, error: NSError?) -> Void in
                                    if (success) {
                                        // The object has been saved.
                                        print("success")
                                        self.loadStatusOfEventParticipantForVolunteer(self.event.objectId, _eventCreatedBy: self.event.createdBy)
                                    } else {
                                        // There was a problem, check error.description
                                        print(error)
                                    }
                                }

                            }
                            
                        } else {
                            print(error)
                        }
                    }
                    
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else if _eventParticipantValidationStatus == DECLINED {
                //if declined (cannot request again)[email them to find out why]
                print("declined")
                
                //                            buttonControlState = UIControlState.Disabled
            }
        }
    }
    
    func setNotification(_object: PFObject, _notficationType: String, _dismiss: Bool) {
        print("settingNotification")
        let notification = PFQuery(className: self.NOTIFICATION_CLASS)
        notification.whereKey(self.NOTIFICATION_TYPE_POINTER_ID, equalTo: _object.objectId!)
        notification.findObjectsInBackgroundWithBlock {
            (notificationId: [PFObject]?, error: NSError?) -> Void in
            if error == nil && notificationId?.count > 0 {
                
                if notificationId![0][self.NOTIFICATION_TYPE] as! String != _notficationType {
                    let notificationId2 = PFObject(className: self.NOTIFICATION_CLASS)
                    notificationId2[self.NOTIFICATION_TYPE_POINTER_ID] = _object.objectId
                    notificationId2[self.IS_READ] = false
                    notificationId2[self.RECEIVER] = PFUser.currentUser()
                    notificationId2[self.SENDER] = _object[self.ORGANIZATION]
                    notificationId2[self.NOTIFICATION_TYPE] = _notficationType
                    notificationId2.saveInBackground()
                    
                    print("creating new")
                    let notificationId = PFObject(className: self.NOTIFICATION_CLASS)
                    notificationId[self.NOTIFICATION_TYPE_POINTER_ID] = _object.objectId
                    notificationId[self.IS_READ] = false
                    notificationId[self.RECEIVER] = _object[self.ORGANIZATION]
                    notificationId[self.SENDER] = PFUser.currentUser()
                    notificationId[self.NOTIFICATION_TYPE] = _notficationType
                    notificationId.saveInBackgroundWithBlock {
                        (success: Bool?, saveError: NSError?) -> Void in
                        if success != nil {
                            if _dismiss {
                                self.loadStatusOfEventParticipantForVolunteer(self.event.objectId, _eventCreatedBy: self.event.createdBy)
                            }
                        }
                    }
                    
                } else {
                    
                    print("retrieving old")
                    notificationId![0][self.IS_READ] = false
                    notificationId?[0].saveInBackgroundWithBlock {
                        (success: Bool?, saveError: NSError?) -> Void in
                        if success != nil {
                            if _dismiss {
                                self.loadStatusOfEventParticipantForVolunteer(self.event.objectId, _eventCreatedBy: self.event.createdBy)
                            }
                        }
                    }
                }
            } else {
                //createNew
                let notificationId2 = PFObject(className: self.NOTIFICATION_CLASS)
                notificationId2[self.NOTIFICATION_TYPE_POINTER_ID] = _object.objectId
                notificationId2[self.IS_READ] = false
                notificationId2[self.RECEIVER] = PFUser.currentUser()
                notificationId2[self.SENDER] = _object[self.ORGANIZATION]
                notificationId2[self.NOTIFICATION_TYPE] = _notficationType
                notificationId2.saveInBackground()
                
                print("creating new")
                let notificationId = PFObject(className: self.NOTIFICATION_CLASS)
                notificationId[self.NOTIFICATION_TYPE_POINTER_ID] = _object.objectId
                notificationId[self.IS_READ] = false
                notificationId[self.RECEIVER] = _object[self.ORGANIZATION]
                notificationId[self.SENDER] = PFUser.currentUser()
                notificationId[self.NOTIFICATION_TYPE] = _notficationType
                notificationId.saveInBackgroundWithBlock {
                    (success: Bool?, saveError: NSError?) -> Void in
                    if success != nil {
                        if _dismiss {
                            self.loadStatusOfEventParticipantForVolunteer(self.event.objectId, _eventCreatedBy: self.event.createdBy)
                        }
                    }
                }
            }
        }
    }

}

