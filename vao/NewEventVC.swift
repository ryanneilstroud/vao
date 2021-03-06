//
//  NewEventVC.swift
//  vao
//
//  Created by Ryan Neil Stroud on 15/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse
import MapKit

class NewEventVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SendToB, SendToMapViewController, SendToCreateEvent {

    @IBOutlet var tableview: UITableView!
    var tv = UITableView()
    var addButton = UIBarButtonItem()
    
    var activeTextView: UITextView?
    
    var event = EventClass()
    var editEvent: PFObject!
    
    var titleTextFieldText = ""
    var aboutTextViewText = ""
    var imagePicker : UIImagePickerController!
    var image: UIImage?
    
    var locationName: String = "location"
    var categoryType: String = "category"
        
    var buttonLabelArray : [String] = ["date","time","don't repeat"]
    let iconImageArray : [UIImage] = [UIImage(named: "ion-ios-calendar-outline_256_0_c3c3c3_none.png")!, UIImage(named: "ion-ios-clock-outline_256_0_c3c3c3_none.png")!, UIImage(named: "pe-7s-repeat_256_0_c3c3c3_none.png")!]
    
    func addEvent(sender: AnyObject) {
        
        addButton.enabled = false
        
        let orgEvent = PFObject(className: "Event")
        
        if event.title == nil || event.title == "" {
            createAndDisplayAlert("oh no!", _message: "you must have a title for your event")
        } else if event.date == nil {
            createAndDisplayAlert("oh no!", _message: "you must have a date for your event")
        } else if event.time == nil {
            createAndDisplayAlert("oh no!", _message: "you must have a time for your event")
        } else {
            orgEvent["title"] = event.title
            orgEvent["date"] = event.date
            orgEvent["time"] = event.time
            orgEvent["frequency"] = event.frequency == nil ? "don't repeat" : event.frequency
            orgEvent["summary"] = event.summary == nil ? "" : event.summary
            orgEvent["locationName"] = event.locationName == nil ? "" : event.locationName
            orgEvent["category"] = event.category == nil ? "none" : event.category
            
            if event.location != nil {
                orgEvent["location"] = PFGeoPoint(latitude: event.location!.latitude, longitude: event.location!.longitude)
            }
            
            if event.eventImage != nil {
                let imageData = UIImageJPEGRepresentation(event.eventImage!, 0.5)
                let imageFile = PFFile(name:"eventPhoto.png", data:imageData!)
                
                orgEvent["eventImage"] = imageFile
            }
            
            if editEvent != nil {
                print("not nil")

//                let query = PFQuery(className: "Event")
//                query.getObjectInBackgroundWithId(editEvent.objectId!, block: {
//                    (object: PFObject?, error: NSError?) -> Void in
//                    if error == nil {
//                    
//                    } else {
//                        print(error)
//                    }
//                })
                editEvent["title"] = event.title
                editEvent["date"] = event.date
                editEvent["time"] = event.time
                editEvent["frequency"] = event.frequency == nil ? "don't repeat" : event.frequency
                editEvent["summary"] = event.summary == nil ? "" : event.summary
                editEvent["locationName"] = event.locationName == nil ? "" : event.locationName
                editEvent["category"] = event.category == nil ? "none" : event.category
                
                if event.location != nil {
                    editEvent["location"] = PFGeoPoint(latitude: event.location!.latitude, longitude: event.location!.longitude)
                }
                
                if event.eventImage != nil {
                    let imageData = UIImageJPEGRepresentation(event.eventImage!, 0.5)
                    let imageFile = PFFile(name:"eventPhoto.png", data:imageData!)
                    
                    editEvent["eventImage"] = imageFile
                }
                editEvent.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        print(success)
                        let alert = UIAlertController(title: "updated!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                        let delay = 0.5 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue(), {
                            alert.dismissViewControllerAnimated(true, completion: {(Bool) in
                                self.navigationController?.popToRootViewControllerAnimated(true)
                            })
                        })
                        
                    } else {
                        if error!.code == 125 {
                            
                        }
                        
                        print(error)
                    }
                }
            } else {
                print("nil")
                orgEvent["createdBy"] = PFUser.currentUser()
                orgEvent.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        print(success)
                        let alert = UIAlertController(title: "saved!", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                        let delay = 0.5 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue(), {
                            alert.dismissViewControllerAnimated(true, completion: {(Bool) in
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        })
                        
                    } else {
                        print(error)
                    }
                }
            }
        }
    }
    
    func createAndDisplayAlert(_title: String, _message: String) {
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        addButton.enabled = true
    }
    
