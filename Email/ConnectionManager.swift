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
                       
                        emailAttributesArray.append(EmailAttributes(dictionary: element as![String : AnyObject]))
                        completion(emailAttributesArray)
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
    
    class func deleteEmail(id:Int,completion:((Bool)->Void)) {
        Alamofire.request(.DELETE, "http://192.168.10.63:8088/api/message/\(id)", parameters:nil)
            .responseJSON { response in
                if let json = response.result.value{
//                    let dataDictionary = json as! NSDictionary
                    print(json)
                    completion(true)
                }
                else{
                    completion(false)
                }
        }
    }
    
    
    class func fetchEmailAttributeForIndex(index: Int)-> EmailAttributes {
        return emailAttributesArray[index]
    }
}