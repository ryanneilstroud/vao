//
//  SummaryVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 12/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class SummaryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var profileButtonTag : Int = 0
    let vcTitlesArray = ["Projects","Events","Reviews"]
    
    //opportunitiesCell info
    let titlesArray = ["Indigo","World Vision"]
    let eventImages = [UIImage(named: "event0.jpg")!, UIImage(named: "event1.jpg")]
    
    let project = "Axiom"
    let projectImage = UIImage(named: "axiom.jpg")!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if profileButtonTag == 0 {
            return 1
        } else if profileButtonTag == 1 {
            return titlesArray.count
        } else {
            return 3
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if profileButtonTag == 0 {
            var cell : OpportuntiesCell!
            
            let nib = UINib(nibName:"OpportunitiesCell", bundle: nil);
            
            tableView.rowHeight = 160
            tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
            cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
            cell.refreshCellWithOpportunityData(project, dateAndTime: "", location: "", summary: "", picture: projectImage)
            return cell
        } else if profileButtonTag == 1 {
            var cell : OpportuntiesCell!
            
            let nib = UINib(nibName:"OpportunitiesCell", bundle: nil);
            
            tableView.rowHeight = 160
            tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
            cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
            cell.refreshCellWithOpportunityData(titlesArray[indexPath.row], dateAndTime: "", location: "", summary: "", picture: eventImages[indexPath.row]!)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSLog("profileButtonTag = %d", profileButtonTag)
        navigationItem.title = vcTitlesArray[profileButtonTag]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
