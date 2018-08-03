//
//  NetworkCheck.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation
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


