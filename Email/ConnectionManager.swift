import Foundation
import Alamofire
import SystemConfiguration


public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

public class ConnectionManager{
    
    static var emailAttributesArray = [EmailAttributes]()
    
    class func fetchData(completion:(NSArray)->Void) {
        Alamofire.request(.GET, "http://127.0.0.1:8088/api/message/", parameters:nil)
            .responseJSON { response in
                if let json = response.result.value{
                    for element in (json as! NSArray)
                    {
                        emailAttributesArray.append(EmailAttributes(dictionary: element as![String : AnyObject]))
                    }
                    completion(emailAttributesArray)
                }
        }
    }
    
    class func fetchEmailBody(id:Int,completion:((String,NSArray)->Void)) {
        Alamofire.request(.GET, "http://127.0.0.1:8088/api/message/\(id)", parameters:nil)
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
        Alamofire.request(.DELETE, "http://127.0.0.1:8088/api/message/\(id)", parameters:nil)
            .responseJSON { response in
                if let json = response.result.value{
                    print(json)
                    completion(true)
                }
                else{
                    completion(false)
                }
        }
    }
    
    class func fetchEmailAttributeForIndex(index: Int)-> EmailAttributes! {
        for emailAttribute in emailAttributesArray{
            if emailAttribute.id == index
            {
                return emailAttribute
            }
        }
        return nil
    }
    
    class func emptyEmailAttributesArray() {
        emailAttributesArray.removeAll()
    }
    
    
}