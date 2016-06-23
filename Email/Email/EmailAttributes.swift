import Foundation

class EmailAttributes:NSObject  {
    var id:Int
    var isRead:Bool {
        didSet(newValue){
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: "isReadForId\(id)")
        }
    }
    var isStarred:Bool{
        didSet(newValue){
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: "isStarredForId\(id)")
        }
    }
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
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("isReadForId\(id)") == nil {
            defaults.setBool(isRead, forKey: "isReadForId\(id)")

        }
        if defaults.objectForKey("isStarredForId\(id)") == nil {
            defaults.setBool(isStarred, forKey: "isStarredForId\(id)")

        }

    }
}