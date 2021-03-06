import Foundation
import UIKit

class DetailedEmailCells: UITableViewCell {
    
    var starOrOptionTappedClosure: (()->Void)?
    @IBOutlet weak var lineOneLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineTwoLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var starOrOptionImage: UIButton!
    @IBOutlet weak var firstLetterImage: UIButton!
    @IBOutlet weak var lineOne: UILabel!
    @IBOutlet weak var lineTwo: UILabel!
    @IBOutlet weak var lineOneTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var starOrOptionTapped: UIButton!
    @IBOutlet weak var lineOneTrailingToSuperViewConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        firstLetterImage.layer.cornerRadius = firstLetterImage.frame.size.width/2
    }
    
    @IBAction func starOrOptionImageTapped(sender: AnyObject) {
        starOrOptionTappedClosure!()
    }
}