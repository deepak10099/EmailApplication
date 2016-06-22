import Foundation
import Alamofire

class ConnectionManager{
    
    static var emailAttributesArray = [EmailAttributes]()
    
    class func fetchData(completion:(NSArray)->Void) {
        Alamofire.request(.GET, "http://192.168.10.63:8088/api/message/", parameters:nil)
            .responseJSON { response in
                if let json = response.result.value{
                    for element in (json as! NSArray)
                    {
                        print(element["id"] as! Int)
                        let id = element["id"]
                        let isRead = element["isRead"]
                        let isStarred = element["isStarred"]
                        let participants = element["participants"]
                        let preview = element["preview"]
                        let subject = element["subject"]
                        let ts = element["ts"]
                        
                        let emailAttribute:EmailAttributes = EmailAttributes()
                        emailAttribute.id = id as! Int
                        emailAttribute.isRead = isRead as! Bool
                        emailAttribute.isStarred = isStarred as! Bool
                        emailAttribute.participants = participants as! [String]
                        emailAttribute.preview = preview as! String
                        emailAttribute.subject = subject as! String
                        emailAttribute.ts = ts as! Double
                        emailAttributesArray.append(emailAttribute)
                        
                        completion(emailAttributesArray);
                    }
                }
        }
    }
    
    class func fetchEmailBody(id:Int,completion:((String,NSArray)->Void)) {
        Alamofire.request(.GET, "http://192.168.10.63:8088/api/message/\(id)", parameters:nil)
            .responseJSON { response in
                if let json = response.result.value{
                    let dataDictionary = json as! NSDictionary
                    let emailBody:String = dataDictionary["body"] as! String
                    let emailArray:NSArray = dataDictionary["participants"] as! NSArray
                    completion(emailBody,emailArray)
                }
        }
    }
    
    
    class func fetchEmailAttributesArray()-> [EmailAttributes] {
        return emailAttributesArray
    }
}