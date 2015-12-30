//
//  createNewCategory.swift
//  Vao
//
//  Created by Ryan Neil Stroud on 31/12/2015.
//  Copyright © 2015 Ryan Stroud. All rights reserved.
//

import UIKit
import Parse

class CreateNewCategory: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let imageArray = [UIImage(named: "lsf-category_100_25_ffffff_e0c71c.png")!,
        UIImage(named: "lsf-walking_100_25_ffffff_2197ed.png")!,
        UIImage(named: "fa-hospital-o_100_25_ffffff_ed8f21.png")!,
        UIImage(named: "fa-book_100_25_ffffff_21ed8b.png")!,
        UIImage(named: "fa-hand-peace-o_100_25_ffffff_2bd49c.png")!,
        UIImage(named: "fa-heart_100_25_ffffff_ff49d2.png")!,
        UIImage(named: "ion-ios-baseball_100_25_ffffff_499dff.png")!,
        UIImage(named: "pe-7s-science_100_25_ffffff_9f49ff.png")!,
        UIImage(named: "fa-tablet_100_25_ffffff_ff4949.png")!,
        UIImage(named: "ion-ios-game-controller-a_100_25_ffffff_ffe249.png")!]
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        navigationItem.title = "choose category image"
        collectionView.backgroundColor = UIColor.whiteColor()
        
        return imageArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let nib = UINib(nibName: "CreateNewCategoryCell", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: "cell")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CreateNewCategoryCell
        cell.iconImageView.image = self.imageArray[indexPath.row]
        
        cell.iconImageView.layer.cornerRadius = 20.0
        cell.iconImageView.clipsToBounds = true

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let alert = UIAlertController(title: "New Category", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
//            myTextField = textField.text!
        })
        alert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.Default, handler: { action in
            print("created")
            let tf = alert.textFields![0] as UITextField
            print("textfield = ",tf.text)

            let newCategory = PFObject(className: "Category")
            newCategory["category"] = tf.text!
            
            let imageData = UIImagePNGRepresentation(self.imageArray[indexPath.row])
            let imageFile = PFFile(name:"category.png", data:imageData!)
            newCategory["categoryIcon"] = imageFile
            
            newCategory.saveInBackgroundWithBlock({
                (success: Bool?, error: NSError?) -> Void in
                if success == true {
                    //refreshTable

                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    print(error)
                }
            })

        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}