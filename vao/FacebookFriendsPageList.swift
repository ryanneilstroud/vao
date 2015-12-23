//
//  FacebookFriendsPageList.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 20/12/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class FacebookFriendsPageList: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friendsDictionary: NSDictionary!
    var friendsDictionaryArray = [NSDictionary]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsDictionaryArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : OpportuntiesCell
        
        let nib = UINib(nibName:"FacebookFriendCell", bundle: nil);
        
        tableView.rowHeight = 85
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OpportuntiesCell;
//        cell.refreshCellWithCategoryData(image[indexPath.row], categoryName: name[indexPath.row])
        cell.refreshFacebookFriendCell(friendsDictionaryArray[indexPath.row])
        
        return cell
    }
    
    override func viewDidLoad() {
        
        let data = friendsDictionary.objectForKey("data") as! NSArray
        print("data: ", data)

        for i in 0...data.count - 1 {
            let valueDict: NSDictionary = data[i] as! NSDictionary
            
//            let query = PFUser.query()
//            query?.whereKey("authData", equalTo: <#T##AnyObject#>)
            
//            print(PFUser.currentUser())
            
            print(valueDict.objectForKey("id") as? String)
            friendsDictionaryArray.append(valueDict)
        }
    }
    
}
