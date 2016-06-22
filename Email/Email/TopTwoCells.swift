//
//  TopTwoCells.swift
//  Email
//
//  Created by Sthuthi Shetty on 22/06/16.
//  Copyright © 2016 Deepak Ahuja. All rights reserved.
//

import Foundation
import UIKit

class TopTwoCells: UITableViewCell {
    
    @IBOutlet weak var lineOneLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineTwoLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var starOrOptionImage: UIButton!
    @IBOutlet weak var firstLetterImage: UIButton!
    @IBOutlet weak var lineOne: UILabel!
    @IBOutlet weak var lineTwo: UILabel!
    
    override func awakeFromNib() {
        firstLetterImage.layer.cornerRadius = firstLetterImage.frame.size.width/2
    }
}