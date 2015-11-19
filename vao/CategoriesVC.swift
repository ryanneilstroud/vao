//
//  CategoriesVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 12/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let image : [UIImage] = [UIImage(named: "lsf-walking_100_25_ffffff_2197ed.png")!,
                                UIImage(named: "fa-hospital-o_100_25_ffffff_ed8f21.png")!,
                                UIImage(named: "fa-book_100_25_ffffff_21ed8b.png")!]
    
    let name : [String] = ["Delivery","Medical","Tutor"]
    
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
        self.dismissViewControllerAnimated(true, completion: nil)
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
