import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var reachability:Reachability!;
    var networkStatus : NetworkStatus!
    var window: UIWindow?



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("receiveNetworkNotification:"), name:"kReachabilityChangedNotification", object: nil)
        self.reachability = Reachability.reachabilityForInternetConnection();
        self.reachability.startNotifier();
        
        return true
    }
    
    func receiveNetworkNotification(notification:NSNotification) {
        let networkReachability = Reachability.reachabilityForInternetConnection()
        networkReachability.startNotifier()
        
        networkStatus = reachability.currentReachabilityStatus()
        if (networkStatus == NetworkStatus.NotReachable)
        {
            self.showAlertViewWithMessage("Check your internet connection.", title: "Failure!")
        }
        else
        {
            self.showAlertViewWithMessage("You just recovered your internet connection", title: "Success!")
        }
    }
    
    func showAlertViewWithMessage(message:String, title:String){
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction.init(title:"OK", style: .Cancel, handler: { (action) in
            }))
            window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        } else {
            UIAlertView(title:title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
        }
        
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}