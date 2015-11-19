//
//  OrgEventsVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 19/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class OrgEventsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //opportunitiesCell info
    let titlesArray = ["Axiom","Indigo","World Vision"]
    let eventImages = [UIImage(named: "axiom.jpg")!, UIImage(named: "event0.jpg")!, UIImage(named: "event1.jpg")]

    
    @IBAction func dismissEventsVC(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let nib = UINib(nibName: "OpportunitiesCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
        tableView.rowHeight = 160
        
        let cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
        cell.refreshCellWithOpportunityData(titlesArray[indexPath.row], dateAndTime: "", location: "", summary: "", picture: eventImages[indexPath.row]!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
