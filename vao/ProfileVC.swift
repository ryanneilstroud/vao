//
//  ProfileVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 5/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    var profilePic : UIImage!
    var userNumberOfProjects : Int!
    var userNumberOfEvents : Int!
    var userRatingScore : Double!
    
    var orgIsViewing = false
    
    let data = [
        ("gender", "male"),
        ("age", "22"),
        ("religion", "Christian")
    ]
    
    let contact = [
        ("phone", "5631 2729"),
        ("email", "ryanstroud75@gmail.com")
    ]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if orgIsViewing {
            return 5
        } else {
            return 4
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return data.count
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return contact.count;
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell : AttributeValueCells!
            let nib = UINib(nibName:"ProfileSummary", bundle: nil);
            
            tableView.rowHeight = 100
            tableView.registerNib(nib, forCellReuseIdentifier: "summary")
            cell = tableView.dequeueReusableCellWithIdentifier("summary", forIndexPath: indexPath) as! AttributeValueCells;
            cell.selectionStyle = .None
            
            cell.projectsButton.addTarget(self, action: "checkButtonClick:", forControlEvents: .TouchUpInside)
            cell.eventsButton.addTarget(self, action: "checkButtonClick:", forControlEvents: .TouchUpInside)
            cell.ratingsButton.addTarget(self, action: "checkButtonClick:", forControlEvents: .TouchUpInside)

            cell.refreshProfileSummaryCellWithData(profilePic, userProjectCount: userNumberOfProjects, userEventCount: userNumberOfEvents, userRating: userRatingScore)
            
            return cell
        } else if indexPath.section == 1 {
            var cell : AttributeValueCells!
            let nib = UINib(nibName:"AttributeValue", bundle: nil);

            tableView.rowHeight = 50
            tableView.registerNib(nib, forCellReuseIdentifier: "details")
            cell = tableView.dequeueReusableCellWithIdentifier("details", forIndexPath: indexPath) as! AttributeValueCells;
            cell.selectionStyle = .None

            let (attr, value) = data[indexPath.row]
            cell.refreshProfileAboutCellWithData(attr, attributeValue: value)
            
            return cell
        } else if indexPath.section == 2 {
            var cell : TextviewCell
            let nib = UINib(nibName:"TextviewCell", bundle: nil);
            
            tableView.rowHeight = 50
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TextviewCell;
            cell.selectionStyle = .None
            
            return cell
        } else if indexPath.section == 3 {
            var cell : AttributeValueCells!
            let nib = UINib(nibName:"AttributeValue", bundle: nil);
            
            tableView.rowHeight = 50
            tableView.registerNib(nib, forCellReuseIdentifier: "details")
            cell = tableView.dequeueReusableCellWithIdentifier("details", forIndexPath: indexPath) as! AttributeValueCells;
            let (attr, value) = contact[indexPath.row]
            cell.refreshProfileAboutCellWithData(attr, attributeValue: value)
            return cell
        } else {
            var cell : SimpleButtonCell!
            let nib = UINib(nibName:"SimpleButtonCell", bundle: nil);
            
            tableView.rowHeight = 50
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SimpleButtonCell;
            cell.refreshCellWithButtonData("invite to event")
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 {
            return "about"
        } else if section == 2 {
            return "skills"
        } else {
            return "contact"
        }
    }
    
    func checkButtonClick(sender:UIButton!) {
        let vc = SummaryVC(nibName:"Summary", bundle: nil)
        vc.profileButtonTag = sender.tag
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 3 {
            if indexPath.row == 0 {
                UIApplication.sharedApplication().openURL(NSURL(string:"telprompt:56312729")!)
            } else if indexPath.row == 1 {
                let email = "foo@bar.com"
                let url = NSURL(string: "mailto:\(email)")
                UIApplication.sharedApplication().openURL(url!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.title = "Ryan Neil Stroud"
        
        profilePic = UIImage(named: "1.jpg")
        userNumberOfProjects = 10
        userNumberOfEvents = 5
        userRatingScore = 8.5
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}