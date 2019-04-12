//
//  MediaClass.swift
//  StudiesWeekly
//
//  Created by Man Singh on 9/25/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//
import UIKit
import Foundation
import AVKit
import MediaPlayer
class MediaClass:NSObject {
    
    var moviePlayer  = MPMoviePlayerController()
    var mpPlay:AVPlayer = AVPlayer()
 func playVideoMethod(getUrl:String,view: UIView){
    let videoURL = URL(string: "https://s3-us-west-2.amazonaws.com/static.studiesweekly.com/online/resources/pod_media/pod_video_us_flag_FINAL_720p.mp4")
    /*
  //  let urlString = getUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "0"
   // let videoURL = URL(string: "https://" + urlString)
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.frame
        view.layer.addSublayer(playerLayer)
        player.play()
    */
    
//    moviePlayer = MPMoviePlayerController(contentURL: videoURL)
//    moviePlayer.view.frame = view.frame
//
//    view.addSubview(moviePlayer.view)
//   // moviePlayer.isFullscreen = true
//    moviePlayer.controlStyle = MPMovieControlStyle.embedded
    
    
    let player = AVPlayer(url: videoURL!)
    let vc = AVPlayerViewController()
       vc.player = player
    
      view.addSubview(vc.view)
      vc.player?.play()
//    present(vc, animated: true) {
//        vc.player?.play()
//    }

    }
    
    
    
}
