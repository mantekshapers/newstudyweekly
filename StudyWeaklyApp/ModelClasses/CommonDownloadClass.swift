//
//  CommonDownloadClass.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/21/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import Photos
class CommonDownloadClass: NSObject{
   
  //  URLSessionDelegate,URLSessionDownloadDelegate,URLSessionTaskDelegate
      var task : URLSessionTask!
    class var sharedInstanceDownload: CommonDownloadClass {
        struct Static {
            static let instance = CommonDownloadClass()
        }
        return Static.instance
    }
    
    
    
    func saveVideo(getMediDict:[String:AnyObject],completion: @escaping (String?, Error?) -> Void) {
        
        let mediaSource = getMediDict["media_source"] as! String
        let mediaUrlStr = "https://" +  CustomController.backSlaceRemoveFromUrl(urlStr: mediaSource)
        
       // http://freetone.org/ring/stan/iPhone_5-Alarm.mp3
        if let audioUrl = URL(string: mediaUrlStr) {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                        CDBManager().addSearchMediaInDB(getSearchDict: getMediDict)
                        completion("success",nil)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
            }
        }
        
        /*
        DispatchQueue.global(qos: .userInitiated).async {
            guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            if !FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent(url.lastPathComponent).path) {
                URLSession.shared.downloadTask(with: url) { (location, response, error) -> Void in
                    guard let location = location else { return }
                    let destinationURL = documentsDirectoryURL.appendingPathComponent(response?.suggestedFilename ?? url.lastPathComponent)
                    
                    do {
                        try FileManager.default.moveItem(at: location, to: destinationURL)
                        PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in
                            if authorizationStatus == .authorized {
                                PHPhotoLibrary.shared().performChanges({
                                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationURL)}) { completed, error in
                                        DispatchQueue.main.async {
                                            if completed {
                                              //  self.view.makeToast(NSLocalizedString("Video Saved!", comment: "Video Saved!"), duration: 3.0, position: .center)
                                            } else {
                                                print(error!)
                                            }
                                        }
                                }
                            }
                        })
                    } catch { print(error) }
                    
                    }.resume()
            } else {
                print("File already exists at destination url")
            }
        }
        */
    }
    
    
    func fetchMediaFromDocument(urlStr: String)->URL{
        
       // http://freetone.org/ring/stan/iPhone_5-Alarm.mp3
       // if let audioUrl = URL(string: "http://freetone.org/ring/stan/iPhone_5-Alarm.mp3"){
        
        let audioUrl = URL(string: urlStr)
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent((audioUrl?.lastPathComponent)!)
            
            //let url = Bundle.main.url(forResource: destinationUrl, withExtension: "mp3")!
            return destinationUrl
        //}
       
    }
    
    /*
    lazy var session : URLSession = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        // let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.mainQueue)
        // let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        return session
    }()
    
    func downloadVideoFile(urlFile:String){
        // s3-us-west-2.amazonaws.com/static.studiesweekly.com/online/masterResources/audio/new35/149076/final.mp3
        // let s = "https://dl.dropboxusercontent.com/u/87285547/09%20Working%20Man_%20Finding%20My%20Way.mp3"
        let s = "https://s3-us-west-2.amazonaws.com/static.studiesweekly.com/online/masterResources/audio/new35/149076/final.mp3"
        let url = NSURL(string:s)!
        let req = NSMutableURLRequest(url:url as URL)
        let task = self.session.downloadTask(with: req as URLRequest)
        self.task = task
        task.resume()
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        print("downloaded \(100*writ/exp)")
        // self.counter = Float(100*writ/exp)
        return
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        // unused in this example
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("completed: error: \(error)")
    }

    // this is the only required NSURLSessionDownloadDelegate method
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    
        print("didFinishDownloading")
        print("did Finish Download==\(location)")
        
    }
    */
    
}
