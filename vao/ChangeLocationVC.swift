//
//  ChangeLocationVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 20/12/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class ChangeLocationVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var rv: UITableView!
    var locationsArray = ["None"]
    
    @IBAction func dismissView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
//        cell.textLabel!.text = self.locationsArray[indexPath.row]
        
        let nib = UINib(nibName: "CategoriesCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "category")
        tableView.rowHeight = 70
        let cell: OpportuntiesCell = tableView.dequeueReusableCellWithIdentifier("category", forIndexPath: indexPath) as! OpportuntiesCell
        cell.categoriesLabel.text = locationsArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = PFUser.currentUser()
        user!["tempCategoryTwo"] = locationsArray[indexPath.row]
        user?.saveInBackgroundWithBlock {
            (success: Bool?, error: NSError?) -> Void in
            if success == true {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        let organizations = PFUser.query()
        organizations?.whereKey("userTypeIsVolunteer", equalTo: false)
        organizations?.findObjectsInBackgroundWithBlock {
            (orgs: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                for org in orgs! {
                    
                    print(org)
                    
                    if org["location"] != nil {
                        self.locationsArray.append(org["location"] as! String)
                        self.rv.reloadData()
                    }
                }
                
            } else {
                
            }
        }

    }
}
