import Foundation

class EmailAttributes  {
    var id:Int
    var isRead:Bool
    var isStarred:Bool
    var participants:[String]
    var preview:String
    var subject:String
    var ts:Double
    var body:String?
    
    init(dictionary : [String : AnyObject]) {
         id = dictionary["id"] as! Int
         isRead = dictionary["isRead"] as! Bool
         isStarred = dictionary["isStarred"] as! Bool
         participants = dictionary["participants"] as! [String]
         preview = dictionary["preview"] as! String
         subject = dictionary["subject"] as! String
         ts =  dictionary["ts"] as! Double
    }
}