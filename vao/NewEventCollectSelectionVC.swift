//
//  NewEventCollectSelectionVC.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 25/11/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit

protocol SendToB: class {
    func didReceiveAtB(_data: EventClass)
}

class NewEventCollectSelectionVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    weak var delegate: SendToB? = nil
    var event: EventClass!
    var datePickerMode: UIDatePickerMode?
    
    let repeatArray = ["don't repeat","daily", "weekly", "monthly"]
    
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        if datePickerMode != nil {
            datePicker.datePickerMode = datePickerMode!
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let myDelegate = delegate {
                        
            if datePickerMode == UIDatePickerMode.Date {
                event.setDate(self.datePicker.date)
            } else if datePickerMode == UIDatePickerMode.Time {
                event.setTime(self.datePicker.date)
            }
            
            myDelegate.didReceiveAtB(event)
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        event.setFrequency(repeatArray[row])
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return repeatArray[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return repeatArray.count
    }
    
}