//    @IBAction func cancelEventCreation(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    func didReceiveAtCreateEvent(_data: EventClass) {
        event = _data
        
        if _data.category != nil {
            categoryType = _data.category!
        }
        
        tv.reloadData()
    }
    
    func didReceiveAtMapViewController(_data: EventClass) {
        event = _data
        
        if _data.locationName != nil {
            locationName = _data.locationName!
        }
        
        tv.reloadData()
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
        
        tv.reloadData()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tv = tableView
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return buttonLabelArray.count
        } else if section == 3 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        tableView.scrollEnabled = true
        
        if indexPath.section == 0 {
            let nib = UINib(nibName: "TextFieldCell", bundle: nil)
            
            tableView.registerNib(nib, forCellReuseIdentifier: "textfieldCell")

            let cell : NewEventCell = tableView.dequeueReusableCellWithIdentifier("textfieldCell", forIndexPath: indexPath) as! NewEventCell
            cell.eventImageButton.addTarget(self, action: "getPicture", forControlEvents: .TouchUpInside)
            cell.titleTextField.delegate = self
            cell.titleTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            
            if image != nil {
                cell.refreshCellWithEventImage(image!)
            }
            
            if titleTextFieldText != "" {
                cell.titleTextField.text = titleTextFieldText
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
            cell.refreshCellWithButtonLabel(categoryType, _icon: UIImage(named: "lsf-category_128_0_c3c3c3_none.png")!)
            
            return cell
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let nib = UINib(nibName: "PickerCell", bundle: nil)
                
                tableView.registerNib(nib, forCellReuseIdentifier: "pickerCell")
                
                let cell : NewEventCell = tableView.dequeueReusableCellWithIdentifier("pickerCell", forIndexPath: indexPath) as! NewEventCell
                cell.refreshCellWithButtonLabel(locationName, _icon: UIImage(named: "ion-ios-location-outline_256_0_c3c3c3_none.png")!)
                
                return cell
            } else {
                let nib = UINib(nibName: "MapViewCell", bundle: nil)
                
                tableView.registerNib(nib, forCellReuseIdentifier: "mapCell")
                let cell : MapViewCell = tableView.dequeueReusableCellWithIdentifier("mapCell", forIndexPath: indexPath) as! MapViewCell
                
                if event.location != nil {
                    cell.refreshCellWithMapData(event.location!)
                }
                
                return cell
            }
        } else if indexPath.section == 4 {
            let nib = UINib(nibName: "GenericLabelTextviewCell", bundle: nil)
            
            tableView.registerNib(nib, forCellReuseIdentifier: "textviewCell")
            let cell = tableView.dequeueReusableCellWithIdentifier("textviewCell", forIndexPath: indexPath) as! GenericLabelTextviewCell
            cell.textview.delegate = self

            if aboutTextViewText == "" {
                cell.refreshCellWithEmptyCell()
            } else {
                cell.textview.text = aboutTextViewText
            }
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
            return 43
        } else if indexPath.section == 2 {
            return 43
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                return 43
            } else {
                return 200
            }
        } else {
            return 200
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
            let vc = CategoriesVC(nibName:"TableView", bundle: nil)
            vc.delegate = self
            vc.event = event
            vc.creatingEvent = true
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 3 {
            let vc = MapViewController(nibName: "MapView", bundle: nil)
            vc.delegate = self
            vc.event = event
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        titleTextFieldText = textField.text!
        event.setTitle(titleTextFieldText)
    }
    
    func textViewDidChange(textView: UITextView) {
        aboutTextViewText = textView.text!
        event.setSummary(aboutTextViewText)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        activeTextView = textView
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        activeTextView = nil
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
        
        self.tv.beginUpdates()
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        self.tv.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        self.tv.endUpdates()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if activeTextView != nil {
            var info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.tv.frame.origin.y = self.tv.frame.origin.y - keyboardFrame.size.height + 20
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.tv.frame.origin.y = 0
        })
        
    }
    
    override func viewDidLoad() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        addButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "addEvent:")
        navigationItem.rightBarButtonItem = addButton
        
        if editEvent != nil {
            
            titleTextFieldText = editEvent["title"] as! String
            event.title = editEvent["title"] as? String
            
            if let userImageFile = editEvent["eventImage"] as? PFFile {
                userImageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            self.image = UIImage(data: imageData)
                            self.event.eventImage = UIImage(data: imageData)
                            self.tv.reloadData()
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            let dateString = formatter.stringFromDate(editEvent["date"] as! NSDate)
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let timeString = timeFormatter.stringFromDate(editEvent["time"] as! NSDate)
            
            if let loc = editEvent["location"] as? PFGeoPoint {
                let latitude: CLLocationDegrees = loc.latitude
                let longtitude: CLLocationDegrees = loc.longitude
                
                let newLoc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                event.location = newLoc
                
            } else {
                let newLoc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                event.location = newLoc
            }

            
            buttonLabelArray[0] = dateString
            event.date = editEvent["date"] as? NSDate
            buttonLabelArray[1] = timeString
            event.time = editEvent["time"] as? NSDate
            
            buttonLabelArray[2] = editEvent["frequency"] as! String
            event.frequency = editEvent["frequency"] as? String
            
            categoryType = editEvent["category"] == nil ? "category" : editEvent["category"] as! String
            event.category = editEvent["category"] == nil ? "category" : editEvent["category"] as! String
            locationName = editEvent["locationName"] as! String
            event.locationName = editEvent["locationName"] as? String
            
            aboutTextViewText = editEvent["summary"] as! String
            event.summary = editEvent["summary"] as? String
        }
        
        
//        if editEvent != nil {
//            buttonLabelArray[0] = "hello"
//            buttonLabelArray[1] = "world"
//        }

    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
