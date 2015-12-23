//
//  TabVolunteersVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 17/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class TabVolunteersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var volunteers = [PFObject]()
    var tableview: UITableView!
        
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        tableview = tableView
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return volunteers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let nib = UINib(nibName: "VolunteersCell", bundle: nil)
        
        tableView.rowHeight = 100
        tableView.registerNib(nib, forCellReuseIdentifier: "volunteer")
        
        let cell : VolunteersTVC = tableView.dequeueReusableCellWithIdentifier("volunteer", forIndexPath: indexPath) as! VolunteersTVC
                
        cell.refreshCellWithVolunteer(volunteers[indexPath.row])
        
        return cell
    }
    
    @IBAction func createEvent(sender: AnyObject) {
        let vc = NewEventVC(nibName:"TableView", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = ProfileVC(nibName:"ProfileView", bundle: nil)
        vc.orgIsViewing = true
        vc.volObject = volunteers[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getVolunteerData() {
        let query = PFUser.query()
        query?.whereKey("userTypeIsVolunteer", equalTo: true)
        query?.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                // There was an error
                print(error)
            } else {
                // objects has all the Posts the current user liked.
                for object in objects! {
                    self.volunteers.append(object)
                }
                
                self.tableview.reloadData()
                
            }
        }
    }
    
    override func viewDidLoad() {
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
            getVolunteerData()
        } else {
            // Show the signup or login screen
            let nib = CredentialsVC(nibName:"LogIn", bundle: nil) as CredentialsVC
            self.presentViewController(nib, animated: true, completion: nil)
            
        }
    }
}
