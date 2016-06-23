import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var unreadEmailCountLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var emailUnreadCount = 0
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    var emailAttributesArray = [EmailAttributes]()
    
    func receiveNetworkNotification(notification:NSNotification) {
        print("notificationchanged")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(receiveNetworkNotification), name:"kReachabilityChangedNotification", object: nil)
        tableView.addSubview(refreshControl)
        self.tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier:"TableViewCell")
        self.tableView.separatorStyle = .None
        handleRefresh()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func handleRefresh(refreshControl: UIRefreshControl? = nil) {
        ConnectionManager.emailAttributesArray.removeAll()
        ConnectionManager.fetchData({(array:NSArray) in
            self.emailAttributesArray = array as! [EmailAttributes]
            self.tableView.reloadData()
            self.checkAndUpdateMailCount()
            self.tableView.setNeedsLayout()
            self.loadingView.hidden = true
            if refreshControl != nil
            {
                refreshControl!.endRefreshing()
            }
        })
    }
    
    func checkAndUpdateMailCount(){
        self.emailUnreadCount = 0
        for emailAttribute in self.emailAttributesArray
        {
            if emailAttribute.isRead == false{
                self.emailUnreadCount = self.emailUnreadCount + 1
            }
        }
        self.unreadEmailCountLabel.text = "Inbox(\(self.emailUnreadCount))"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(emailAttributesArray.count)")
        return emailAttributesArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 118.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var isStarred = false
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! CustomTableViewCell
        cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
        cell.nameLabel.text = self.emailAttributesArray[indexPath.row].participants[0]
        cell.previewLabel.text = self.emailAttributesArray[indexPath.row].preview
        cell.subjectLabel.text = self.emailAttributesArray[indexPath.row].subject
        cell.roundView.hidden = self.emailAttributesArray[indexPath.row].isRead
        cell.bringSubviewToFront(cell.starredImageView)
        cell.contentView.userInteractionEnabled = false
        if cell.roundView.hidden == false {
            let boldFont = UIFont.boldSystemFontOfSize(20.0)
            cell.nameLabel.font = boldFont
        }
        else{
            let normalFont = UIFont.systemFontOfSize(20.0)
            cell.nameLabel.font = normalFont
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.boolForKey("isStarredForId\(self.emailAttributesArray[indexPath.row].id)")) {
            cell.starredImageView.setBackgroundImage(UIImage(named: "starred.png"), forState: UIControlState.Normal)
        }
        else{
            cell.starredImageView.setBackgroundImage(UIImage(named: "unstarred.png"), forState: UIControlState.Normal)
        }
        cell.starredImageViewTappedClosure = {() in
            if defaults.boolForKey("isStarredForId\(self.emailAttributesArray[indexPath.row].id)") {
                cell.starredImageView.setBackgroundImage(UIImage(named: "unstarred.png"), forState: UIControlState.Normal)
                self.emailAttributesArray[indexPath.row].isStarred = false
                self.tableView.setNeedsLayout()
                self.tableView.layoutSubviews()
                cell.setNeedsLayout()
                cell.layoutSubviews()
            }
            else
            {
                cell.starredImageView.setBackgroundImage(UIImage(named: "starred.png"), forState: UIControlState.Normal)
                self.emailAttributesArray[indexPath.row].isStarred = true
                self.emailAttributesArray[indexPath.row].isStarred = false
                self.tableView.setNeedsLayout()
                self.tableView.layoutSubviews()
                cell.setNeedsLayout()
                cell.layoutSubviews()            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func deleteEmailWithIndexPathRow(indexPathRow:Int) -> Void {
        loadingView.hidden = false
        ConnectionManager.deleteEmail(emailAttributesArray[indexPathRow].id, completion: { (isSuccess) in
            if isSuccess == true
            {
                self.handleRefresh()
                UIAlertView(title:"Success!", message: "Email deleted successfully", delegate: nil, cancelButtonTitle: "OK").show()
            }
            else
            {
               UIAlertView(title:"Failure!", message: "Email not deleted. Check your network connection or try again later.", delegate: nil, cancelButtonTitle: "OK").show()            }
        })
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete
        {
            deleteEmailWithIndexPathRow(indexPath.row)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        emailAttributesArray[indexPath.row].isRead = true
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadData()
        self.checkAndUpdateMailCount()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("detailVC") as! DetailedEmailViewController
        vc.currentEmailId = emailAttributesArray[indexPath.row].id
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


