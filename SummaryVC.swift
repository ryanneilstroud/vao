//
//  SummaryVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 12/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class SummaryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var target : Int = 0
    var objectIds = [String]()
    let vcTitlesArray = ["Projects","Events","Reviews"]
    
    var objects = [PFObject]()
    
    var didReload = false
    
    //opportunitiesCell info
    let titlesArray = ["Indigo","World Vision"]
    let eventImages = [UIImage(named: "event0.jpg")!, UIImage(named: "event1.jpg")]
    
    let project = "Axiom"
    let projectImage = UIImage(named: "axiom.jpg")!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if didReload == false {
            didReload = true
            getUserData(tableView)
        }
        
        return objects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if target == 0 {
            navigationItem.title = "Projects"
            var cell : OpportuntiesCell!
            
            let nib = UINib(nibName:"OpportunitiesCell", bundle: nil);
            
            tableView.rowHeight = 160
            tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
            cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
//            cell.refreshCellWithOpportunityData(project, dateAndTime: NSDate(), location: "", summary: "", picture: projectImage)
            cell.refreshCellWithObject(objects[indexPath.row])
            return cell
        } else if target == 1 {
            navigationItem.title = "Events"
            var cell : OpportuntiesCell!
            
            let nib = UINib(nibName:"OpportunitiesCell", bundle: nil);
            
            tableView.rowHeight = 160
            tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
            cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
//            cell.refreshCellWithOpportunityData(titlesArray[indexPath.row], dateAndTime: NSDate(), location: "", summary: "", picture: eventImages[indexPath.row]!)
            cell.refreshCellWithObject(objects[indexPath.row])
            return cell

        } else {
            var cell : RatedCell!
            
            let nib = UINib(nibName:"RatedCell", bundle: nil);
            
            tableView.rowHeight = 100
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RatedCell
            return cell
        }
    }
    
    func getUserData(tableview: UITableView) {
        print("test")
        for objectId in objectIds {
            let query = PFQuery(className: "Event")
            query.getObjectInBackgroundWithId(objectId) {
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil && object != nil {
                    print(object)
                    self.objects.append(object!)
                    tableview.reloadData()
                    print("refreshed")
                } else {
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        NSLog("profileButtonTag = %d", profileButtonTag)
//        navigationItem.title = vcTitlesArray[profileButtonTag]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
