//
//  LaunchScreen.swift
//  Email
//
//  Created by Deepak on 26/06/16.
//  Copyright © 2016 Deepak Ahuja. All rights reserved.
//

import Foundation
import UIKit

class LaunchScreen: UIView {


    override func awakeFromNib() {
        showActivityIndicator()
    }

    func showActivityIndicator()
    {
        let myActivityIndicatorView: DTIActivityIndicatorView = DTIActivityIndicatorView(frame: CGRect(x:self.center.x - 20, y:self.center.y+100, width:40.0, height:40.0))
        self.addSubview(myActivityIndicatorView)
        myActivityIndicatorView.indicatorColor = UIColor.redColor()
        myActivityIndicatorView.indicatorStyle = DTIIndicatorStyle.convInv(DTIIndicatorStyle.chasingDots)
        myActivityIndicatorView.startActivity()
    }
}