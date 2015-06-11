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
                                }
                                self.tableView.reloadData()
                            }
                        })
                    }

                }

            }

        })

    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as Cell
        myCell.postedImage.file = imageFiles[indexPath.row]
        myCell.postedImage.loadInBackground { _ in
            myCell.layoutSubviews()
        }
        return myCell
    }
}


