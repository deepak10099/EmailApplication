import Foundation
import UIKit

class EmailInfoPopup:UIView {
    var closeButtonTappedClosure: (()->Void)?

    @IBOutlet weak var subject: UITextView!
    @IBOutlet weak var fromParticipant: UITextView!
    @IBAction func closeButtonTapped(sender: AnyObject) {
        closeButtonTappedClosure!()
    }

}