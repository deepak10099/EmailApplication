import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var starredImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    
    var emailAttributesArray = []
    override func awakeFromNib() {
        roundView.layer.cornerRadius = 3
        self.emailAttributesArray = ConnectionManager.fetchEmailAttributesArray()
        
    }
}