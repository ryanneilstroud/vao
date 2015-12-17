//
//  Settings.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 16/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class Settings: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let accountArray : [String] = ["Edit Profile","Change Password","Change Email"]
    let otherArray : [String] = ["Log Out"]
    
    var socialArray: [String] = [""]
    
    var tableview: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableview = tableView
        
        if section == 0 {
            return accountArray.count
        } else if section == 1 {
            return socialArray.count
        } else if section == 2 {
            return otherArray.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if PFUser.currentUser()!["userTypeIsVolunteer"] as! Bool {
            if PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!) {
                socialArray[0] = "Disconnect from Facebook"
                print("true")
            } else {
                socialArray[0] = "Connect to Facebook"
                print("false")
            }
        }
        
        if indexPath.section == 0 {
            let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = accountArray[indexPath.row]
            
            return cell
        } else if indexPath.section == 1 {
            let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = socialArray[indexPath.row]
            cell.accessoryType = .None
                
            return cell
        } else if indexPath.section == 2 {
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
        } else if section == 1 {
            if PFUser.currentUser()!["userTypeIsVolunteer"] as! Bool {
                return "social"
            } else {
                return nil
            }
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
                print(indexPath.row)
                vc.viewIndentifier = indexPath.row
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        } else if indexPath.section == 1 {
            if !PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!) {
                PFFacebookUtils.linkUserInBackground(PFUser.currentUser()!, withReadPermissions: ["user_friends"], block: {
                    (succeeded: Bool?, error: NSError?) -> Void in
                    if succeeded == true {
                        print("Woohoo, the user is linked with Facebook!")
                        tableView.reloadData()
                    }
                })
            } else {
                PFFacebookUtils.unlinkUserInBackground(PFUser.currentUser()!, block: {
                    (succeeded: Bool?, error: NSError?) -> Void in
                    if succeeded == true {
                        print("The user is no longer associated with their Facebook account.")
                        tableView.reloadData()
                    }
                })
            }

        } else if indexPath.section == 2 {
            PFUser.logOut()
            let nib = CredentialsVC(nibName:"LogIn", bundle: nil) as CredentialsVC
            self.presentViewController(nib, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
    }
}
