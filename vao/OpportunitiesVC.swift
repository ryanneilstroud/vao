//
//  OpportunitiesVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 5/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse
import MapKit

class OpportunitiesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let STORYBOARD_NAME_VOL = "Main"
    let STORYBOARD_NAME_ORG = "Organizations"
    let VC_IDENTIFIER = "mainScreen"
    
    @IBOutlet var tableview: UITableView!
    
    var myBool = false
    var screenRect : CGRect = UIScreen.mainScreen().bounds
    
    var picker : UIPickerView! = UIPickerView()
    let array = ["recent", "upcoming", "recommended", "bookmarked", "my opportunities"]
    
    var eventsArray = [EventClass]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : OpportuntiesCell!

        let nib = UINib(nibName:"OpportunitiesCell", bundle: nil);
        
        tableView.rowHeight = 160
        tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
        cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
        cell.refreshCellWithOpportunityData(eventsArray[indexPath.row].title!,
                                    date: eventsArray[indexPath.row].date!,
                                    time: eventsArray[indexPath.row].time!,
                                    frequency: eventsArray[indexPath.row].frequency!,
                                    location: eventsArray[indexPath.row].locationName!,
                                    summary: eventsArray[indexPath.row].summary!,
                                    picture: eventsArray[indexPath.row].eventImage!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = OpportunitiesDetailVC(nibName:"OpportunitiesDetailVC", bundle: nil)
        vc.event = eventsArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadEvents() {
        let query = PFQuery(className: "Event")
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                print(error)
            } else {
                for object in objects! {
                    
                    let event = EventClass()
                    event.setTitle(object["title"] as! String)
                    event.setDate(object["date"] as! NSDate)
                    event.setTime(object["time"] as! NSDate)
                    event.setSummary(object["summary"] as! String)
                    event.setFrequency(object["frequency"] as! String)
                    
                    event.locationName = object["locationName"] as? String
                    let loc = object["location"] as? PFGeoPoint
                    
                    let latitude: CLLocationDegrees = loc!.latitude
                    let longtitude: CLLocationDegrees = loc!.longitude
                    
                    let newLoc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                    event.location = newLoc

                    event.createdBy = object["createdBy"] as! PFUser
                                        
                    if let userImageFile = object["eventImage"] as? PFFile {
                        print("good!")
                        userImageFile.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                if let imageData = imageData {
                                    event.setEventImage(UIImage(data:imageData)!)
                                    self.eventsArray.append(event)
                                    self.tableview.reloadData()
                                }
                            }
                        }
                    } else {
                        event.setEventImage(UIImage(named: "pe-7s-user_256_0_606060_none.png")!)
                        self.eventsArray.append(event)
                        self.tableview.reloadData()
                    }
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //checked to see if logged in
        
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
            var storyboardName : String
            let userType = currentUser!["userTypeIsVolunteer"] as! Int
            
            if userType == 0 {
                storyboardName = self.STORYBOARD_NAME_ORG
                let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier(self.VC_IDENTIFIER) as UIViewController
                self.presentViewController(vc, animated: true, completion: nil)
            } else {
                loadEvents()
            }
            
            
        } else {
            // Show the signup or login screen
            let nib = CredentialsVC(nibName:"LogIn", bundle: nil) as CredentialsVC
            self.presentViewController(nib, animated: true, completion: nil)
            
        }
    }
    
}