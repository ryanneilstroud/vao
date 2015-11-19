//
//  OpportunitiesVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 5/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class OpportunitiesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var myBool = false
    var screenRect : CGRect = UIScreen.mainScreen().bounds
    
    @IBOutlet var selectedFilter: UIButton!
    
    var picker : UIPickerView! = UIPickerView()
    let array = ["recent", "upcoming", "recommended", "bookmarked", "my opportunities"]
    
    //opportunitiesCell info
    let titlesArray = ["Axiom","Indigo","World Vision"]
    let eventImages = [UIImage(named: "axiom.jpg")!, UIImage(named: "event0.jpg")!, UIImage(named: "event1.jpg")]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : OpportuntiesCell!

        let nib = UINib(nibName:"OpportunitiesCell", bundle: nil);
        
        tableView.rowHeight = 160
        tableView.registerNib(nib, forCellReuseIdentifier: "opportunitiesCell")
        cell = tableView.dequeueReusableCellWithIdentifier("opportunitiesCell", forIndexPath: indexPath) as! OpportuntiesCell
        cell.refreshCellWithOpportunityData(titlesArray[indexPath.row], dateAndTime: "two", location: "three", summary: "four", picture: eventImages[indexPath.row]!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = OpportunitiesDetailVC(nibName:"OpportunitiesDetailVC", bundle: nil)
        vc.objectId = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openPicker(sender: AnyObject) {
        if picker.hidden == true {
            picker.hidden = false
        } else {
            picker.hidden = true
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFilter.titleLabel?.text = array[row]
    }
    
    func setPicker() {
        picker.hidden = true
        
        picker.delegate = self
        picker.dataSource = self
        
        picker.frame = CGRectMake(0, screenRect.size.height - picker.frame.height, screenRect.size.width, picker.frame.size.height)
        
        let white = UIColor.whiteColor()
        picker.backgroundColor = white.colorWithAlphaComponent(0.9)
        
        self.view.addSubview(picker)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //checked to see if logged in
        if myBool == false {
//            let nib = CredentialsVC(nibName:"LogIn", bundle: nil) as CredentialsVC
//            self.presentViewController(nib, animated: true, completion: nil)
        } else {
            
        }
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),
//            NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 21)!]
//        setPicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}