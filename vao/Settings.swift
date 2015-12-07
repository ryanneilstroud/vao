//
//  Settings.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 16/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class Settings: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let accountArray : [String] = ["Edit Profile","Change Password","Change Email"]
    let otherArray : [String] = ["Log Out"]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return accountArray.count
        } else if section == 1 {
            return otherArray.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = accountArray[indexPath.row]
            
            return cell
        } else if indexPath.section == 1 {
            let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.textLabel?.textColor = UIColor.blueColor()
            cell.textLabel?.text = otherArray[indexPath.row]
            
            return cell
        } else {
            let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "account"
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            switch (indexPath.row) {
            case 0:
                if PFUser.currentUser()!["userTypeIsVolunteer"] as! Bool == false {
                    let vc = OrgEditProfileVC(nibName: "ProfileView", bundle: nil)
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = EditProfileVC(nibName: "ProfileView", bundle: nil)
                    navigationController?.pushViewController(vc, animated: true)
                }
            case 1, 2:
                let vc = ChangePrivateData(nibName: "TableView", bundle: nil)
                vc.viewIndentifier = indexPath.row
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        } else if indexPath.section == 1 {
            PFUser.logOut()
            let nib = CredentialsVC(nibName:"LogIn", bundle: nil) as CredentialsVC
            self.presentViewController(nib, animated: true, completion: nil)
        }
    }
}
