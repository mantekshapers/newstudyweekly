//
//  CommonWebserviceClass.swift
//  EasyGlamApp
//
//  Created by Man Singh on 22/11/17.
//  Copyright © 2017 Man Singh. All rights reserved.
//

import UIKit
//import CommonCrypto
import CommonCryptoModule

typealias ServiceResponse = ( Any?,Bool?) -> Void
class CommonWebserviceClass: NSObject,URLSessionDelegate, URLSessionTaskDelegate{
    class var sharedInstance: CommonWebserviceClass {
        struct Static {
            static let instance = CommonWebserviceClass()
           }
         return Static.instance
    }
    
    class  func makeHTTPGetRequest(path: String,postString: [String:String],httpMethodName:String,onCompletion:  @escaping ServiceResponse) {
        let urlString = "https://app.studiesweekly.com/online/api/v2/app/"
       // let parameters = ["user_id": "1195643"]
        var urlComponents = URLComponents(string: path)
        
        var queryItems = [URLQueryItem]()
        for (key, value) in postString {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComponents?.queryItems = queryItems

        var request = URLRequest(url: (urlComponents?.url)!)
        cookiesAppy(request: &request)
        request.httpMethod = httpMethodName
        let username = "swApiUser"
        let realm = "REST API"
        //let password = "j9fw28rv6TUdtVxr"
        // let password = "rxVtdUT6vr82wf9jwowj9fw28rv6TUdtVxr"
      //  let password = "eromrxVtdUT6vr82wf9jwowj9fw28rv6TUdtVxrmore"
        let password = "yaHeromrxVtdUT6vr82wf9jwowj9fw28rv6TUdtVxrmoreHay"
        let ha1 = md5("\(username):\(realm):\(password)")
        
        let method = "\(request.httpMethod ?? "")"
        let digestURI: String = {
            var url = ""
            url += request.url!.absoluteString
           url = url.replacingOccurrences(of:urlString, with: "")
            url = url.removingPercentEncoding!
            return url
        }()
     //  var digestURI: String = "user"
       
        let ha2 = md5("\(method):\(digestURI)")
        let nonce = "1"
        let response = md5("\(ha1):\(nonce):\(ha2)")
        let responseStr = String(response)?.lowercased()
        let headerValue = "Digest username=\"\(username)\", realm=\"\(realm)\", nonce=\"\(nonce)\", uri=\"\(digestURI)\", response=\"\(responseStr ?? "")\", opaque=\"\""
        request.addValue(headerValue, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       // request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
      //  request.setValue("339", forHTTPHeaderField: "Content-Length")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 240
        let session = URLSession(configuration: configuration, delegate: self.sharedInstance, delegateQueue: nil)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if (error != nil) {
        
                print(error!.localizedDescription)
                onCompletion(["responseError":error!.localizedDescription],false)
                return
                }
            
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 504 {
                print(httpResponse?.statusCode)
               
                onCompletion(["responseError": "Time out"],false)
                return
            }else if httpResponse?.statusCode == 500 {
                onCompletion(["responseError": "Internal Server Error"],false)
                return
            }
            
            if (data != nil) {
                print("Registration+++=======%@",response!)
                let dataStr  = String(data: data!, encoding: .utf8)
                print("data____Str+++=======%@",dataStr ?? "Data nill")
                if let range = dataStr?.range(of: "400 Bad Request", options: .caseInsensitive, range: nil, locale: nil) {
                    print("Case sensitive \(range)")
                    return
                  }
               
                if dataStr == "\n\"1\"" {
                
                onCompletion(["valueKey":"1"] ,true)
                    return
                }else if dataStr == "\n\"0\""{
                    onCompletion(["valueKey":"0"] ,true)
                    return
                }
                
               do {
               print("error message+++=======%@",data ?? "not error")
                
                let jsonResult  = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as Any
                print("main json Print=\(jsonResult)")
                    onCompletion(jsonResult ,true)
               } catch{
                    // print("error message+++=======%@",error)
                     onCompletion(NSDictionary(),false)
                 }
               }else {
                onCompletion(NSDictionary(),false)
               }
           })
          task.resume()
      }
    
  private static func cookiesAppy(request: inout URLRequest){
    if let cookie: String = UserDefaults.standard.value(forKey: "NetworkAPI.login.cookie") as? String {
        
        // This removes duplicate cookies.
        // If the server sends us too many duplicate cookies, we may get a HTTP 400 saying that the
        // cookies header is too long! What happens is the server sends us 4-5 Set-Cookie headers, and
        // when iOS sends the cookies back it lumps them into one header (no way around this without
        // ditching NSURLSession).
        //
        // To be clear, this is a hack. It's the server's fault. ;-)
        let cookies = Set(cookie.components(separatedBy: ", "))
        
        for cookie in cookies {
            //request.addValue(cookie, forHTTPHeaderField: "Cookie")
            request.addValue(cookie, forHTTPHeaderField: "Cooke")
              }
          }
        
       }
    
    //MARK: Digest url here
    
  class  func md5(_ string: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        
        let data = string.data(using: .utf8)!
        _ = data.withUnsafeBytes { bytes in
            CC_MD5(bytes, CC_LONG(data.count), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    //MARK: DOWNLOAD IMAGE FROM SERVER
    
 class func downloadImgFromServer(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    
      
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
      }
    
    
    class func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
       {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            completion(destinationUrl.path, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, error)
                                }
                                else
                                 {
                                    completion(destinationUrl.path, error)
                                 }
                            }
                            else
                             {
                                completion(destinationUrl.path, error)
                             }
                        }
                    }
                }
                else
                  {
                    completion(destinationUrl.path, error)
                  }
            })
            task.resume()
        }
    }
    

}
