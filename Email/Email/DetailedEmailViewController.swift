
import Foundation
import UIKit

class DetailedEmailViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let boldFont = UIFont.boldSystemFontOfSize(16.0)
    let normalFont = UIFont.systemFontOfSize(14.0)
    var delegate:ViewController! = nil
    var currentEmailId:Int? = nil
    var emailBody:String? = nil
    var currentEmailAttributeObject:EmailAttributes? = nil
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentEmailAttributeObject = ConnectionManager.fetchEmailAttributeForIndex(currentEmailId!)
        let customView = NSBundle.mainBundle().loadNibNamed("ActionBarView", owner: self, options: nil)[0] as! ActionBarView

        self.view.setNeedsLayout()
        self.view.layoutSubviews()
        headerView.addSubview(customView)
        customView.deleteButtonTappedClosure = { ()->() in
            ConnectionManager.deleteEmail((self.currentEmailAttributeObject?.id)!, completion: { (success) in
                self.delegate.handleRefresh()
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }

        customView.closeButtonTappedClosure = { ()->() in
            self.delegate.handleRefresh()
            self.dismissViewControllerAnimated(true, completion: nil)
        }

        customView.readUnreadButtonTappedClosure = { ()->() in
            self.currentEmailAttributeObject?.isRead = false
        }


        tableView.addSubview(refreshControl)
        tableView.registerNib(UINib(nibName: "DetailedEmailCells", bundle: nil), forCellReuseIdentifier:"DetailedTableViewCellOne")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
    }
    
    override func viewWillAppear(animated: Bool) {
        ConnectionManager.fetchEmailBody(currentEmailId!, completion:{(emailBody:String,participants:NSArray) in
            self.emailBody = emailBody
            self.tableView.reloadData()
        })
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        ConnectionManager.fetchEmailBody(currentEmailId!, completion:{(emailBody:String,participants:NSArray) in
            self.emailBody = emailBody
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            let str:NSString = (currentEmailAttributeObject?.subject)!
            let str2:NSString = (currentEmailAttributeObject?.participants.joinWithSeparator(","))!
            let firstLinesize =  heightNeededForText(str, withFont: UIFont.systemFontOfSize(20.0), width:  tableView.frame.size.width, lineBreakMode: NSLineBreakMode.ByWordWrapping)
            let secondLineSize =  heightNeededForText(str2, withFont: UIFont.systemFontOfSize(20.0), width:  tableView.frame.size.width, lineBreakMode: NSLineBreakMode.ByWordWrapping)
            return firstLinesize + secondLineSize + 20;
            
        case 1:
            return 55
            
        case 2:
            if emailBody != nil {
                let str:NSString = emailBody!
                let firstLinesize =  heightNeededForText(str, withFont: UIFont.systemFontOfSize(16.0), width:  tableView.frame.size.width, lineBreakMode: NSLineBreakMode.ByWordWrapping)
                return firstLinesize;
            }
            else
            {
                return 0
            }
            
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCellWithIdentifier("DetailedTableViewCellOne", forIndexPath: indexPath) as! DetailedEmailCells
        cell.contentView.userInteractionEnabled = false
        switch indexPath.row
        {
        case 0:
            cell.firstLetterImage.removeFromSuperview()
            cell.lineOne.font = boldFont
            cell.lineOne.text = currentEmailAttributeObject?.subject
            cell.lineOne.textColor = UIColor.blackColor()
            cell.lineTwo.textColor = UIColor.lightGrayColor()
            cell.lineTwo.text = currentEmailAttributeObject?.participants.joinWithSeparator(",")
            let defaults = NSUserDefaults.standardUserDefaults()
            if  defaults.boolForKey("isStarredForId\(currentEmailId!)")
            {
                cell.starOrOptionImage.setBackgroundImage(UIImage(named: "starred.png"), forState: UIControlState.Normal)
                
            }
            else{
                cell.starOrOptionImage.setBackgroundImage(UIImage(named: "unstarred.png"), forState: UIControlState.Normal)
            }
            
            cell.starOrOptionTappedClosure = {() in
                let defaults = NSUserDefaults.standardUserDefaults()
                if defaults.boolForKey("isStarredForId\(self.currentEmailId!)") {
                    cell.starOrOptionImage.setBackgroundImage(UIImage(named: "unstarred.png"), forState: UIControlState.Normal)
                    self.currentEmailAttributeObject!.isStarred = false
                    self.tableView.setNeedsLayout()
                    self.tableView.layoutSubviews()
                    cell.setNeedsLayout()
                    cell.layoutSubviews()
                }
                else
                {
                    cell.starOrOptionImage.setBackgroundImage(UIImage(named: "starred.png"), forState: UIControlState.Normal)
                    self.currentEmailAttributeObject!.isStarred = true
                    self.tableView.setNeedsLayout()
                    self.tableView.layoutSubviews()
                    cell.setNeedsLayout()
                    cell.layoutSubviews()            }
            }
            
            
        case 1:
            cell.starOrOptionImage.removeFromSuperview()
            cell.lineTwo.removeFromSuperview()
            cell.lineOne.font = normalFont
            cell.lineOne.text = currentEmailAttributeObject?.participants[0]
            cell.firstLetterImage.titleLabel?.text = Array(arrayLiteral: cell.lineOne.text! as String)[0]
            
            
        case 2:
            cell.firstLetterImage.removeFromSuperview()
            cell.lineOne.text = emailBody
            cell.lineOne.font = normalFont
            cell.starOrOptionImage.removeFromSuperview()
            cell.lineTwo.removeFromSuperview()
            
            
        default: print("")
        }
        return cell;
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func heightNeededForText(text: NSString, withFont font: UIFont, width: CGFloat, lineBreakMode:NSLineBreakMode) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        let size: CGSize = text.boundingRectWithSize(CGSizeMake(width, CGFloat.max), options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [ NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle], context: nil).size
        return ceil(size.height);
    }
}