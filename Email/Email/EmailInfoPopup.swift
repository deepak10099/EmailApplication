//
//  EmailInfoPopup.swift
//  Email
//
//  Created by Deepak on 26/06/16.
//  Copyright © 2016 Deepak Ahuja. All rights reserved.
//

import Foundation
import UIKit

class EmailInfoPopup:UIView {
    var closeButtonTappedClosure: (()->Void)?

    @IBAction func closeButtonTapped(sender: AnyObject) {
        closeButtonTappedClosure!()
    }
    
}