//
//  FeedViewController.swift
//  InstagramSwift
//
//  Created by Max Lettenberger on 6/10/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

import Foundation
import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var comments = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()
    var users = [String: String]()


    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        var query = PFUser.query()

        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in

            if let users = objects {

                self.comments.removeAll(keepCapacity: true)
                self.users.removeAll(keepCapacity: true)
                self.imageFiles.removeAll(keepCapacity: true)
                self.usernames.removeAll(keepCapacity: true)

                for object in users {

                    if let user = object as? PFUser {

                        self.users[user.objectId!] = user.username!

                    }
                }
            }


            var getFollowedUsersQuery = PFQuery(className: "followers")

            getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)

            getFollowedUsersQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in

                if let objects = objects {

                    for object in objects {

                        var followedUser = object["following"] as String

                        var query = PFQuery(className: "Post")

                        query.whereKey("userId", equalTo: followedUser)

                        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in

                            if let objects = objects {

                                for object in objects {

                                    self.comments.append(object["message"] as String)

                                    self.imageFiles.append(object["imageFile"] as PFFile)

                                    self.usernames.append(self.users[object["userId"] as String]!)

                                    self.tableView.reloadData()

                                }

                            }


                        })
                    }

                }

            }

        })

    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return usernames.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as Cell

        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in

            if let downloadedImage = UIImage(data: data!) {


                myCell.postedImage.image = downloadedImage
//                myCell.postedImage.frame = CGRectInset(myCell.bounds, 30, 30)
//                myCell.postedImage.contentMode = UIViewContentMode.ScaleAspectFit


            }

        }


        myCell.username.text = usernames[indexPath.row]

        myCell.comment.text = comments[indexPath.row]

        return myCell

    }

    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}


