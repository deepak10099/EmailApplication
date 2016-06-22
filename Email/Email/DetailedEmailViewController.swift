
import Foundation
import UIKit

class DetailedEmailViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let boldFont = UIFont.boldSystemFontOfSize(16.0)
    let normalFont = UIFont.systemFontOfSize(14.0)
    
    var dataArray = ["A very long email subject that we need to check if the label grows accordingly. Deepak is doing a kickass job on this email app and using the table view is one hell of an idea!", "The Sender", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas egestas leo sit amet justo vehicula tincidunt. Nullam a ipsum vitae ipsum feugiat sodales gravida quis nibh. Integer sed condimentum mauris. Maecenas venenatis purus quis nisl consequat, ac iaculis mi congue. Nunc ac turpis vel sapien maximus iaculis. Nunc in mollis lectus. Cras sem nisi, auctor eu malesuada consectetur, bibendum et tortor. Ut interdum nisl sed magna ullamcorper, ut pulvinar ligula luctus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.Etiam in tempor est. Praesent egestas rutrum ex sed ornare. Duis mi neque, vehicula et vehicula ut, convallis nec felis. Morbi mattis vitae massa sed rhoncus. Integer pulvinar tincidunt eros. Etiam ornare metus ac viverra placerat. Integer vel nunc et quam varius accumsan at in nibh. Fusce at luctus odio, vitae dictum mauris. Nulla facilisi. Cras non lorem porta, porta neque quis, ornare urna. Proin eleifend pretium neque id vestibulum. Ut condimentum mauris nec ipsum mollis molestie. Vivamus at erat lorem. In odio dui, molestie a accumsan sit amet, semper sed arcu. Sed ornare sed justo a ultrices. Fusce non consectetur lacus"]
    @IBAction func backButtonPressed(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.tableView.registerNib(UINib(nibName: "TopTwoCells", bundle: nil), forCellReuseIdentifier:"DetailedTableViewCellOne")
        self.tableView.registerNib(UINib(nibName: "TopTwoCells", bundle: nil), forCellReuseIdentifier:"DetailedTableViewCellOne")

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let str:NSString = dataArray[indexPath.row]
        let size = self.heightNeededForText(str, withFont: UIFont.systemFontOfSize(20.0), width: self.tableView.frame.size.width, lineBreakMode: NSLineBreakMode.ByWordWrapping)
        return size + 40;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("DetailedTableViewCellOne", forIndexPath: indexPath) as! TopTwoCells
        switch indexPath.row
        {
        case 0:
            cell.starOrOptionImage.hidden = false
            cell.firstLetterImage.hidden = true
            cell.lineOne.font = boldFont
             cell.lineOne.text = dataArray[indexPath.row]
            cell.lineTwo.text = "The participants"
            cell.lineOne.textColor = UIColor.blackColor()
            cell.lineTwo.textColor = UIColor.lightGrayColor()
            cell.lineOneLeadingConstraint.constant = -20
            cell.lineTwoLeadingConstraint.constant = -20
        case 1:
            cell.firstLetterImage.hidden = false
            cell.starOrOptionImage.hidden = true
            cell.lineOne.font = normalFont
            cell.lineOne.text = dataArray[indexPath.row]
            cell.lineTwo.text = ""
            cell.lineOneLeadingConstraint.constant = 12
            cell.lineTwoLeadingConstraint.constant = 12
        case 2:
            cell.firstLetterImage.hidden = true
            cell.starOrOptionImage.hidden = true
            cell.lineOne.text = dataArray[indexPath.row]
            cell.lineOneLeadingConstraint.constant = -20
            cell.lineTwo.hidden = true
            
        default: print("to prevent exhaustion")
        }
        //cell.lineOne.text = dataArray[indexPath.row]
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