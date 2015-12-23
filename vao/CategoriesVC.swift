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
    
    let image : [UIImage] = [UIImage(named: "lsf-category_100_25_ffffff_e0c71c.png")!,
                                UIImage(named: "lsf-walking_100_25_ffffff_2197ed.png")!,
                                UIImage(named: "fa-hospital-o_100_25_ffffff_ed8f21.png")!,
                                UIImage(named: "fa-book_100_25_ffffff_21ed8b.png")!]
    
    var names = [String]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tv = tableView
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : OpportuntiesCell
        
        let nib = UINib(nibName:"CategoriesCell", bundle: nil);
        
        tableView.rowHeight = 70
        tableView.registerNib(nib, forCellReuseIdentifier: "category")
        cell = tableView.dequeueReusableCellWithIdentifier("category", forIndexPath: indexPath) as! OpportuntiesCell;
//        cell.refreshCellWithCategoryData(image[indexPath.row], categoryName: name[indexPath.row])
        
        if names[indexPath.row] == "All Categories" {
            cell.categoriesImageView.image = nil
            cell.refreshCellWithCategoryData(UIImage(named: "lsf-category_100_25_ffffff_e0c71c.png")!, categoryName: names[indexPath.row])
        } else if names[indexPath.row] == "Tutor" {
            cell.categoriesImageView.image = nil
            cell.refreshCellWithCategoryData(UIImage(named: "fa-book_100_25_ffffff_21ed8b.png")!, categoryName: names[indexPath.row])
        } else if names[indexPath.row] == "Delivery" {
            cell.categoriesImageView.image = nil
            cell.refreshCellWithCategoryData(UIImage(named: "lsf-walking_100_25_ffffff_2197ed.png")!, categoryName: names[indexPath.row])
        } else if names[indexPath.row] == "Medical" {
            cell.categoriesImageView.image = nil
            cell.refreshCellWithCategoryData(UIImage(named: "fa-hospital-o_100_25_ffffff_ed8f21.png")!, categoryName: names[indexPath.row])
        } else {
            cell.categoriesImageView.image = nil
            cell.categoriesLabel.text = names[indexPath.row]
        }
        
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
        
        let alert = UIAlertController(title: "New Category", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
//            myTextField = textField.text!
        })
        alert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.Default, handler: { action in
            print("created")
            let tf = alert.textFields![0] as UITextField
            print("textfield = ",tf.text)
            
//            for name in self.names {
//                if name != tf.text {
//                
//                }
//            }
            
            let newCategory = PFObject(className: "Category")
            newCategory["category"] = tf.text!
            newCategory.saveInBackgroundWithBlock({
                (success: Bool?, error: NSError?) -> Void in
                if success == true {
                    //refreshTable
                    self.names.removeAll()
                    self.loadCategories()
                } else {
                    print(error)
                }
            })

        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func loadCategories() {
        let categoriesQuery = PFQuery(className: "Category")
        categoriesQuery.orderByAscending("category")
        categoriesQuery.findObjectsInBackgroundWithBlock {
            (categories: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for category in categories! {
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
        
        loadCategories()
        
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
