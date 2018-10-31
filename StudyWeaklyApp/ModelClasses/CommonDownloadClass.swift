//
//  CommonDownloadClass.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/21/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class CommonDownloadClass: NSObject ,URLSessionDelegate,URLSessionDownloadDelegate,URLSessionTaskDelegate{
    
      var task : URLSessionTask!
    class var sharedInstanceDownload: CommonDownloadClass {
        struct Static {
            static let instance = CommonDownloadClass()
        }
        return Static.instance
    }
    
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
        
    }
}
