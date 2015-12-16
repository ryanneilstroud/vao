//
//  OrgNotificationsVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 16/12/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

//
//  NotificationsVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 18/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class OrgNotificationsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let USER_TYPE_IS_VOLUNTEER = "userTypeIsVolunteer"
    
    let EVENT_PARTICIPANT_VALIDATION = "EventParticipantValidation"
    let EVENT_CLASS = "Event"
    let STATUS = "status"
    let ACCEPTED = "accepted"
    let VOLUNTEER = "volunteer"
    let ORGANIZATION = "organization"
    
    let EVENT_ID = "event"
    
    let ORG_IMAGE = "orgImage"
    
    //    let notificationsArray = ["Indigo Studios has approved your request!", "You have been invited by Axiom to be a volunteer!", "Congratulations! You finished volunteering at Indigo Studios. Rate their event!"]
    var notificationsArray = [PFObject]()
    var acceptedVolunteers = [PFObject]()
    var eventVolunterIsAccepted = [PFObject]()
    
    var tableview: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableview = tableView
        
        return acceptedVolunteers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let nib = UINib(nibName: "NotificationsCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 100
        let cell: NotificationsCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NotificationsCell
        
        cell.refreshNotificationsCellWithData(acceptedVolunteers[indexPath.row][ORG_IMAGE] as? PFFile, _text: "Congratulations! You finished volunteering at Indigo Studios. Rate their event!")
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = RateVC(nibName:"RateView", bundle: nil)
        vc.eventObject = eventVolunterIsAccepted[indexPath.row]
        vc.volunteer = acceptedVolunteers[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
        //        if indexPath.row == 0 {
        //            let vc = OpportunitiesDetailVC(nibName:"OpportunitiesDetailVC", bundle: nil)
        ////            vc.event = indexPath.row
        //            navigationController?.pushViewController(vc, animated: true)
        //        } else if indexPath.row == 1 {
        //            let vc = OpportunitiesDetailVC(nibName:"OpportunitiesDetailVC", bundle: nil)
        ////            vc.event = indexPath.row
        //            vc.orgInvited = true
        //            navigationController?.pushViewController(vc, animated: true)
        //        } else {
        
        //        }
        //        NSLog("selected notification index = %d", indexPath.row)
    }
    
    func getNotifications() {
        
        if PFUser.currentUser()![USER_TYPE_IS_VOLUNTEER] as! Bool == false {
            
            //see which events a org is hosting
            let volunteersEvent = PFQuery(className: EVENT_PARTICIPANT_VALIDATION)
            volunteersEvent.whereKey(ORGANIZATION, equalTo: PFUser.currentUser()!)
            volunteersEvent.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if objects != nil && error == nil {
                    print(objects)
                    
                    //see which events a volunteer is ACCEPTED to
                    let eventParticpantValidation = PFQuery(className: self.EVENT_PARTICIPANT_VALIDATION)
                    eventParticpantValidation.whereKey(self.STATUS, equalTo: self.ACCEPTED)
                    eventParticpantValidation.findObjectsInBackgroundWithBlock {
                        (vObjects: [PFObject]?, vError: NSError?) -> Void in
                        if vError == nil {
                            
                            for vObject in vObjects! {
                                if vObject[self.STATUS] as! String == self.ACCEPTED {
                                    
                                    print("vObject: ", vObject)
                                    
                                    self.acceptedVolunteers.append(vObject[self.VOLUNTEER] as! PFObject)
                                    self.tableview.reloadData()
                                    
//                                    let getVolunteerObjects = PFQuery(className: self.EVENT_CLASS)
//                                    getVolunteerObjects.getObjectInBackgroundWithId(vObject[VOLUNTEER].objectId as! String) {
//                                    
//                                    }
                                    
                                    let getEventObjects = PFQuery(className: self.EVENT_CLASS)
                                    getEventObjects.getObjectInBackgroundWithId(vObject[self.EVENT_ID] as! String) {
                                        (event: PFObject?, eError: NSError?) -> Void in
                                        if eError == nil && event != nil {
                                            self.eventVolunterIsAccepted.append(event!)
                                            
                                            self.tableview.reloadData()
                                        } else {
                                            print(eError)
                                        }
                                    }
                                    
                                }
                            }
                            
                        } else {
                            print(vError)
                        }
                    }
                } else {
                    print(error)
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        getNotifications()
    }
    
}
