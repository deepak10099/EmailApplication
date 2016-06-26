//
//  LaunchScreenViewController.swift
//  Email
//
//  Created by Deepak on 26/06/16.
//  Copyright © 2016 Deepak Ahuja. All rights reserved.
//

import Foundation
import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showActivityIndicator()
        self.performSelector(#selector(LaunchScreenViewController.showAnotherViewController), withObject: nil, afterDelay: 5)
//        let delayInSeconds:Int64 = 1000
//        let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)
//        dispatch_after(popTime, dispatch_get_main_queue()) {
//            self.performSegueWithIdentifier("splashScreenSegue", sender: self)
//        }
    }

    func showAnotherViewController()
    {
    self.performSegueWithIdentifier("splashScreenSegue", sender: self)
    }

    func showActivityIndicator()
    {
        let window = UIApplication.sharedApplication().keyWindow
        let topView = window?.rootViewController?.view
        let myActivityIndicatorView: DTIActivityIndicatorView = DTIActivityIndicatorView(frame: CGRect(x:topView!.center.x - 40, y:topView!.center.y+100, width:80.0, height:80.0))
        topView!.addSubview(myActivityIndicatorView)
        myActivityIndicatorView.indicatorColor = UIColor.whiteColor()
        myActivityIndicatorView.indicatorStyle = DTIIndicatorStyle.convInv(DTIIndicatorStyle.chasingDots)
        myActivityIndicatorView.startActivity()
    }
}