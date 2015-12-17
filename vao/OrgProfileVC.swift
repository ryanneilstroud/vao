//
//  OrgProfileVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 17/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class OrgProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var profilePic : UIImage?
    var orgNumberOfProjects : Int!
    var orgNumberOfEvents : Int!
    var orgRatingScore : Double!
    
    var orgId = ""
    
    var eventIds = [String]()
    var projectIds = [String]()
    
    var reviewsObjects = [PFObject]()
    
    var tableview: UITableView!
    
    var didReload: Bool!
    
    let about = ["location","languages"]
    var labelValueArray = ["",""]
//        ("tags", "youth worker, outgoing, Christian, committed")
    
    
    let iconImagesArray = [UIImage(named: "ion-ios-telephone-outline_256_0_c3c3c3_none.png"), UIImage(named: "ion-ios-email-outline_256_0_c3c3c3_none.png"), UIImage(named: "ion-ios-world-outline_256_0_c3c3c3_none.png")]
    var iconLabelArray = ["", "", ""]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableview = tableView
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return about.count
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
            
            if profilePic != nil {
                cell.refreshProfileSummaryCellWithData(profilePic!, userProjectCount: orgNumberOfProjects, userEventCount: orgNumberOfEvents, userRating: orgRatingScore)
            } else {
                cell.refreshProfileSummaryCellWithData(orgNumberOfProjects, userEventCount: orgNumberOfEvents, userRating: orgRatingScore)
            }
            
            return cell
        } else if indexPath.section == 1 {
            tableView.rowHeight = 50
            let nib = UINib(nibName: "AttributeValue", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "details")
            let cell = tableView.dequeueReusableCellWithIdentifier("details", forIndexPath: indexPath) as! AttributeValueCells
            cell.selectionStyle = .None
            
            cell.refreshProfileAboutCellWithData(about[indexPath.row], attributeValue: labelValueArray[indexPath.row])
            
            return cell
        } else {
            let nib = UINib(nibName:"IconLabelCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            tableView.rowHeight = 50
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IconLabelCell
            
            cell.refreshCellWithData(iconImagesArray[indexPath.row]!, text: iconLabelArray[indexPath.row])
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                UIApplication.sharedApplication().openURL(NSURL(string:"telprompt:" + iconLabelArray[0])!)
            } else if indexPath.row == 1 {
                let email = iconLabelArray[1]
                let url = NSURL(string: "mailto:\(email)")
                UIApplication.sharedApplication().openURL(url!)
            } else if indexPath.row == 2 {
                print("hello")
                UIApplication.sharedApplication().openURL(NSURL(string: "http://" + iconLabelArray[2])!)
            }
        }
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
        
        let vc = SummaryViewController(nibName:"TableView", bundle: nil)
        
        if sender.tag == 0 {
            vc.objectIds = projectIds
            vc.target = 0
        } else if sender.tag == 1 {
            vc.objectIds = eventIds
            vc.target = 1
        } else {
            vc.ratingObjects = reviewsObjects
            vc.target = 2
        }
        
        navigationController?.pushViewController(vc, animated: true)

    }
    
    func getOrgData() {
        
        let query = PFUser.query()
        query!.getObjectInBackgroundWithId(orgId) {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil && object != nil {
                print("object -> ", object)
                self.getCurrentUserData(object!)
            } else {
                print(error)
            }            
        }
    }
    
    func getCurrentUserData(organization: PFObject) {
        
        navigationItem.title = organization["fullName"] != nil ? organization["fullName"] as! String : ""
        
        iconLabelArray[0] = organization["phoneNumber"] != nil ? organization["phoneNumber"] as! String : ""
        iconLabelArray[1] = organization["email"] != nil ? organization["email"] as! String : ""
        iconLabelArray[2] = organization["website"] != nil ? organization["website"] as! String : ""
        
        labelValueArray[0] = organization["location"] != nil ? organization["location"] as! String : ""
        labelValueArray[1] = organization["languages"] != nil ? organization["languages"] as! String : ""
        
        let userImageFile = organization["orgImage"] as! PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    self.profilePic = UIImage(data:imageData)
                    
                    self.tableview.reloadData()
                }
            }
        }
        
        let eventsQuery = PFQuery(className: "Event")
        eventsQuery.whereKey("createdBy", equalTo: organization)
        eventsQuery.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects {
                    
                    self.eventIds.removeAll()
                    self.projectIds.removeAll()

                    for object in objects {
                        print(object.objectId)
                        if object["frequency"] as! String == "don't repeat" {
                            self.eventIds.append(object.objectId!)
                            self.orgNumberOfEvents = self.eventIds.count
                        } else {
                            self.projectIds.append(object.objectId!)
                            self.orgNumberOfProjects = self.projectIds.count
                        }
                    }
                    self.tableview.reloadData()
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        let reviewsQuery = PFQuery(className: "Review")
        reviewsQuery.whereKey("organization", equalTo: PFUser.currentUser()!)
        reviewsQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil {
                // There was an error
                print("reviews: ", objects)
                
                self.reviewsObjects.removeAll()

                var ratingArray = [Double]()

                for review in objects! {
                    if review["reviewerIsVolunteer"] as! Bool {
                        self.reviewsObjects.append(review)
                        ratingArray.append(review["rating"] as! Double)
                    }
                }
                
                var orgScore = Double()
                
                for score in ratingArray {
                    orgScore += score
                }
                
                self.orgRatingScore = orgScore / Double(ratingArray.count)
                self.tableview.reloadData()
                
            } else {
                // objects has all the Posts the current user liked.
                print(error)
            }
        }
    }
    
    func getData() {        
        orgNumberOfProjects = 0
        orgNumberOfEvents = 0
        orgRatingScore = 0
        
        if orgId == "" {
            getCurrentUserData(PFUser.currentUser()!)
        } else {
            getOrgData()
        }
    }
    
    override func viewDidLoad() {
        getData()
    }
    
    override func viewDidAppear(animated: Bool) {
        getData()
    }

}
