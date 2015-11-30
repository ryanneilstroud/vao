//
//  NewEventVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 15/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class NewEventVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SendToB {

    @IBOutlet var tableview: UITableView!
    
    var event = EventClass()
    
    var titleTextFieldText = ""
    var aboutTextViewText = ""
    var imagePicker : UIImagePickerController!
    var image: UIImage?
    
    var buttonLabelArray : [String] = ["date","time","don't repeat"]
    let iconImageArray : [UIImage] = [UIImage(named: "ion-ios-calendar-outline_256_0_c3c3c3_none.png")!, UIImage(named: "ion-ios-clock-outline_256_0_c3c3c3_none.png")!, UIImage(named: "pe-7s-repeat_256_0_c3c3c3_none.png")!]
    
    @IBAction func addEvent(sender: AnyObject) {
        let orgEvent = PFObject(className: "Event")
        orgEvent["title"] = event.title
        orgEvent["date"] = event.date
        orgEvent["time"] = event.time
        orgEvent["frequency"] = event.frequency
        orgEvent["summary"] = event.summary
        
        if event.eventImage != nil {
            let imageData = UIImageJPEGRepresentation(event.eventImage!, 0.5)
            let imageFile = PFFile(name:"eventPhoto.png", data:imageData!)
            
            orgEvent["eventImage"] = imageFile
        }
        
        orgEvent["createdBy"] = PFUser.currentUser()
        orgEvent.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print(success)
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print(error)
            }
        }
    }
    
    @IBAction func cancelEventCreation(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didReceiveAtB(_data: EventClass) {
        
        event = _data
        
        if _data.date != nil {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            
            let dateString = formatter.stringFromDate(_data.date!)
            
            buttonLabelArray[0] = dateString
        }
        
        if _data.time != nil {
            let formatter = NSDateFormatter()
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
            let timeString = formatter.stringFromDate(_data.time!)
        
            buttonLabelArray[1] = timeString
        }
        
        if _data.frequency != nil {
            buttonLabelArray[2] = _data.frequency!
        }
        
        tableview.reloadData()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
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
        
        if indexPath.section == 0 {
            let nib = UINib(nibName: "TextFieldCell", bundle: nil)
            
            tableView.registerNib(nib, forCellReuseIdentifier: "textfieldCell")

            let cell : NewEventCell = tableView.dequeueReusableCellWithIdentifier("textfieldCell", forIndexPath: indexPath) as! NewEventCell
            cell.eventImageButton.addTarget(self, action: "getPicture", forControlEvents: .TouchUpInside)
            cell.titleTextField.delegate = self
            
            if image != nil {
                cell.refreshCellWithEventImage(image!)
            }
            
            return cell
        } else if indexPath.section == 1 {
            let nib = UINib(nibName: "PickerCell", bundle: nil)

            tableView.registerNib(nib, forCellReuseIdentifier: "pickerCell")

            let cell : NewEventCell = tableView.dequeueReusableCellWithIdentifier("pickerCell", forIndexPath: indexPath) as! NewEventCell
            cell.refreshCellWithButtonLabel(buttonLabelArray[indexPath.row], _icon: iconImageArray[indexPath.row])
            
            
            
            return cell
        } else if indexPath.section == 2 {
            let nib = UINib(nibName: "PickerCell", bundle: nil)
            
            tableView.registerNib(nib, forCellReuseIdentifier: "pickerCell")

            let cell : NewEventCell = tableView.dequeueReusableCellWithIdentifier("pickerCell", forIndexPath: indexPath) as! NewEventCell
            cell.refreshCellWithButtonLabel("location", _icon: UIImage(named: "ion-ios-location-outline_256_0_c3c3c3_none.png")!)
            
            return cell
        } else if indexPath.section == 3 {
            let nib = UINib(nibName: "MapViewCell", bundle: nil)
            
            tableView.registerNib(nib, forCellReuseIdentifier: "mapCell")
            let cell : MapViewCell = tableView.dequeueReusableCellWithIdentifier("mapCell", forIndexPath: indexPath) as! MapViewCell
            cell.refreshCellWithMapData()
            
            return cell
        } else if indexPath.section == 4 {
            let nib = UINib(nibName: "GenericLabelTextviewCell", bundle: nil)
            
            tableView.registerNib(nib, forCellReuseIdentifier: "textviewCell")
            let cell = tableView.dequeueReusableCellWithIdentifier("textviewCell", forIndexPath: indexPath) as! GenericLabelTextviewCell
            cell.textview.delegate = self
            cell.refreshCellWithEmptyCell()
            return cell
        } else {
            let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else if indexPath.section == 1 {
            return 45
        } else if indexPath.section == 2 {
            return 45
        } else {
            return 200
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 {
            return " "
        } else if section == 2 {
            return " "
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = NewEventCollectSelectionVC(nibName: "DetailDatePickerView", bundle: nil)
                vc.delegate = self
                vc.event = event
                vc.datePickerMode = UIDatePickerMode.Date
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 1 {
                let vc = NewEventCollectSelectionVC(nibName: "DetailDatePickerView", bundle: nil)
                vc.delegate = self
                vc.event = event
                vc.datePickerMode = UIDatePickerMode.Time
                navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 2 {
                let vc = NewEventCollectSelectionVC(nibName: "DetailPickerView", bundle: nil)
                vc.delegate = self
                vc.event = event
                navigationController?.pushViewController(vc, animated: true)
            }
        
        } else if indexPath.section == 2 {
            let vc = MapViewController(nibName: "MapView", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        titleTextFieldText = textField.text!
        event.setTitle(titleTextFieldText)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        aboutTextViewText = textView.text!
        event.setSummary(aboutTextViewText)
    }
    
    func getPicture() {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .PhotoLibrary
        
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        event.setEventImage(image!)
        
        self.tableview.beginUpdates()
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        self.tableview.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        self.tableview.endUpdates()
    }
    
    override func viewDidLoad() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self

    }
    
//    func formatCell(_tableview: UITableView, _nibName: String, _cellName: String, _cell: UITableViewCell) -> UITableViewCell {
//        let nib = UINib(nibName: _nibName, bundle: nil)
//        
//        _tableview.registerNib(nib, forCellReuseIdentifier: _cellName)
//        let cell = _tableview.dequeueReusableCellWithIdentifier(_cellName)
//        return cell!
//    }
}
