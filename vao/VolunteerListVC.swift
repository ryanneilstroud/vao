//
//  VolunteerListVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 17/12/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class VolunteerListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let VOLUNTEERS = "volunteers"
    
    var eventObject: PFObject!
    var volunteerObjects = [PFObject]()
    
    var tableview: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        
        tableview = tableView
        return volunteerObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let nib = UINib(nibName: "VolunteersCell", bundle: nil)
        
        tableView.rowHeight = 100
        tableView.registerNib(nib, forCellReuseIdentifier: "volunteer")
        
        let cell : VolunteersTVC = tableView.dequeueReusableCellWithIdentifier("volunteer", forIndexPath: indexPath) as! VolunteersTVC
        
        cell.refreshCellWithVolunteer(volunteerObjects[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = ProfileVC(nibName:"ProfileView", bundle: nil)
        vc.orgIsViewing = true
        vc.volObject = volunteerObjects[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        getVolunteers()
    }
    
    func getVolunteers() {
        
        if eventObject != nil {
            if eventObject[VOLUNTEERS].count > 0 {
                let count = eventObject[VOLUNTEERS].count - 1
                for volunteer in 0...count {
                    let volunteerUser = PFUser.query()
                    let volunteerId = eventObject[VOLUNTEERS][volunteer]
                    volunteerUser?.getObjectInBackgroundWithId(volunteerId as! String) {
                        (user: PFObject?, error: NSError?) -> Void in
                        if error == nil {
                            print(user)
                            print("getVolunteers")
                            self.volunteerObjects.append(user!)
                            self.tableview.reloadData()
                        }
                    }
                }
            } else {
                let alert = UIAlertController(title: "Alert", message: "There are currently no volunteers", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "There are currently no volunteers", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}
