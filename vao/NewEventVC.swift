//
//  NewEventVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 15/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

class NewEventVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let buttonLabelArray : [String] = ["date","time","repeat"]
    let iconImageArray : [UIImage] = [UIImage(named: "ion-ios-calendar-outline_256_0_c3c3c3_none.png")!, UIImage(named: "ion-ios-clock-outline_256_0_c3c3c3_none.png")!, UIImage(named: "pe-7s-repeat_256_0_c3c3c3_none.png")!]
    
    @IBAction func cancelEventCreation(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return buttonLabelArray.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        tableView.rowHeight = 100
        
        if indexPath.section == 0 {
            let nib = UINib(nibName: "TextFieldCell", bundle: nil)
            
            tableView.registerNib(nib, forCellReuseIdentifier: "textfieldCell")
            let cell : NewEventCell = tableView.dequeueReusableCellWithIdentifier("textfieldCell", forIndexPath: indexPath) as! NewEventCell
            
            return cell
        } else if indexPath.section == 1 {
            let nib = UINib(nibName: "PickerCell", bundle: nil)
            
            tableView.registerNib(nib, forCellReuseIdentifier: "pickerCell")
            let cell : NewEventCell = tableView.dequeueReusableCellWithIdentifier("pickerCell", forIndexPath: indexPath) as! NewEventCell
            cell.refreshCellWithButtonLabel(buttonLabelArray[indexPath.row], _icon: iconImageArray[indexPath.row])
            
            return cell
        } else if indexPath.section == 2 {
            let nib = UINib(nibName: "PickMapLocationCell", bundle: nil)
            
            tableView.rowHeight = 200
            tableView.registerNib(nib, forCellReuseIdentifier: "mapCell")
            let cell : NewEventCell = tableView.dequeueReusableCellWithIdentifier("mapCell", forIndexPath: indexPath) as! NewEventCell
//            cell.refreshCellWithButtonLabel(buttonLabelArray[indexPath.row], _icon: iconImageArray[indexPath.row])
            return cell
        } else {
            let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            return " "
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = NewEventVC(nibName: "DetailPickerView", bundle: nil)
                navigationController?.pushViewController(vc, animated: true)
            }
        
        } else if indexPath.section == 2 {
        
        }
        
        NSLog("%d", indexPath.section)

    }
    
    func formatCell(_tableview: UITableView, _nibName: String, _cellName: String, _cell: UITableViewCell) -> UITableViewCell {
        let nib = UINib(nibName: _nibName, bundle: nil)
        
        _tableview.registerNib(nib, forCellReuseIdentifier: _cellName)
        let cell = _tableview.dequeueReusableCellWithIdentifier(_cellName)
        return cell!
    }
    
}
