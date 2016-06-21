import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var roundView: UIView!
    
    override func awakeFromNib() {
        roundView.layer.cornerRadius = 3
    }
}