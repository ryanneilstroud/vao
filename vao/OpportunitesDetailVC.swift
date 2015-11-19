//
//  OpportunitesDetailVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 11/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class OpportunitiesDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var objectId = 0
    var orgInvited = false
    
    @IBOutlet var requestIntivationButton: UIButton!
    var screenRect : CGRect = UIScreen.mainScreen().bounds

    let name = [
        ("host", "Axiom"),
    ]
    
    //opportunitiesCell info
    let titlesArray = ["Axiom","Indigo","World Vision"]
    let eventImages = [UIImage(named: "axiom.jpg")!, UIImage(named: "event0.jpg")!, UIImage(named: "event1.jpg")]
    
    let buttonTextArray = ["see friends going","join"]

    let timeAndDate = ["Friday, 13 November","6:00pm to 10:00pm","every week"]
    let timeAndDateIcons = [UIImage(named: "ion-ios-calendar-outline_256_0_c3c3c3_none.png")!,
                                UIImage(named: "ion-ios-clock-outline_256_0_c3c3c3_none.png")!,
                                UIImage(named:"pe-7s-repeat_256_0_c3c3c3_none.png")]
    
    let location = "YMCA"
    let locationIcon = UIImage(named: "ion-ios-location-outline_256_0_c3c3c3_none.png")
    
    let mapLocation = "Hong Kong"
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 8
    }
    
    @IBAction func handleVolunteerInvitation(sender: AnyObject) {
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return name.count
        } else if section == 1 {
            return timeAndDate.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell : EventPhotoCell!
            let nib = UINib(nibName:"EventPhoto", bundle: nil);
            
            tableView.rowHeight = 190
            tableView.registerNib(nib, forCellReuseIdentifier: "coverPhoto")
//            let (attr, value) = name[indexPath.row]
            cell = tableView.dequeueReusableCellWithIdentifier("coverPhoto", forIndexPath: indexPath) as! EventPhotoCell
            cell.eventHostButton.addTarget(self, action: "checkButtonClick:", forControlEvents: .TouchUpInside)
            cell.selectionStyle = .None
            
            cell.refreshPhotoCoverWithData(eventImages[objectId]!, title: titlesArray[objectId], host: titlesArray[objectId])
            
            return cell
        }
        else if indexPath.section == 1 {
            var cell : IconLabelCell!
            let nib = UINib(nibName:"IconLabelCell", bundle: nil)
            
            tableView.rowHeight = 40
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IconLabelCell
            cell.selectionStyle = .None
            
            cell.refreshCellWithData(timeAndDateIcons[indexPath.row]!, text: timeAndDate[indexPath.row])
            
            return cell
        } else if indexPath.section == 2 {
            var cell : IconLabelCell!
            let nib = UINib(nibName:"IconLabelCell", bundle: nil)
            
            tableView.rowHeight = 40
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IconLabelCell
            cell.selectionStyle = .None
            
            cell.refreshCellWithData(locationIcon!, text: location)
            
            return cell
        } else if indexPath.section == 3 {
            var cell : MapViewCell!
            
            tableView.rowHeight = 130
            
            let nib = UINib(nibName: "MapView", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "mapCell")

            cell = tableView.dequeueReusableCellWithIdentifier("mapCell", forIndexPath: indexPath) as! MapViewCell
            cell.selectionStyle = .None
            
            return cell
        } else if indexPath.section == 4 {
            var cell : IconLabelCell!
            let nib = UINib(nibName:"IconLabelCell", bundle: nil)
            
            tableView.rowHeight = 40
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IconLabelCell
            cell.selectionStyle = .None
            
            cell.refreshCellWithData(UIImage(named: "ion-ios-pricetag-outline_256_0_c3c3c3_none.png")!, text: "outgoing, friendly, committed")
            
            return cell
        }
        else if indexPath.section == 5 {
            
            var cell : GenericLabelTextviewCell!
            
            tableView.rowHeight = 100
            
            let nib = UINib(nibName: "GenericLabelTextviewCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "textviewCell")
            
            cell = tableView.dequeueReusableCellWithIdentifier("textviewCell", forIndexPath: indexPath) as! GenericLabelTextviewCell
            cell.selectionStyle = .None

            cell.refreshCellWithTextviewText("test")
            
            return cell
        } else if indexPath.section == 6 {
            var cell : SimpleButtonCell!
            
            let nib = UINib(nibName:"SimpleButtonCell", bundle: nil)
            
            tableView.rowHeight = 40
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SimpleButtonCell
            cell.selectionStyle = .None

            cell.refreshCellWithButtonData(buttonTextArray[0])
            
            return cell
        } else {
            var cell : SimpleButtonCell!
            
            let nib = UINib(nibName:"SimpleButtonCell", bundle: nil)
            
            tableView.rowHeight = 40
            tableView.registerNib(nib, forCellReuseIdentifier: "cell")
            cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SimpleButtonCell
            cell.selectionStyle = .None

            var buttonText = ""
            
            if orgInvited == true {
                buttonText = "accept invitation"
            } else {
                buttonText = buttonTextArray[1]
            }
            cell.refreshCellWithButtonData(buttonText)
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 {
            return nil
        } else if section == 2 {
            return " "
        } else if section == 3 {
            return nil
        } else {
            return " "
        }
    }
    
    func checkButtonClick(sender:UIButton!) {
        let vc = OrgProfileVC(nibName:"OrgProfileView", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = titlesArray[objectId]
        
//        requestIntivationButton.translatesAutoresizingMaskIntoConstraints = true
//        requestIntivationButton.frame = CGRectMake(0, screenRect.height - 100, screenRect.width, 50)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

