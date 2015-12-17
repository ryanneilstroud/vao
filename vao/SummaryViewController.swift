//
//  SummaryVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 12/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class SummaryViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableview: UITableView!
    
    var objectIds: [String]!
    var ratingObjects = [PFObject]()
    var target = 0
    
    var parseObjects = [PFObject]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableview = tableView
        
        if target == 0 || target == 1 {
            if parseObjects.count != 0 {
                return parseObjects.count
            } else {
                return 0
            }
        } else if target == 2 {
            if ratingObjects.count != 0 {
                return ratingObjects.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if target == 0 || target == 1 {
        
            var cell : OpportuntiesCell!
        
            let nib = UINib(nibName:"OpportunitiesCell", bundle: nil);
        
            tableView.rowHeight = 160
            tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
            cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
            cell.refreshCellWithObject(parseObjects[indexPath.row])
        
            return cell
        } else {
            var cell : RatedCell!
            
            let nib = UINib(nibName:"RatedCell", bundle: nil);
            
            tableView.rowHeight = 90
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RatedCell
            cell.refreshCellWithObject(ratingObjects[indexPath.row])
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if target == 0 || target == 1 {
            let vc = OpportunitiesDetailVC(nibName:"OpportunitiesDetailVC", bundle: nil)
            vc.objectEvent = parseObjects[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        } else {
            
        }
    }
    
    override func viewDidLoad() {
        
        if target == 0 || target == 1 {
        
            for objectId in objectIds! {
                let objects = PFQuery(className: "Event")
                objects.getObjectInBackgroundWithId(objectId) {
                    (_object: PFObject?, error: NSError?) -> Void in
                    if error == nil && _object != nil {
                        print(_object)
                        self.parseObjects.append(_object!)
                        self.tableview.reloadData()
                    } else {
                        print(error)
                    }
                }
            }
        }
    }
    
}