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
    
    @IBOutlet var editButton: UIBarButtonItem!
    
    let ORGANIZATION = "organization"
    let EVENT_CLASS = "Event"
    let CREATED_BY = "createdBy"
    
    var eventObjects = [PFObject]()
    
    var tableview: UITableView!
    
    @IBAction func dismissEventsVC(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func enterDeleteMode(sender: AnyObject) {
        if tableview.editing {
            tableview.editing = false
            editButton.title = "Edit"
        } else {
            tableview.editing = true
            editButton.title = "Done"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableview = tableView
        
        return eventObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        
        let nib = UINib(nibName: "OpportunitiesCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
        tableView.rowHeight = 160
        
        let cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
        
        cell.refreshCellWithObject(eventObjects[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView.editing == true {
            let vc = NewEventVC(nibName:"TableView", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = OpportunitiesDetailVC(nibName:"OpportunitiesDetailVC", bundle: nil)
            vc.objectEvent = eventObjects[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alert = UIAlertController(title: "Warning!", message: "Are you sure you want to delete this event? This cannot be undone.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { action in
                if Reachability.isConnectedToNetwork() {
                    self.eventObjects[indexPath.row].deleteInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The post has been added to the user's likes relation.
                            let deleteAlert = UIAlertController(title: "Deleted!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                            self.presentViewController(deleteAlert, animated: true, completion: nil)
                            
                            let delay = 0.5 * Double(NSEC_PER_SEC)
                            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            dispatch_after(time, dispatch_get_main_queue(), {
                                deleteAlert.dismissViewControllerAnimated(true, completion: {(Bool) in
                                    self.tableview.editing = false
                                    self.eventObjects.removeAtIndex(indexPath.row)
                                    tableView.reloadData()
                                })
                            })
                            
                        } else {
                            // There was a problem, check error.description
                            let alert = UIAlertController(title: "Error: " + String(error?.code), message: error?.description, preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "Internet Not Found", message: "We can't seem to connect to the Internet. Please double check your connection.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    func loadData() {

        let organizationsEvents = PFQuery(className: EVENT_CLASS)
        organizationsEvents.whereKey(CREATED_BY, equalTo: PFUser.currentUser()!)
        organizationsEvents.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil {
                // There was an error
                print(objects)
                print("hello!")
                
                for object in objects! {
                    self.eventObjects.append(object)
                    self.tableview.reloadData()
                }
                
            } else {
                // objects has all the Posts the current user liked.
                print(error)
            }
        }
        
    }
    
//    override func viewDidLoad() {
//        loadData()
//    }
    
    override func viewDidAppear(animated: Bool) {
        loadData()
    }
    
}
