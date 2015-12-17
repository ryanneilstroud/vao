//
//  CategoriesVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 12/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

protocol SendToCreateEvent: class {
    func didReceiveAtCreateEvent(_data: EventClass)
}

class CategoriesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var delegate: SendToCreateEvent? = nil

    var event: EventClass?
    var filterCategory: String = ""
    var creatingEvent = false
    
    let image : [UIImage] = [UIImage(named: "lsf-category_100_25_ffffff_e0c71c.png")!,
                                UIImage(named: "lsf-walking_100_25_ffffff_2197ed.png")!,
                                UIImage(named: "fa-hospital-o_100_25_ffffff_ed8f21.png")!,
                                UIImage(named: "fa-book_100_25_ffffff_21ed8b.png")!]
    
    let name : [String] = ["All Categories","Delivery","Medical","Tutor"]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return image.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : OpportuntiesCell
        
        let nib = UINib(nibName:"CategoriesCell", bundle: nil);
        
        tableView.rowHeight = 70
        tableView.registerNib(nib, forCellReuseIdentifier: "category")
        cell = tableView.dequeueReusableCellWithIdentifier("category", forIndexPath: indexPath) as! OpportuntiesCell;
        cell.refreshCellWithCategoryData(image[indexPath.row], categoryName: name[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("clicked = %@", name[indexPath.row])
        if let myDelegate = delegate {
            
            event?.category = name[indexPath.row]
            myDelegate.didReceiveAtCreateEvent(event!)
        }
        
        if creatingEvent {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            
            var text = ""
            
            if indexPath.row != 0 {
                text = name[indexPath.row]
            }
            
            let user = PFUser.currentUser()
            user!["tempCategory"] = text
            user?.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The score key has been incremented
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    // There was a problem, check error.description
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissCategories(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
