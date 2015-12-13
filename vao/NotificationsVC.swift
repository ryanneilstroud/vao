//
//  NotificationsVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 18/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class NotificationsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let notificationsArray = ["Indigo Studios has approved your request!", "You have been invited by Axiom to be a volunteer!", "Congratulations! You finished volunteering at Indigo Studios. Rate their event!"]
    let notificationsImageArray = [UIImage(named: "axiom_logo.jpg")!, UIImage(named: "axiom_logo.jpg"), UIImage(named: "axiom_logo.jpg")]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (storyboard?.valueForKey("name"))! as! String == "Main" {
            print("main storyboard")
        } else {
            print("other storyboard")
        }
        
        let nib = UINib(nibName: "NotificationsCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 100
        let cell: NotificationsCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NotificationsCell
        
        cell.refreshNotificationsCellWithData(notificationsImageArray[indexPath.row]!, text: notificationsArray[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
//            let vc = OpportunitiesDetailVC(nibName:"OpportunitiesDetailVC", bundle: nil)
////            vc.event = indexPath.row
//            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
//            let vc = OpportunitiesDetailVC(nibName:"OpportunitiesDetailVC", bundle: nil)
////            vc.event = indexPath.row
//            vc.orgInvited = true
//            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = RateVC(nibName:"RateView", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        NSLog("selected notification index = %d", indexPath.row)
    }
    
    func getNotifications() {
        //confirmation, invitation, event completetion
        
//        let invitationQuery = PFQuery(className:"EventParticipantValidation")
//        invitationQuery.whereKey("", equalTo: <#T##AnyObject#>)
    }
    
    override func viewDidLoad() {
        getNotifications()
    }
    
}
