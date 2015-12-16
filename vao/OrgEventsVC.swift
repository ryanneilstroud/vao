//
//  OrgEventsVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 19/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class OrgEventsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    let CANCEL_REQUEST = "Cancel Request"
    let ACCEPT_REQUEST = "Accept Request"
    //        let DECLINE_REQUEST = "Decline Request"
    let LEAVE_EVENT = "Leave Event"
    let JOIN_EVENT = "Join Event"
    let VOLUNTEER_DECLINED = "You were declined from this event"
    
    var eventObjects = [PFObject]()
    var eventArray = [PFObject]()
    var volunteerObject: PFObject!
    
    var declineOrAcceptEventArray = [String]()
    var inviteEventArray = [String]()
    var cancelEventArray = [String]()
    
    var tableview: UITableView!
    
    var didLoadData = false
    
//    @IBAction func dismissEventsVC(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableview2")
        
        tableview = tableView
        
        if didLoadData == false {
            didLoadData = true
            print("false")
            loadData()
        }
        
        return eventArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("tableview")
        
        let nib = UINib(nibName: "OpportunitiesCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
        tableView.rowHeight = 160
        
        let cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
//        cell.refreshCellWithOpportunityData(titlesArray[indexPath.row], dateAndTime: NSDate(), location: "", summary: "", picture: eventImages[indexPath.row]!)
        
//        if eventArray != nil {
            if eventArray.count > 0 {
                print("eventArray = ", eventArray)
                cell.refreshCellWithObject(eventArray[indexPath.row])
            }
//        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let initiatorTypeIsVolunteer = eventObjects[indexPath.row]["initiatorTypeIsVolunteer"] as! Bool
        let eventParticipantValidationStatus = eventObjects[indexPath.row]["status"] as! String
        
        createAlertForHandlingEventParticipantValidation(initiatorTypeIsVolunteer, _eventParticipantValidationStatus: eventParticipantValidationStatus, _eventParticipantValidationEvent: eventObjects[indexPath.row]["event"] as! String)
    }
    
    func loadData() {
        let ORGANIZATION = "organization"
        
        let objects = eventObjects
        
        for object in objects {
            if object[ORGANIZATION] as? PFUser == PFUser.currentUser() {
                
                let query = PFQuery(className: "Event")
                query.getObjectInBackgroundWithId(object["event"] as! String) {
                    (event: PFObject?, error: NSError?) -> Void in
                    if error == nil && event != nil {
                        self.eventArray.append(event!)
                        self.tableview.reloadData()
                    } else {
                        print("Error = ",error)
                    }
                }
                

            }
        }
        
//        if tableview != nil {
//            print("not nil")
//        } else {
//            print("nil")
//        }
    }
    
    func createAlertForHandlingEventParticipantValidation(_initiatorTypeIsVolunteer: Bool, _eventParticipantValidationStatus: String, _eventParticipantValidationEvent: String) {
        print("okay")
        
        if _initiatorTypeIsVolunteer {
            
            print("true")
            
            if _eventParticipantValidationStatus == "pending" {
                //confirm, decline
                let alert = UIAlertController(title: "Alert", message: "Would you like to accept this request?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
                    
                    let currentEvent = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                    currentEvent.whereKey(self.EVENT_ID, equalTo: _eventParticipantValidationEvent)
                    currentEvent.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        if error == nil && objects != nil {
                            objects![0][self.STATUS] = self.ACCEPTED
                            objects![0][self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                            objects![0].saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // The object has been saved.
                                    print("success")
                                    
                                    let event = PFQuery(className: self.EVENT_CLASS)
                                    event.getObjectInBackgroundWithId(_eventParticipantValidationEvent) {
                                        (event: PFObject?, error: NSError?) -> Void in
                                        if error == nil && event != nil {
                                            print("this event", event)
                                            
                                            //add person to volunteers list
                                            //check if volunteers array exists
                                            if (event!.valueForKey(self.VOLUNTEERS) != nil) {
                                                print("not nil")
                                                
                                                let currentVolunteer = self.volunteerObject
                                                currentVolunteer!.addObject(self.volunteerObject.objectId!, forKey: self.VOLUNTEERS)
                                                event?.saveInBackgroundWithBlock {
                                                    (success: Bool, error: NSError?) -> Void in
                                                    if (success) {
                                                        // The object has been saved.
                                                        print("success")
                                                        self.navigationController?.popToRootViewControllerAnimated(true)
                                                    } else {
                                                        // There was a problem, check error.description
                                                        print(error)
                                                    }
                                                }
                                                
                                                
                                            } else {
                                                print("nil")
                                                event![self.VOLUNTEERS] = [String]()
                                                let currentVolunteer = self.volunteerObject
                                                event![self.VOLUNTEERS].addObject(currentVolunteer!)
                                                event?.saveInBackgroundWithBlock {
                                                    (success: Bool, error: NSError?) -> Void in
                                                    if (success) {
                                                        // The object has been saved.
                                                        print("success")
                                                        self.navigationController?.popToRootViewControllerAnimated(true)
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
                                } else {
                                    // There was a problem, check error.description
                                    print(error)
                                }
                            }
                        } else {
                            print(error)
                        }
                    }

                    
                
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)

            } else if _eventParticipantValidationStatus == "confirmed" {
                //cancel
                let alert = UIAlertController(title: "Alert", message: "Would you like to remove this volunteer?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
                    
                    let currentEvent = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                    currentEvent.whereKey(self.EVENT_ID, equalTo: _eventParticipantValidationEvent)
                    currentEvent.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        if error == nil && objects != nil {
                            objects![0][self.STATUS] = self.DECLINED
                            objects![0][self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                            objects![0].saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // The object has been saved.
                                    print("success")
                                    let event = PFQuery(className: self.EVENT_CLASS)
                                    event.getObjectInBackgroundWithId(_eventParticipantValidationEvent) {
                                        (event: PFObject?, error: NSError?) -> Void in
                                        if error == nil && event != nil {
                                            print("this event", event)
                                            
                                            //add person to volunteers list
                                            //check if volunteers array exists
                                            if (event!.valueForKey(self.VOLUNTEERS) != nil) {
                                                print("not nil")
                                                
                                                let currentVolunteer = self.volunteerObject
                                                event![self.VOLUNTEERS].removeObject(currentVolunteer!)
                                                event?.saveInBackgroundWithBlock {
                                                    (success: Bool, error: NSError?) -> Void in
                                                    if (success) {
                                                        // The object has been saved.
                                                        print("success")
                                                        self.navigationController?.popToRootViewControllerAnimated(true)
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
                                                        self.navigationController?.popToRootViewControllerAnimated(true)
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
                                } else {
                                    print(error)
                                }
                    
                            }
                        }
                    }
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else if _eventParticipantValidationStatus == "declined" {
                //invite
                
                let alert = UIAlertController(title: "Alert", message: "Would you like invite this person to be a volunteer?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
                    
                    let currentEvent = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                    currentEvent.whereKey(self.EVENT_ID, equalTo: _eventParticipantValidationEvent)
                    currentEvent.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        if error == nil && objects != nil {
                            objects![0][self.STATUS] = self.PENDING
                            objects![0][self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                            objects![0].saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // The object has been saved.
                                    print("success")
                                    self.navigationController?.popToRootViewControllerAnimated(true)

                                }
                            }
                        }
                    }
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Alert", message: "Would you like reinvite this person to be a volunteer?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
                    
                    let currentEvent = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                    currentEvent.whereKey(self.EVENT_ID, equalTo: _eventParticipantValidationEvent)
                    currentEvent.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        if error == nil && objects != nil {
                            objects![0][self.STATUS] = self.PENDING
                            objects![0][self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                            objects![0].saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // The object has been saved.
                                    print("success")
                                    self.navigationController?.popToRootViewControllerAnimated(true)
                                    
                                }
                            }
                        }
                    }
                    
                    
                }))
            }
            
        } else {
            print("false")
            
            if _eventParticipantValidationStatus == "pending" {
                //confirm, decline
                let alert = UIAlertController(title: "Alert", message: "Would you like to cancel this request?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
                    
                    let currentEvent = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                    currentEvent.whereKey(self.EVENT_ID, equalTo: _eventParticipantValidationEvent)
                    currentEvent.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        if error == nil && objects != nil {
                            objects![0][self.STATUS] = self.DECLINED
                            objects![0][self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                            objects![0].saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // The object has been saved.
                                    print("success")
                                    self.navigationController?.popToRootViewControllerAnimated(true)

                                }
                            }
                        }
                    }

                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else if _eventParticipantValidationStatus == self.ACCEPTED {
                //cancel
                let alert = UIAlertController(title: "Alert", message: "Would you like to remove this volunteer?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
                    
                    let currentEvent = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                    currentEvent.whereKey(self.EVENT_ID, equalTo: _eventParticipantValidationEvent)
                    currentEvent.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        if error == nil && objects != nil {
                            objects![0][self.STATUS] = self.DECLINED
                            objects![0][self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                            objects![0].saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // The object has been saved.
                                    print("success")
                                    
                                    let event = PFQuery(className: self.EVENT_CLASS)
                                    event.getObjectInBackgroundWithId(_eventParticipantValidationEvent) {
                                        (event: PFObject?, error: NSError?) -> Void in
                                        if error == nil && event != nil {
                                            print("this event", event)
                                            
                                            //add person to volunteers list
                                            //check if volunteers array exists
                                            if (event!.valueForKey(self.VOLUNTEERS) != nil) {
                                                print("not nil")
                                                
                                                let currentVolunteer = self.volunteerObject
                                                event![self.VOLUNTEERS].removeObject(currentVolunteer!)
                                                event?.saveInBackgroundWithBlock {
                                                    (success: Bool, error: NSError?) -> Void in
                                                    if (success) {
                                                        // The object has been saved.
                                                        print("success")
                                                        self.navigationController?.popToRootViewControllerAnimated(true)
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
                                                        self.navigationController?.popToRootViewControllerAnimated(true)
                                                    } else {
                                                        // There was a problem, check error.description
                                                        print(error)
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }))
                        
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else if _eventParticipantValidationStatus == "declined" {
                //invite
                
                let alert = UIAlertController(title: "Alert", message: "Would you like reinvite this person to be a volunteer?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
                    
                    let currentEvent = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                    currentEvent.whereKey(self.EVENT_ID, equalTo: _eventParticipantValidationEvent)
                    currentEvent.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        if error == nil && objects != nil {
                            objects![0][self.STATUS] = self.PENDING
                            objects![0][self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                            objects![0].saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // The object has been saved.
                                    print("success")
                                    self.navigationController?.popToRootViewControllerAnimated(true)

                                }
                            }
                        }
                    }

                    
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Alert", message: "Would you like reinvite this person to be a volunteer?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
                    
                    let currentEvent = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                    currentEvent.whereKey(self.EVENT_ID, equalTo: _eventParticipantValidationEvent)
                    currentEvent.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        if error == nil && objects != nil {
                            objects![0][self.STATUS] = self.PENDING
                            objects![0][self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                            objects![0].saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // The object has been saved.
                                    print("success")
                                    self.navigationController?.popToRootViewControllerAnimated(true)
                                    
                                }
                            }
                        }
                    }
                    
                    
                }))
            }

        }
        
    }
    
}
