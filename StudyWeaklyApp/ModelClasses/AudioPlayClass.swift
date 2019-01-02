//
//  AudioPlayClass.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/24/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class AudioPlayClass: NSObject {
    
    var sliderr = UISlider()
     var audioPlay = AVPlayer()
    var timer:Timer!
    var timeHold:Float? = 0.0
    var playerLayer: AVPlayerLayer?
   // var player = AVPlayer()
    
    class var AudioPlayShareInstant: AudioPlayClass {
        struct Static {
            static let instance = AudioPlayClass()
        }
        return Static.instance
    }
    
    
    func playUsingAVPlayer(url: String,content:UIView) {
        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        let url = URL(string:urlString )
                let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
                audioPlay = AVPlayer(playerItem: playerItem)
        
                let playerLayer=AVPlayerLayer(player: audioPlay)
                playerLayer.frame = CGRect(x: 10, y:content.frame.size.height - 40, width:content.frame.size.width - 20, height:40)
               // content.layer.addSublayer(playerLayer)
                sliderr.frame = CGRect(x: 20, y:content.frame.size.height, width:content.frame.size.width - 40, height:40)
             content.addSubview(sliderr)
          }
    
    func playAudio() {
        let currentItem = audioPlay.currentItem
        let duration = currentItem?.asset.duration
        sliderr.maximumValue = Float(CMTimeGetSeconds(duration!))
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        audioPlay.play()
         }
    
    func pauseAudio() {
         timer.invalidate()
        audioPlay.pause()
      }
    
    func stopAudio() {
        // timer.invalidate()
        if timer == nil{
            
        }else{
             timer.invalidate()
        }
        
         audioPlay.pause()
         audioPlay.rate = 0.0
     }
    func updateTime(_ timer: Timer) {
        let currentItem = audioPlay.currentItem
        let duration = currentItem?.currentTime()
        
        if timeHold! > 0.0{
            
            if timeHold == Float((duration?.seconds)!/60){
                timer.invalidate()
              }
         }
        print("=====\(Float((duration?.seconds)!/60))")
      //  let minutes = Int(duration / 60) % 60
        sliderr.value =   Float(((duration?.seconds)!))
       
    }
    func videoSetUrlMethod(videoUrl:String,view: UIView,superView1: UIView) {
        let urlString = videoUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
       // let urlStr = "https://" + urlString
        let url = URL(string: urlString)
        //  let urlString = getUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "0"
        // let videoURL = URL(string: "https://" + urlString)
        audioPlay = AVPlayer(url: url!)
        let playerLayer = AVPlayerLayer(player: audioPlay)
        playerLayer.frame = CGRect(x: superView1.frame.origin.x, y: superView1.frame.origin.y, width: superView1.frame.size.width, height: 200)
        view.layer.addSublayer(playerLayer)
        
    }
    
    func videoPlay(){
        audioPlay.play()
    }
    
    func stopVideoMethod(){
        audioPlay.pause()
    }
    
    
    

}
