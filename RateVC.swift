//
//  RateVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 18/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class RateVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let nib = UINib(nibName:"OpportunitiesCell", bundle: nil);
            tableView.rowHeight = 160
            tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
            
            let cell: OpportuntiesCell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
            
            return cell
        } else if indexPath.section == 1 {
            
            let nib = UINib(nibName: "ScoreCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "scoreCell")
            tableView.rowHeight = 100
            
            let cell = tableView.dequeueReusableCellWithIdentifier("scoreCell", forIndexPath: indexPath) as! RateCell
            cell.selectionStyle = .None
            
            return cell
        } else if indexPath.section == 2 {
            
            let nib = UINib(nibName: "CommentCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "commentCell")
            tableView.rowHeight = 200
            
            let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! RateCell
            cell.selectionStyle = .None

            cell.manageTextView()
            
            return cell
        } else {
            let nib = UINib(nibName: "FullButtonCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "buttonCell")
            tableView.rowHeight = 50
            
            let cell = tableView.dequeueReusableCellWithIdentifier("buttonCell", forIndexPath: indexPath) as! RateCell
            cell.selectionStyle = .None

            cell.manageButton()
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (indexPath.section)
            {
            case 0:
                print("indexPath.section = %d", indexPath.section)
                let vc = OpportunitiesDetailVC(nibName:"OpportunitiesDetailVC", bundle: nil)
                navigationController?.pushViewController(vc, animated: true)
                
            default:
                print("indexPath.section = %d", indexPath.section)
            }
    }
    
    override func viewDidLoad() {
        navigationItem.title = "Review"
    }
    
}
