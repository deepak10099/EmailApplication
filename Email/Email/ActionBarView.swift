import Foundation
import UIKit

class ActionBarView: UIView {

    @IBOutlet weak var readUnreadButton: UIButton!
    var deleteButtonTappedClosure: (()->Void)?
    var closeButtonTappedClosure: (()->Void)?
    var readUnreadButtonTappedClosure: (()->Void)?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func closeButtonTapped(sender: AnyObject) {
        closeButtonTappedClosure!()
    }
    
    @IBAction func deleteButtonTapped(sender: AnyObject) {
        deleteButtonTappedClosure!()
    }

    @IBAction func readUnreadButtonTapped(sender: AnyObject) {
        readUnreadButtonTappedClosure!()
    }
}

