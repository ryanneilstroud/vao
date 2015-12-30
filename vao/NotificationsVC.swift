//
//  NotificationsVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 18/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class NotificationsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let NOTIFICATION_TYPE_POINTER_AT = "notificationTypePointerId"
    
    let UPDATED_AT = "updatedAt"
    
    let NOTIFICATION_CLASS = "Notification"
    let RECEIVER = "receiver"
    let NOTIFICATION_TYPE = "type"
    
    let TYPE_REVIEW = "review"
    
    let USER_TYPE_IS_VOLUNTEER = "userTypeIsVolunteer"
    let INITIATOR_TYPE_IS_VOLUNTEER = "initiatorTypeIsVolunteer"
    
    let EVENT_PARTICIPANT_VALIDATION = "EventParticipantValidation"
    let EVENT_CLASS = "Event"
    let STATUS = "status"
    let PENDING = "pending"
    let DECLINED = "declined"
    let ACCEPTED = "accepted"
    let VOLUNTEER = "volunteer"
    
    let ORGANIZATION = "organization"
    
    let EVENT_ID = "event"
    
    let EVENT_IMAGE = "eventImage"
    
//    let notificationsArray = ["Indigo Studios has approved your request!", "You have been invited by Axiom to be a volunteer!", "Congratulations! You finished volunteering at Indigo Studios. Rate their event!"]
//    let notificationsImageArray = [UIImage(named: "axiom_logo.jpg")!, UIImage(named: "axiom_logo.jpg"), UIImage(named: "axiom_logo.jpg")]
    var notifications = [PFObject]()
    var organizations = [PFObject]()
    var events = [PFObject]()
    var eventParticipantValidations = [PFObject]()
    
    var tableview: UITableView!
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableview = tableView
        
        return notifications.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("notifications = ", notifications)
        
        if notifications[indexPath.row][self.NOTIFICATION_TYPE] as! String != self.TYPE_REVIEW {
            let nib = UINib(nibName: "NotificationsCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            tableView.rowHeight = 100
            let cell: NotificationsCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NotificationsCell
            
            let status = eventParticipantValidations[indexPath.row][self.STATUS] as! String
            let initiatorIsVolunteer = eventParticipantValidations[indexPath.row][self.INITIATOR_TYPE_IS_VOLUNTEER] as! Bool
            
            if status == self.PENDING && !initiatorIsVolunteer {
                cell.refreshNotificationsCellWithData(organizations[indexPath.row]["orgImage"] as? PFFile, _text: String(organizations[indexPath.row]["fullName"]) + " invited you to " + String(events[indexPath.row]["title"]))
            } else if status == self.ACCEPTED && !initiatorIsVolunteer {
                cell.refreshNotificationsCellWithData(organizations[indexPath.row]["orgImage"] as? PFFile, _text: String(organizations[indexPath.row]["fullName"]) + " accepted your request to join " + String(events[indexPath.row]["title"]))
            } else if status == self.DECLINED && !initiatorIsVolunteer {
                cell.refreshNotificationsCellWithData(organizations[indexPath.row]["orgImage"] as? PFFile, _text: String(organizations[indexPath.row]["fullName"]) + " declined your request to join " + String(events[indexPath.row]["title"]))
            } else if status == self.PENDING && initiatorIsVolunteer {
                cell.refreshNotificationsCellWithData(organizations[indexPath.row]["orgImage"] as? PFFile, _text: "Waiting to hear back from " + String(organizations[indexPath.row]["fullName"]) + " about " + String(events[indexPath.row]["title"]))
            } else if status == self.ACCEPTED && initiatorIsVolunteer {
                cell.refreshNotificationsCellWithData(organizations[indexPath.row]["orgImage"] as? PFFile, _text: String(organizations[indexPath.row]["fullName"]) + " accepted your request to join " + String(events[indexPath.row]["title"]))
            } else if status == self.DECLINED && initiatorIsVolunteer {
                cell.refreshNotificationsCellWithData(organizations[indexPath.row]["orgImage"] as? PFFile, _text: String(organizations[indexPath.row]["fullName"]) + " declined your request to join " + String(events[indexPath.row]["title"]))
            }
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            formatter.timeStyle = .ShortStyle
            
            let dateString = formatter.stringFromDate(notifications[indexPath.row].updatedAt!)
            
            cell.dateLabel.text = dateString
            
            return cell
        } else {
            
            let nib = UINib(nibName: "NotificationsCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            tableView.rowHeight = 100
            let cell: NotificationsCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NotificationsCell
            
            cell.refreshNotificationsCellWithData(organizations[indexPath.row]["orgImage"] as? PFFile, _text: "You can now review " + String(organizations[indexPath.row]["fullName"]) + " and their event, " + String(events[indexPath.row]["title"]))
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            formatter.timeStyle = .ShortStyle
            
            let dateString = formatter.stringFromDate(notifications[indexPath.row].updatedAt!)
            
            cell.dateLabel.text = dateString
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if notifications[indexPath.row][self.NOTIFICATION_TYPE] as! String == self.TYPE_REVIEW {
            let vc = RateVC(nibName:"RateView", bundle: nil)
            vc.eventObject = events[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = OpportunitiesDetailVC(nibName:"OpportunitiesDetailVC", bundle: nil)
            vc.objectEvent = events[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func getNotifications() {
        
        print("getting notifications")
        let notificationQuery = PFQuery(className: NOTIFICATION_CLASS)
        notificationQuery.whereKey(RECEIVER, equalTo: PFUser.currentUser()!)
        notificationQuery.orderByAscending("updatedAt")
        notificationQuery.findObjectsInBackgroundWithBlock {
            (notifications: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if notifications!.count != 0 {
                    
                    self.organizations.removeAll()
                    self.events.removeAll()
                    self.eventParticipantValidations.removeAll()
                    self.notifications.removeAll()
                    self.tableview.reloadData()
                    
                    for notification in notifications! {
                        let eventParticipantValidations = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                        eventParticipantValidations.orderByAscending("updatedAt")
                        eventParticipantValidations.getObjectInBackgroundWithId(notification[self.NOTIFICATION_TYPE_POINTER_AT] as! String) {
                            (eventParticipantValidation: PFObject?, error: NSError?) -> Void in
                            if error == nil {
                                
                                print(notification)
                                print(eventParticipantValidation)
                                
                                let events = PFQuery(className: self.EVENT_CLASS)
                                events.orderByAscending("updatedAt")
                                events.getObjectInBackgroundWithId(eventParticipantValidation![self.EVENT_ID] as! String) {
                                    (event: PFObject?, error: NSError?) -> Void in
                                    if error == nil {
                                        
                                        print(event)
                                        let creator = event!["createdBy"].objectId!
                                        
                                        let orgs = PFUser.query()
                                        orgs?.getObjectInBackgroundWithId(creator!) {
                                            (org: PFObject?, error: NSError?) -> Void in
                                            if error == nil {
                                                self.organizations.append(org!)
                                                self.events.append(event!)
                                                self.eventParticipantValidations.append(eventParticipantValidation!)
                                                self.notifications.append(notification)
                                                self.tableview.reloadData()
                                            } else {
                                                print(error)
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
            } else {
                print(error)
            }
        
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        getNotifications()
    }
    
}
