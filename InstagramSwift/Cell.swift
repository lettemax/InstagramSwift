//
//  cell.swift
//  InstagramSwift
//
//  Created by Max Lettenberger on 6/10/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

import UIKit
import ParseUI

class Cell: UITableViewCell {
    @IBOutlet weak var postedImage: PFImageView!

//    @IBOutlet weak var username: UILabel!
//
//    @IBOutlet weak var comment: UILabel!



    override func layoutSubviews() {
        super.layoutSubviews()
        postedImage.frame = contentView.bounds
    }
}
