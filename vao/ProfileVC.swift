//
//  ProfileVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 5/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class ProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    var profilePic : UIImage?
    var userNumberOfProjects : Int!
    var userNumberOfEvents : Int!
    var userRatingScore : Double!
    
    var orgIsViewing = false
    var volObject: PFObject!
    
    var eventIds = [String]()
    var projectIds = [String]()
    
    var didReload: Bool!
    
    var tableview: UITableView!
    
    let data = [
        ("gender", "male"),
        ("age", "22"),
        ("religion", "Christian")
    ]
    
    let iconImagesArray = [UIImage(named: "ion-ios-telephone-outline_256_0_c3c3c3_none.png"), UIImage(named: "ion-ios-email-outline_256_0_c3c3c3_none.png")]
    var iconLabelArray = ["", ""]
    
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
            return iconImagesArray.count;
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableview = tableView
        
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

            if profilePic != nil {
                cell.refreshProfileSummaryCellWithData(profilePic!, userProjectCount: userNumberOfProjects, userEventCount: userNumberOfEvents, userRating: userRatingScore)
            } else {
                cell.refreshProfileSummaryCellWithData(userNumberOfProjects, userEventCount: userNumberOfEvents, userRating: userRatingScore)
            }
            
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
            let nib = UINib(nibName:"IconLabelCell", bundle: nil);
            
            tableView.rowHeight = 50
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IconLabelCell;
            
            cell.refreshCellWithData(iconImagesArray[indexPath.row]!, text: iconLabelArray[indexPath.row])
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
        
        if sender.tag == 0 {
            vc.objectIds = projectIds
            vc.target = 0
        } else if sender.tag == 1 {
            vc.objectIds = eventIds
            vc.target = 1
        } else {
            
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 3 {
            if indexPath.row == 0 {
                UIApplication.sharedApplication().openURL(NSURL(string:"telprompt:" + iconLabelArray[0])!)
            } else if indexPath.row == 1 {
                let email = iconLabelArray[1]
                let url = NSURL(string: "mailto:\(email)")
                UIApplication.sharedApplication().openURL(url!)
            }
        }
    }
    
    func getUserData() {
        
        if orgIsViewing == true {
            iconLabelArray[0] = volObject["phoneNumber"] as! String
            iconLabelArray[1] = volObject["email"] as! String
            
            let userImageFile = volObject["orgImage"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.profilePic = UIImage(data:imageData)
                        
                        self.tableview.reloadData()
                    }
                }
            }
            
        } else {
            let volunteer = PFUser.currentUser()
            
            navigationItem.title = volunteer!["fullName"] != nil ? volunteer!["fullName"] as! String : ""
            
            iconLabelArray[0] = volunteer!["phoneNumber"] != nil ? volunteer!["phoneNumber"] as! String : ""
            iconLabelArray[1] = volunteer!["email"] != nil ? volunteer!["email"] as! String : ""
            
            let userImageFile = volunteer!["orgImage"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.profilePic = UIImage(data:imageData)
                        
                        self.tableview.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        didReload = false

        userNumberOfProjects = 0
        userNumberOfEvents = 0
        userRatingScore = 0
        
    }
    
    override func viewDidAppear(animated: Bool) {
        getUserData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}