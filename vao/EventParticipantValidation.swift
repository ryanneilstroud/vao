//
//  EventParticipantValidation.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 13/12/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class EventParticipantValidation {

    let EVENT_PARTICIPANT_VALIDATION = "EventParticipantValidation"
    let EVENT_ID = "event"
    let VOLUNTEER = "volunteer"
    let ORGANIZATION = "organization"
    let INITIATOR_TYPE_IS_VOLUNTEER = "initiatorTypeIsVolunteer"
    
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
    
    var buttonText = ""
    var buttonControlState = UIControlState.Normal
    
    //methods for volunteers
    
    //should come from Opportunity Detail View Controller
    func loadStatusOfEventParticipantForVolunteer(_eventId: String, _eventCreatedBy: PFUser) {
        
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
                            self.buttonText = self.CANCEL_REQUEST
                            
                        } else if eventParticipantValidationStatus == self.PENDING {
                            //if confirmed (cancel)
                            print("confirmed")
                            self.buttonText = self.LEAVE_EVENT
                            
                        }
                    } else {
                        //initiatorTypeIsVolunteer is FALSE
                        print(self.INITIATOR_TYPE_IS_VOLUNTEER, eventObject![self.INITIATOR_TYPE_IS_VOLUNTEER] as! Bool)
                        if eventParticipantValidationStatus == self.PENDING {
                            //if pending (confirm, decline)
                            print("pending")
                            self.buttonText = self.ACCEPT_REQUEST
                            
                        } else if eventParticipantValidationStatus == self.ACCEPTED {
                            //if confirmed (cancel)
                            print("confirmed")
                            self.buttonText = self.LEAVE_EVENT
                            
                        } else if eventParticipantValidationStatus == self.DECLINED {
                            //if declined (cannot request again)[email them to find out why]
                            print("declined")
                            self.buttonText = self.VOLUNTEER_DECLINED
                            self.buttonControlState = UIControlState.Disabled
                        }
                    }
                }
            } else {
                print("event_query_error: ", error)
                self.buttonText = self.JOIN_EVENT
            }
        }
    }
    
    func handleStatusOfEventParticipantForVolunteer() {
        
    }
    
    //methods for organizations
    
    
    
    
    //NO RESULT FOUND (create connection)
    
    //create object
    //        let newConnection = PFObject(className: self.EVENT_PARTICIPANT_VALIDATION)
    //        newConnection[self.VOLUNTEER] = PFUser.currentUser()
    //        newConnection[self.ORGANIZATION] = _eventCreatedBy
    //        newConnection[STATUS] = PENDING
    //        newConnection[INITIATOR_TYPE_IS_VOLUNTEER] = true
    //        newConnection[EVENT_ID] = _eventId
    
    //organization, volunteer, event, initiatorTypeIsVolunteer, STATUS
    
    //saveInBackground
    
    //change button text

}
