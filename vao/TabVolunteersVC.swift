//
//  TabVolunteersVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 17/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class TabVolunteersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let namesArr : [String] = ["Ryan Neil Stroud", "Justin Ling", "Josh Loke", "Melody Wakefield", "Rebekah Scott"]
    var imageArr : [UIImage] = [UIImage(named: "1.jpg")!,UIImage(named: "2.jpg")!,UIImage(named: "3.jpg")!,UIImage(named: "4.jpg")!,UIImage(named: "5.jpg")!]

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesArr.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let nib = UINib(nibName: "VolunteersCell", bundle: nil)
        
        tableView.rowHeight = 100
        tableView.registerNib(nib, forCellReuseIdentifier: "volunteer")
        
        let cell : VolunteersTVC = tableView.dequeueReusableCellWithIdentifier("volunteer", forIndexPath: indexPath) as! VolunteersTVC
        cell.refreshCellWithVolunteerData(imageArr[indexPath.row], _fullName: namesArr[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = ProfileVC(nibName:"ProfileView", bundle: nil)
        vc.orgIsViewing = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
//        for index in 1...5 {
//            NSLog("index = %d", index)
//            imageArr.append(UIImage(named: "1.jpg")!)
//        }
//        
//        NSLog("imageArr = %@", imageArr)
    }
}
