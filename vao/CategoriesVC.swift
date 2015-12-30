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
    var tv = UITableView()
    
    var names = [String]()
    var images = [UIImage]()
    
    var categories = [PFObject]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tv = tableView
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : OpportuntiesCell
        
        let nib = UINib(nibName:"CategoriesCell", bundle: nil);
        
        tableView.rowHeight = 70
        tableView.registerNib(nib, forCellReuseIdentifier: "category")
        cell = tableView.dequeueReusableCellWithIdentifier("category", forIndexPath: indexPath) as! OpportuntiesCell
        
//        cell.refreshCellWithCategoryData(images[indexPath.row], categoryName: names[indexPath.row])
        cell.refreshCellWithCategoryObject(categories[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("clicked = %@", names[indexPath.row])
        if let myDelegate = delegate {
            
            event?.category = names[indexPath.row]
            myDelegate.didReceiveAtCreateEvent(event!)
        }
        
        if creatingEvent {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            
            var text = ""
            
            if indexPath.row != 0 {
                text = names[indexPath.row]
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
    
    func addNewCategory() {
        
        let vc = CreateNewCategory(nibName:"CreateNewCategoryView", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadCategories() {
        let categoriesQuery = PFQuery(className: "Category")
        categoriesQuery.orderByAscending("category")
        categoriesQuery.findObjectsInBackgroundWithBlock {
            (categories: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                self.categories.removeAll()
                self.names.removeAll()
                
                for category in categories! {
                    
                    self.categories.append(category)
                    self.names.append(category["category"] as! String)
                    self.tv.reloadData()
                }
            } else {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser()!["userTypeIsVolunteer"] as! Bool == false {
            let addCategoryButton = UIBarButtonItem(title: "New Category", style: UIBarButtonItemStyle.Plain, target: self, action: "addNewCategory")
            navigationItem.rightBarButtonItem = addCategoryButton
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissCategories(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        loadCategories()
    }
}
