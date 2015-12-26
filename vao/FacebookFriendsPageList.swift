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
    
    var eventId = ""
    
    var tv = UITableView()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tv = tableView
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
        
        let facebookUserQuery = PFQuery(className: "FacebookUserOnVao")
        facebookUserQuery.findObjectsInBackgroundWithBlock({
            (facebookUsers: [PFObject]?, error: NSError?) -> Void in
            print("facebookUsers: ", facebookUsers![0]["facebookId"].objectForKey("id")!)
            
            for facebookUser in facebookUsers! {
                let data = self.friendsDictionary.objectForKey("data") as! NSArray
                print("data: ", data)
                
                for i in 0...data.count - 1 {
                    let valueDict: NSDictionary = data[i] as! NSDictionary
                    
                    print("parse facebook Id: ",facebookUsers![0]["facebookId"].objectForKey("id")!)
                    print("facebook Id: ",valueDict.objectForKey("id") as? String)
                    
                    if facebookUser["facebookId"].objectForKey("id")! as? String == valueDict.objectForKey("id") as? String {
                        
                        print("eventId:", self.eventId)
                        
                        let eventQuery = PFQuery(className: "Event")
                        eventQuery.getObjectInBackgroundWithId(self.eventId) {
                            (event: PFObject?, error: NSError?) -> Void in
                            if error == nil {
                                
                                if event!["volunteers"] != nil {
                                    print("event: ", event!["volunteers"])
                                    let count = event!["volunteers"].count - 1
                                    
                                    for volunteer in 0...count{
                                        if event!["volunteers"][volunteer] as? String == facebookUser["owner"].objectId {
                                            print("true")
                                            self.friendsDictionaryArray.append(valueDict)
                                            self.tv.reloadData()
                                        } else {
                                            print("false")
                                        }
                                    }
                                    
                                    if self.friendsDictionaryArray.count < 1 {
                                        let alert = UIAlertController(title: "Alert", message: "You currently don't have any Facebook friends participating in this event.", preferredStyle: UIAlertControllerStyle.Alert)
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    }
                                } else {
                                    let alert = UIAlertController(title: "Alert", message: "You currently don't have any Facebook friends participating in this event.", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                }
                            } else {
                                let alert = UIAlertController(title: "Alert", message: "You currently don't have any Facebook friends participating in this event.", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        }
                        
                    } else {
                        print(false)
                        let alert = UIAlertController(title: "Alert", message: "You currently don't have any Facebook friends participating in this event.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
            
        })
    }
    
}
