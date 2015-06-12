//
//  ProfileViewController.swift
//  InstagramSwift
//
//  Created by Max Lettenberger on 6/9/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

import Parse
import Foundation
import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//trying to change the font size of the tab bar items

    override func awakeFromNib() {
        let appearance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName:UIFont(name: "American Typewriter", size: 20)!]
        appearance.setTitleTextAttributes(attributes, forState: UIControlState.Normal)

    }


    var imageFiles : [PFObject] = []
    //or var imageFiled = [] as [PFObject]
//    var currentUser = PFUser.currentUser()!

    @IBOutlet weak var tableView: UITableView!

    func queryForGetUserPhotos()
    {
        var query = PFQuery(className: "Post")

        query.whereKey("userId", equalTo: PFUser.currentUser()!.objectId!)

        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in


            if let objects = objects {

                self.imageFiles = objects as! [PFObject]
//                for imageFile in objects {
//
//                    self.imageFiles.append(imageFile["imageFile"] as PFFile)
//
//                }
                self.tableView.reloadData()
            }
        })
    }


    override func viewDidLoad() {
        super.viewDidLoad()

                queryForGetUserPhotos()


//        self.imageFiles.append(currentUser["imageFile"] as PFFile)
//
//        tableView.reloadData()

    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageFiles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Cell
        let photoFile = imageFiles[indexPath.row]
        myCell.postedImage.file = photoFile["imageFile"] as? PFFile
        //why error: Execution was interrupted, reason: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0). The process has been returned to the state before expression evaluation.
        myCell.postedImage.loadInBackground { _ in
            myCell.layoutSubviews()
        }
        return myCell
    }
}






