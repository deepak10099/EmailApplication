import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var emailAttributesArray = [EmailAttributes]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier:"TableViewCell")
        self.tableView.separatorStyle = .None
        ConnectionManager.fetchData({(array:NSArray) in
            self.emailAttributesArray = ConnectionManager.fetchEmailAttributesArray()
            self.tableView.reloadData()
        })

        // Do any additional setup after loading the view, typically from a nib.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailAttributesArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 118.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! CustomTableViewCell
        cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
        cell.nameLabel.text = self.emailAttributesArray[indexPath.row].participants[0]
        cell.previewLabel.text = self.emailAttributesArray[indexPath.row].preview
        cell.subjectLabel.text = self.emailAttributesArray[indexPath.row].subject
        cell.roundView.hidden = self.emailAttributesArray[indexPath.row].isRead
        if cell.roundView.hidden == false {
            var boldFont = UIFont.boldSystemFontOfSize(20.0)
            cell.nameLabel.font = boldFont
        }
        if (self.emailAttributesArray[indexPath.row].isStarred == true) {
            cell.starredImageView.image = UIImage(named: "starred.png")
        }
        else{
            cell.starredImageView.image = UIImage(named: "unstarred.png")
        }

        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
            tableView.numberOfRowsInSection(0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


