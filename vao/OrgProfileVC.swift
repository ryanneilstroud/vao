//
//  OrgProfileVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 17/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class OrgProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var profilePic : UIImage!
    var orgNumberOfProjects : Int!
    var orgNumberOfEvents : Int!
    var orgRatingScore : Double!
    
    let about = [
        ("location", "Hong Kong"),
        ("languages", "English"),
        ("type", "project"),
        ("tags", "youth worker, outgoing, Christian, committed")
    ]
    
    let iconImagesArray = [UIImage(named: "ion-ios-telephone-outline_256_0_c3c3c3_none.png"), UIImage(named: "ion-ios-email-outline_256_0_c3c3c3_none.png"), UIImage(named: "ion-ios-world-outline_256_0_c3c3c3_none.png")]
    let iconLabelArray = ["555 1234", "axiomyouth@gmail.com", "www.axiom.com"]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 4
        } else {
            return 3
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let nib = UINib(nibName:"ProfileSummary", bundle: nil);
            
            tableView.rowHeight = 100
            tableView.registerNib(nib, forCellReuseIdentifier: "summary")
            let cell : AttributeValueCells! = tableView.dequeueReusableCellWithIdentifier("summary", forIndexPath: indexPath) as! AttributeValueCells
            cell.selectionStyle = .None
            
            cell.projectsButton.addTarget(self, action: "checkButtonClick:", forControlEvents: .TouchUpInside)
            cell.eventsButton.addTarget(self, action: "checkButtonClick:", forControlEvents: .TouchUpInside)
            cell.ratingsButton.addTarget(self, action: "checkButtonClick:", forControlEvents: .TouchUpInside)
            
            cell.refreshProfileSummaryCellWithData(profilePic, userProjectCount: orgNumberOfProjects, userEventCount: orgNumberOfEvents, userRating: orgRatingScore)
            
            return cell
        } else if indexPath.section == 1 {
            tableView.rowHeight = 50
            let nib = UINib(nibName: "AttributeValue", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "details")
            let cell = tableView.dequeueReusableCellWithIdentifier("details", forIndexPath: indexPath) as! AttributeValueCells
            cell.selectionStyle = .None
            
            let (attr, value) = about[indexPath.row]
            cell.refreshProfileAboutCellWithData(attr, attributeValue: value)
            
            return cell
        } else {
            let nib = UINib(nibName:"IconLabelCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            tableView.rowHeight = 50
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IconLabelCell
            cell.selectionStyle = .None
            
            cell.refreshCellWithData(iconImagesArray[indexPath.row]!, text: iconLabelArray[indexPath.row])
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1{
            return "about"
        } else {
            return "contact"
        }
    }
    
    func checkButtonClick(sender:UIButton!) {
        let vc = SummaryVC(nibName:"Summary", bundle: nil)
        vc.profileButtonTag = sender.tag
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        navigationItem.title = "Axiom"
        
        profilePic = UIImage(named: "axiom_logo.jpg")
        orgNumberOfProjects = 10
        orgNumberOfEvents = 5
        orgRatingScore = 8.5
    }

}
