//
//  OrgHandleEventInvites.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 15/12/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class OrgHandlesEventInvites: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let NOTIFICATION_CLASS = "Notification"
    let RECEIVER = "receiver"
    let SENDER = "sender"
    let NOTIFICATION_TYPE = "type"
    let IS_READ = "isRead"
    
    let TYPE_EVENT_PARTICIPANT_VALIDATION = "eventParticipantValidation"
    let TYPE_REVIEW = "review"
    let EVENT_PARTICIPANT_VALIDATION = "EventParticipantValidation"
    let EVENT_ID = "event"
    let VOLUNTEER = "volunteer"
    let VOLUNTEERS = "volunteers"
    let ORGANIZATION = "organization"
    let INITIATOR_TYPE_IS_VOLUNTEER = "initiatorTypeIsVolunteer"
    let NOTIFICATION_TYPE_POINTER_ID = "notificationTypePointerId"
    let NOTIFICATION_POINTER = "notifcationPointer"
    
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
    
    var tableview: UITableView!
    
    var eventValidationObjects = [PFObject]()
    var volunteerObject: PFObject!
    
    var inviteSectionEvents = [PFObject]()
    var invitedSectionEvents = [PFObject]()
    var requestedSectionEvents = [PFObject]()
    var acceptedSectionEvents = [PFObject]()
    var declinedSectionEvents = [PFObject]()
    
    var didReload = true
    
    override func viewDidLoad() {
        print("viewDidLoad")
        loadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("numberOfSectionsInTableView")
        
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        tableview = tableView
        
        if section == 0 {
            return requestedSectionEvents.count
        } else if section == 1 {
            return invitedSectionEvents.count
        } else if section == 2 {
            return inviteSectionEvents.count
        } else if section == 3 {
            return acceptedSectionEvents.count
        } else if section == 4 {
            return declinedSectionEvents.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath")
        
        if indexPath.section == 0 {
            let nib = UINib(nibName: "OpportunitiesCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
            tableView.rowHeight = 160
            
            let cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
            cell.accessoryType = .None
            cell.refreshCellWithObject(requestedSectionEvents[indexPath.row])
            
            return cell
        } else if indexPath.section == 1 {
            let nib = UINib(nibName: "OpportunitiesCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
            tableView.rowHeight = 160
            
            let cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
            cell.accessoryType = .None
            cell.refreshCellWithObject(invitedSectionEvents[indexPath.row])
            
            return cell
        } else if indexPath.section == 2 {
            let nib = UINib(nibName: "OpportunitiesCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
            tableView.rowHeight = 160
            
            let cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
            cell.accessoryType = .None
            cell.refreshCellWithObject(inviteSectionEvents[indexPath.row])
            
            return cell
        } else if indexPath.section == 3 {
            let nib = UINib(nibName: "OpportunitiesCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
            tableView.rowHeight = 160
            
            let cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
            cell.accessoryType = .None
            cell.refreshCellWithObject(acceptedSectionEvents[indexPath.row])
            
            return cell
        } else if indexPath.section == 4 {
            let nib = UINib(nibName: "OpportunitiesCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
            tableView.rowHeight = 160
            
            let cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
            cell.accessoryType = .None
            cell.refreshCellWithObject(declinedSectionEvents[indexPath.row])
            
            return cell
        } else {
            let nib = UINib(nibName: "OpportunitiesCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
            tableView.rowHeight = 160
            
            let cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
            cell.accessoryType = .None
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if requestedSectionEvents.count != 0 {
                return "requested"
            } else {
                return nil
            }
        } else if section == 1 {
            if invitedSectionEvents.count != 0 {
                return "invited"
            } else {
                return nil
            }
        } else if section == 2 {
            if inviteSectionEvents.count != 0 {
                return "invite"
            } else {
                return nil
            }
        } else if section == 3 {
            if acceptedSectionEvents.count != 0 {
                return "accepted"
            } else {
                return nil
            }
        } else if section == 4 {
            if declinedSectionEvents.count != 0 {
                return "declined"
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if requestedSectionEvents.count != 0 {
                return 32
            } else {
                return 1
            }
        } else if section == 1 {
            if invitedSectionEvents.count != 0 {
                return 32
            } else {
                return 1
            }
        } else if section == 2 {
            if inviteSectionEvents.count != 0 {
                return 32
            } else {
                return 1
            }
        } else if section == 3 {
            if acceptedSectionEvents.count != 0 {
                return 32
            } else {
                return 1
            }
        } else if section == 4 {
            if declinedSectionEvents.count != 0 {
                return 32
            } else {
                return 1
            }
        } else {
            return 0
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            createAlertForHandlingEventParticipantValidation(indexPath.section, _event: requestedSectionEvents[indexPath.row])
        } else if indexPath.section == 1 {
            createAlertForHandlingEventParticipantValidation(indexPath.section, _event: invitedSectionEvents[indexPath.row])
        } else if indexPath.section == 2 {
            createAlertForHandlingEventParticipantValidation(indexPath.section, _event: inviteSectionEvents[indexPath.row])
        } else if indexPath.section == 3 {
            createAlertForHandlingEventParticipantValidation(indexPath.section, _event: acceptedSectionEvents[indexPath.row])
        } else if indexPath.section == 4 {
            createAlertForHandlingEventParticipantValidation(indexPath.section, _event: declinedSectionEvents[indexPath.row])
        }
    }
    
    func createAlertForHandlingEventParticipantValidation(_section: Int, _event: PFObject) {
        
        if _section == 0 {
            
            print("SECTION 0")
            
            let alert = UIAlertController(title: "Alert", message: "Would you like to accept this persons request to join this event?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Decline", style: UIAlertActionStyle.Destructive, handler: { action in
                let validation = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                validation.whereKey(self.EVENT_ID, equalTo: _event.objectId!)
                validation.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil && objects != nil {
                        print("object: ",objects)
                        
                        objects![0][self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                        objects![0][self.STATUS] = self.DECLINED
                        objects![0].saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                // The object has been saved.
                                self.setNotification(objects![0], _notficationType: self.TYPE_EVENT_PARTICIPANT_VALIDATION, _dismiss: true)

                            } else {
                                // There was a problem, check error.description
                                print(error)
                            }
                        }
                        
                    } else {
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }

            }))
            alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default, handler: { action in
                let validation = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                validation.whereKey(self.EVENT_ID, equalTo: _event.objectId!)
                validation.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil && objects != nil {
                        print("object: ",objects)
                        
                        objects![0][self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                        objects![0][self.STATUS] = self.ACCEPTED
                        objects![0].saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                // The object has been saved.
                                
                                if(_event.valueForKey(self.VOLUNTEERS) != nil) {
                                    _event.addObject(self.volunteerObject.objectId!, forKey: self.VOLUNTEERS)
                                    _event.saveInBackgroundWithBlock {
                                        (success: Bool, error: NSError?) -> Void in
                                        if (success) {
                                            self.setNotification(objects![0], _notficationType: self.TYPE_EVENT_PARTICIPANT_VALIDATION, _dismiss: false)
                                            self.setNotification(objects![0], _notficationType: self.TYPE_REVIEW, _dismiss: true)

                                            
                                            //SET REVIEW HEAR
                                            //ONE FOR YOU
                                            //ONE FOR ME
                                        } else {
                                            print(error)
                                        }
                                    }
                                }
                            } else {
                                // There was a problem, check error.description
                                print(error)
                            }
                        }
                        
                    } else {
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }

            }))
            self.presentViewController(alert, animated: true, completion: nil)
        } else if _section == 1 {
            let alert = UIAlertController(title: "Alert", message: "Would you like to uninvite this person from this event?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Uninvite", style: UIAlertActionStyle.Default, handler: { action in
                let validation = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                validation.whereKey(self.EVENT_ID, equalTo: _event.objectId!)
                validation.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil && objects != nil {
                        print("object: ",objects)
                        
                        objects![0][self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                        objects![0][self.STATUS] = self.DECLINED
                        objects![0].saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                // The object has been saved.
                                
                                if(_event.valueForKey(self.VOLUNTEERS) != nil) {
                                    _event.removeObject(self.volunteerObject.objectId!, forKey: self.VOLUNTEERS)
                                    _event.saveInBackgroundWithBlock {
                                        (success: Bool, error: NSError?) -> Void in
                                        if (success) {
                                            self.setNotification(objects![0], _notficationType: self.TYPE_EVENT_PARTICIPANT_VALIDATION, _dismiss: true)
                                        } else {
                                            
                                        }
                                    }
                                }
                            } else {
                                // There was a problem, check error.description
                                print(error)
                            }
                        }
                        
                    } else {
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        } else if _section == 2 {
            let alert = UIAlertController(title: "Alert", message: "Would you like invite this person to this event?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Invite", style: UIAlertActionStyle.Default, handler: { action in
                let validation = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                validation.whereKey(self.EVENT_ID, equalTo: _event.objectId!)
                validation.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil && objects != nil {
                        print("object: ",objects)
                        
                        if objects!.count == 0 {
                            print("we're in")
                            let eventParticipantClass = PFObject(className: self.EVENT_PARTICIPANT_VALIDATION)
                            eventParticipantClass[self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                            eventParticipantClass[self.ORGANIZATION] = PFUser.currentUser()
                            eventParticipantClass[self.VOLUNTEER] = self.volunteerObject
                            eventParticipantClass[self.STATUS] = self.PENDING
                            eventParticipantClass[self.EVENT_ID] = _event.objectId
                            eventParticipantClass.saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    
                                    let val = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                                    val.whereKey(self.EVENT_ID, equalTo: _event.objectId!)
                                    val.findObjectsInBackgroundWithBlock {
                                        (valObject: [PFObject]?, error: NSError?) -> Void in
                                        if error == nil {
                                            print(valObject![0].objectId)
                                            self.setNotification(valObject![0], _notficationType: self.TYPE_EVENT_PARTICIPANT_VALIDATION, _dismiss: true)
                                        } else {
                                            print(error)
                                        }
                                    }

                                } else {
                                    print(error)
                                }
                            }
                        } else {
                            objects![0][self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                            objects![0][self.STATUS] = self.PENDING
                            objects![0].saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // The object has been saved.
                                    self.setNotification(objects![0], _notficationType: self.TYPE_EVENT_PARTICIPANT_VALIDATION, _dismiss: true)
                                } else {
                                    // There was a problem, check error.description
                                    print(error)
                                }
                            }
                        }
                        
                    } else {
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }

            }))
            self.presentViewController(alert, animated: true, completion: nil)
        } else if _section == 3 {
            let alert = UIAlertController(title: "Alert", message: "Would you like to remove this person from this event?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Remove", style: UIAlertActionStyle.Default, handler: { action in
                let validation = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                validation.whereKey(self.EVENT_ID, equalTo: _event.objectId!)
                validation.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil && objects != nil {
                        print("object: ",objects)
                        
                        objects![0][self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                        objects![0][self.STATUS] = self.DECLINED
                        objects![0].saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                // The object has been saved.
                                
                                if(_event.valueForKey(self.VOLUNTEERS) != nil) {
                                    _event.removeObject(self.volunteerObject.objectId!, forKey: self.VOLUNTEERS)
                                    _event.saveInBackgroundWithBlock {
                                        (success: Bool, error: NSError?) -> Void in
                                        if (success) {
                                            self.setNotification(objects![0], _notficationType: self.TYPE_EVENT_PARTICIPANT_VALIDATION, _dismiss: true)
                                        } else {
                                            
                                        }
                                    }
                                }
                            } else {
                                // There was a problem, check error.description
                                print(error)
                            }
                        }
                        
                    } else {
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }

            }))
            self.presentViewController(alert, animated: true, completion: nil)
        } else if _section == 4 {
            let alert = UIAlertController(title: "Alert", message: "Would you like to reinvite this person to become a volunteer?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Reinvite", style: UIAlertActionStyle.Default, handler: { action in
                let validation = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                validation.whereKey(self.EVENT_ID, equalTo: _event.objectId!)
                validation.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil && objects != nil {
                        print("object: ",objects)
                        
                        objects![0][self.INITIATOR_TYPE_IS_VOLUNTEER] = false
                        objects![0][self.STATUS] = self.PENDING
                        objects![0].saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                // The object has been saved.
                                self.setNotification(objects![0], _notficationType: self.TYPE_EVENT_PARTICIPANT_VALIDATION, _dismiss: true)

                            } else {
                                // There was a problem, check error.description
                                print(error)
                            }
                        }
                        
                    } else {
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }

            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func loadData() {
        let events = PFQuery(className: EVENT_CLASS)
        events.whereKey("createdBy", equalTo: PFUser.currentUser()!)
        events.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil {
                
                print("MY OBJECTS: ",objects)
                
                let validation = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                validation.whereKey(self.ORGANIZATION, equalTo: PFUser.currentUser()!)
                validation.findObjectsInBackgroundWithBlock {
                    (vObjects: [PFObject]?, vError: NSError?) -> Void in
                    if vError == nil && vObjects != nil {
                        
                        for object in objects! {
                            var isAVObject = false
                            for vObject in vObjects! {
                                
                                if vObject[self.EVENT_ID] as! String == object.objectId! && vObject[self.VOLUNTEER] as! PFUser == self.volunteerObject {
                                    let validationStatus = vObject[self.STATUS] as! String
                                    
                                    if vObject[self.INITIATOR_TYPE_IS_VOLUNTEER] as! Bool {
                                        if validationStatus == self.PENDING {
                                            //requested
                                            self.requestedSectionEvents.append(object)
                                            print("requested: ", self.requestedSectionEvents)
                                        } else if validationStatus == self.ACCEPTED {
                                            //accepted
                                            self.acceptedSectionEvents.append(object)
                                            print("accepted: ", self.acceptedSectionEvents)
                                        } else if validationStatus == self.DECLINED {
                                            //invite
                                            self.inviteSectionEvents.append(object)
                                            print("invite: ", self.inviteSectionEvents)
                                        } else {
                                            //invite
                                            self.inviteSectionEvents.append(object)
                                            print("invite: ", self.inviteSectionEvents)
                                        }
                                    } else {
                                        if validationStatus == self.PENDING {
                                            //invited
                                            print("invited: ", self.invitedSectionEvents)
                                            self.invitedSectionEvents.append(object)
                                        } else if validationStatus == self.ACCEPTED {
                                            //accepted
                                            self.acceptedSectionEvents.append(object)
                                            print("accepted: ", self.acceptedSectionEvents)
                                        } else if validationStatus == self.DECLINED {
                                            //declined
                                            self.declinedSectionEvents.append(object)
                                            print("declined: ", self.declinedSectionEvents)
                                        } else {
                                            //invite
                                            self.inviteSectionEvents.append(object)
                                            print("invite: ", self.inviteSectionEvents)
                                        }
                                    }
                                    isAVObject = true
                                    self.tableview.reloadData()
                                }
                            }
                            
                            if isAVObject == false {
                                self.inviteSectionEvents.append(object)
                                self.tableview.reloadData()
                            }
                            
                        }
                    } else {
                        print("vError: \(vError!) \(vError!.userInfo)")
                        for object in objects! {
                            self.inviteSectionEvents.append(object)
                        }
                        self.tableview.reloadData()
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
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
                    print("creating new")
                    let notificationId2 = PFObject(className: self.NOTIFICATION_CLASS)
                    notificationId2[self.NOTIFICATION_TYPE_POINTER_ID] = _object.objectId
                    notificationId2[self.IS_READ] = false
                    notificationId2[self.RECEIVER] = PFUser.currentUser()
                    notificationId2[self.SENDER] = _object[self.VOLUNTEER]
                    notificationId2[self.NOTIFICATION_TYPE] = _notficationType
                    notificationId2.saveInBackground()
                    
                    let notificationId = PFObject(className: self.NOTIFICATION_CLASS)
                    notificationId[self.NOTIFICATION_TYPE_POINTER_ID] = _object.objectId
                    notificationId[self.IS_READ] = false
                    notificationId[self.RECEIVER] = _object[self.VOLUNTEER]
                    notificationId[self.SENDER] = PFUser.currentUser()
                    notificationId[self.NOTIFICATION_TYPE] = _notficationType
                    notificationId.saveInBackgroundWithBlock {
                        (success: Bool?, saveError: NSError?) -> Void in
                        if success != nil {
                            if _dismiss {
                                self.navigationController?.popViewControllerAnimated(true)
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
                                self.navigationController?.popViewControllerAnimated(true)
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
                notificationId2[self.SENDER] = _object[self.VOLUNTEER]
                notificationId2[self.NOTIFICATION_TYPE] = _notficationType
                notificationId2.saveInBackground()
                
                print("creating new")
                let notificationId = PFObject(className: self.NOTIFICATION_CLASS)
                notificationId[self.NOTIFICATION_TYPE_POINTER_ID] = _object.objectId
                notificationId[self.IS_READ] = false
                notificationId[self.RECEIVER] = _object[self.VOLUNTEER]
                notificationId[self.SENDER] = PFUser.currentUser()
                notificationId[self.NOTIFICATION_TYPE] = _notficationType
                notificationId.saveInBackgroundWithBlock {
                    (success: Bool?, saveError: NSError?) -> Void in
                    if success != nil {
                        if _dismiss {
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    }
                }
            }
        }
    }
    
}
