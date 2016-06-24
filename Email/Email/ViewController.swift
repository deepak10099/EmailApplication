import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var animatableHeader: UIView!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var unreadEmailCountLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let defaults = NSUserDefaults.standardUserDefaults()
    var emailUnreadCount = 0
    var longPressOnCell = false
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    var emailAttributesArray = [EmailAttributes]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let customView = NSBundle.mainBundle().loadNibNamed("ActionBarView", owner: self, options: nil)[0] as! ActionBarView
        animatableHeader.addSubview(customView)
        customView.closeButtonTappedClosure = { ()->() in
            if let selectedCellsArray = self.tableView.indexPathsForSelectedRows
            {
                for indexPathOfSelectedCells in selectedCellsArray {
                    self.tableView.deselectRowAtIndexPath(indexPathOfSelectedCells, animated: false)
                    self.tableView.cellForRowAtIndexPath(indexPathOfSelectedCells)?.backgroundColor = UIColor.clearColor()
                    self.longPressOnCell = false
                }
            }
        }
        customView.readUnreadButtonTappedClosure = { ()->() in
        }
        customView.deleteButtonTappedClosure = { ()->() in

        }
        tableView.allowsMultipleSelection = true
        emptyImageView.hidden = true
        tableView.addSubview(refreshControl)
        tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier:"TableViewCell")
        tableView.separatorStyle = .None
        handleRefresh()
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
            if !defaults.boolForKey("isReadForId\( emailAttribute.id)")
            {
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
        cell.roundView.hidden =  (defaults.boolForKey("isReadForId\( emailAttributesArray[indexPath.row].id)"))
        cell.bringSubviewToFront(cell.starredImageView)
        cell.contentView.userInteractionEnabled = false
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPressGesture:"))
        longPressGesture.minimumPressDuration = 1.0;
        cell.addGestureRecognizer(longPressGesture)
        if cell.roundView.hidden == false {
            let boldFont = UIFont.boldSystemFontOfSize(20.0)
            cell.nameLabel.font = boldFont
        }
        else{
            let normalFont = UIFont.systemFontOfSize(20.0)
            cell.nameLabel.font = normalFont
        }
        if (defaults.boolForKey("isStarredForId\( emailAttributesArray[indexPath.row].id)")) {
            cell.starredImageView.setBackgroundImage(UIImage(named: "starred.png"), forState: UIControlState.Normal)
        }
        else{
            cell.starredImageView.setBackgroundImage(UIImage(named: "unstarred.png"), forState: UIControlState.Normal)
        }
        cell.starredImageViewTappedClosure = {() in
            if self.defaults.boolForKey("isStarredForId\( self.emailAttributesArray[indexPath.row].id)") {
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

    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        print("highlight")
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
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.showAlertViewWithMessage("Email deleted successfully", title: "Success!")
            }
            else
            {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.showAlertViewWithMessage("Email not deleted. Check your network connection or try again later.", title: "Failure!")
            }})
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == .Delete
        {
            deleteEmailWithIndexPathRow(indexPath.row)
        }
    }

    func updateSelectedCellCount(){
        print("Selected cells: \(tableView.indexPathsForSelectedRows?.count)")
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if longPressOnCell{
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.setSelected(true, animated: true)
            tableView.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor.lightGrayColor()
            print("Selected cells: \(tableView.indexPathsForSelectedRows?.count)")
            updateSelectedCellCount()
            return
        }
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

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("deselect")
        tableView.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor.clearColor()
        print("Selected cells: \(tableView.indexPathsForSelectedRows?.count)")
    }
    func handleLongPressGesture(gestureRecognizer:UILongPressGestureRecognizer)  {
        let tappedPoint = gestureRecognizer.locationInView(tableView)
        let indexPathOfTappedCell = tableView.indexPathForRowAtPoint(tappedPoint)
        if indexPathOfTappedCell == nil {
            print("long press on table view but not on a row")
        }
        else
        {
            if (gestureRecognizer.state ==  UIGestureRecognizerState.Began)
            {
                if longPressOnCell == false{
                    print("Long press on table view at row \(indexPathOfTappedCell?.row)")
                    longPressOnCell = true
                    UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: {
                        self.animatableHeader.frame = self.unreadEmailCountLabel.frame
                        self.view.setNeedsLayout()
                        self.view.layoutSubviews()
                        }, completion: { finished in

                    })
                    tableView.selectRowAtIndexPath(indexPathOfTappedCell, animated: true, scrollPosition: UITableViewScrollPosition.None)
                    tableView.cellForRowAtIndexPath(indexPathOfTappedCell!)?.backgroundColor = UIColor.lightGrayColor()
                    updateSelectedCellCount()
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}