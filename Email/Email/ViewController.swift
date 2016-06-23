import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var emptyImageView: UIImageView!
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
        emptyImageView.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(receiveNetworkNotification), name:"kReachabilityChangedNotification", object: nil)
        tableView.addSubview(refreshControl)
        tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier:"TableViewCell")
        tableView.separatorStyle = .None
        handleRefresh()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func handleRefresh(refreshControl: UIRefreshControl? = nil) {
        ConnectionManager.emailAttributesArray.removeAll()
        ConnectionManager.fetchData({(array:NSArray) in
            self.emailAttributesArray = array as! [EmailAttributes]
            if  self.emailAttributesArray.count == 0{
                self.loadingView.hidden = true
                self.emptyImageView.hidden = false
                self.tableView.hidden = true
                self.unreadEmailCountLabel.text = "Empty Inbox"
                return
            }
            else{
                self.emptyImageView.hidden = true
                self.tableView.hidden = false
            }
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
        emailUnreadCount = 0
        for emailAttribute in  emailAttributesArray
        {
            if emailAttribute.isRead == false{
                emailUnreadCount =  emailUnreadCount + 1
            }
        }
        unreadEmailCountLabel.text = "Inbox(\( emailUnreadCount))"
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
        let cell =  tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! CustomTableViewCell
        cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
        cell.nameLabel.text =  emailAttributesArray[indexPath.row].participants[0]
        cell.previewLabel.text =  emailAttributesArray[indexPath.row].preview
        cell.subjectLabel.text =  emailAttributesArray[indexPath.row].subject
        cell.roundView.hidden =  emailAttributesArray[indexPath.row].isRead
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
        if (defaults.boolForKey("isStarredForId\( emailAttributesArray[indexPath.row].id)")) {
            cell.starredImageView.setBackgroundImage(UIImage(named: "starred.png"), forState: UIControlState.Normal)
        }
        else{
            cell.starredImageView.setBackgroundImage(UIImage(named: "unstarred.png"), forState: UIControlState.Normal)
        }
        cell.starredImageViewTappedClosure = {() in
            if defaults.boolForKey("isStarredForId\( self.emailAttributesArray[indexPath.row].id)") {
                cell.starredImageView.setBackgroundImage(UIImage(named: "unstarred.png"), forState: UIControlState.Normal)
                self.emailAttributesArray[indexPath.row].isStarred = false
                tableView.setNeedsLayout()
                tableView.layoutSubviews()
                cell.setNeedsLayout()
                cell.layoutSubviews()
            }
            else
            {
                cell.starredImageView.setBackgroundImage(UIImage(named: "starred.png"), forState: UIControlState.Normal)
                self.emailAttributesArray[indexPath.row].isStarred = true
                tableView.setNeedsLayout()
                tableView.layoutSubviews()
                cell.setNeedsLayout()
                cell.layoutSubviews()
            }
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
        checkAndUpdateMailCount()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("detailVC") as! DetailedEmailViewController
        vc.delegate = self
        vc.currentEmailId = emailAttributesArray[indexPath.row].id
        presentViewController(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


