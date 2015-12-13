//
//  OpportunitesDetailVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 11/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class OpportunitiesDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var event = EventClass()
    var orgInvited = false
    
    @IBOutlet var requestIntivationButton: UIButton!
    var screenRect : CGRect = UIScreen.mainScreen().bounds

    let name = [
        ("host", "Axiom"),
    ]
    
    //opportunitiesCell info
    let titlesArray = ["Axiom","Indigo","World Vision"]
    let eventImages = [UIImage(named: "axiom.jpg")!, UIImage(named: "event0.jpg")!, UIImage(named: "event1.jpg")]
    
    let buttonTextArray = ["see friends going","join"]

    var timeAndDate = [String]()
    
    let timeAndDateIcons = [UIImage(named: "ion-ios-calendar-outline_256_0_c3c3c3_none.png")!,
                                UIImage(named: "ion-ios-clock-outline_256_0_c3c3c3_none.png")!,
                                UIImage(named:"pe-7s-repeat_256_0_c3c3c3_none.png")]
    
    var location = ""
    var locationGeoPoints: CLLocationCoordinate2D?
    
    let locationIcon = UIImage(named: "ion-ios-location-outline_256_0_c3c3c3_none.png")
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    @IBAction func handleVolunteerInvitation(sender: AnyObject) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        }
        
        else if indexPath.section == 4 {
            var cell : IconLabelCell!
            let nib = UINib(nibName:"IconLabelCell", bundle: nil)
            
            tableView.rowHeight = 40
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IconLabelCell
            cell.selectionStyle = .None
            
            cell.refreshCellWithData(UIImage(named: "ion-ios-pricetag-outline_256_0_c3c3c3_none.png")!, text: "outgoing, friendly, committed")
            
            return cell
        }
        else {
            
            var cell : GenericLabelTextviewCell!
            
            tableView.rowHeight = 100
            
            let nib = UINib(nibName: "GenericLabelTextviewCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "textviewCell")
            
            cell = tableView.dequeueReusableCellWithIdentifier("textviewCell", forIndexPath: indexPath) as! GenericLabelTextviewCell
            cell.selectionStyle = .None

            cell.refreshCellWithTextviewText(event.summary!)
            
            return cell
        }
        
//        else if indexPath.section == 6 {
//            var cell : SimpleButtonCell!
//            
//            let nib = UINib(nibName:"SimpleButtonCell", bundle: nil)
//            
//            tableView.rowHeight = 40
//            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
//            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SimpleButtonCell
////            cell.selectionStyle = .None
//
//            cell.refreshCellWithButtonData(buttonTextArray[0])
//            
//            return cell
//        } else {
//            var cell : SimpleButtonCell!
//            
//            let nib = UINib(nibName:"SimpleButtonCell", bundle: nil)
//            
//            tableView.rowHeight = 40
//            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
//            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SimpleButtonCell
//            cell.selectionStyle = .None
//            
////            cell.basicButton.addTarget(self, action: "handleEventParticipantValidation:", forControlEvents: UIControlEvents.TouchUpInside)
//
//            var buttonText = ""
//            
//            if orgInvited == true {
//                buttonText = "accept invitation"
//            } else {
//                buttonText = buttonTextArray[1]
//            }
//            cell.refreshCellWithButtonData(buttonText)
//            
//            return cell
//        }
    }
    
    func handleEventParticipantValidation(_button: UIButton) {
        print("tapped")
        
        let EVENT_PARTICIPANT_VALIDATION = "EventParticipantValidation"
        let VOLUNTEER = "volunteer"
        let ORGANIZATION = "organization"
        let EVENT = "event"
        
        let user = PFUser.currentUser()
        
        let volunteerQuery = PFQuery(className: EVENT_PARTICIPANT_VALIDATION)
        volunteerQuery.whereKey(VOLUNTEER, equalTo: user!)
        
        let organizationQuery = PFQuery(className: EVENT_PARTICIPANT_VALIDATION)
        organizationQuery.whereKey(ORGANIZATION, equalTo: event.createdBy)
        
        let eventQuery = PFQuery(className: EVENT_PARTICIPANT_VALIDATION)
        eventQuery.whereKey(EVENT, equalTo: event.objectId)
        
        let query = PFQuery.orQueryWithSubqueries([volunteerQuery, organizationQuery, eventQuery])
        query.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // results contains players with lots of wins or only a few wins.
                print("results = ",results)
                if results?.count == 0 {
                    let eventParticipantValidation = PFObject(className: EVENT_PARTICIPANT_VALIDATION)
                    
                    if user!["userTypeIsVolunteer"] as! Bool {
                        eventParticipantValidation[VOLUNTEER] = user!
                        eventParticipantValidation["status"] = "pending"
                        eventParticipantValidation[ORGANIZATION] = self.event.createdBy
                        eventParticipantValidation["event"] = self.event.objectId
                        eventParticipantValidation["initiatorTypeIsVolunteer"] = true
            
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
                        print("false")
                    }
                } else {
                    
                }
            } else {
                print("error = ",error)
            }
        }
        
    }
    
    func createAlert() {
    
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
        if indexPath.section == 6 {
            let user = PFUser.currentUser()
            if !PFFacebookUtils.isLinkedWithUser(user!) {
                PFFacebookUtils.linkUserInBackground(user!, withReadPermissions: nil, block: {
                    (succeeded: Bool?, error: NSError?) -> Void in
                    if succeeded == true {
                        print("Woohoo, the user is linked with Facebook!")
                    } else {
                        print(error)
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

