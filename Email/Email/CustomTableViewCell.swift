import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    var starredImageViewTappedClosure:((Void)->Void)?
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starredImageView: UIButton!
    
    override func awakeFromNib() {
        roundView.layer.cornerRadius = 3
    }
    
   
    @IBAction func starredImageViewTapped(sender: AnyObject) {
        starredImageViewTappedClosure!()
    }
}