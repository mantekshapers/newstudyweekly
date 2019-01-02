//
//  NetworkCheck.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation
import SystemConfiguration
import CFNetwork
import Reachability
class NetworkCheckReachbility {
    class func isConnectedToNetwork(completion: @escaping (Bool) -> ()) {
        let url = URL(string: "https://google.com")!
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        URLSession.shared.dataTask(with:request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                 completion(true)
            } else {
                 completion(false)
            }
            }.resume()
         }
   }

class NetworkCheckWifiReachbility {
    
    class func iswifi()->Bool{
        
        let reachWIFI = Reachability()
        if reachWIFI?.connection != nil {
            
//            let netStatus : NetworkStatus = reachability.currentReachabilityStatus()
//            switch (netStatus.rawValue)
//            {
//            case NotReachable.rawValue:
//                print("offline")
//                break
//            case ReachableViaWWAN.rawValue:
//                print("online")
//                break
//            case ReachableViaWiFi.rawValue:
//                print("online")
//                break
//            default :
//                print("offline")
//                break
//            }
            if reachWIFI?.isReachableViaWiFi == true{
                
                print("WIFI IS ON THIS TIME")
                return true
                
            }else {
                 print("WIFI IS OFF THIS TIME")
                 return false
                
            }
            
        }
        
        return false
    }
}


