//
//  cell.swift
//  InstagramSwift
//
//  Created by Max Lettenberger on 6/10/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

import Foundation
import UIKit

class Cell: UITableViewCell {


    @IBOutlet weak var postedImage: UIImageView!

    @IBOutlet weak var username: UILabel!

    @IBOutlet weak var comment: UILabel!

//    override func layoutSubviews() {
//        imageView?.frame = CGRectInset(self.bounds, 20, 70)
//        imageView?.contentMode = UIViewContentMode.ScaleAspectFit
//    }


}