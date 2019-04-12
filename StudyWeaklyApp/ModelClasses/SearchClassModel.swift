//
//  SearchClassModel.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/17/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation

class Standard {
    
}

class Article {
    
}

class Media {
    var audio:[AnyObject]? = []
    var images:[AnyObject]? = []
    var videos:[AnyObject]? = []
    init(audio: [AnyObject]?,images:[AnyObject]?,videos:[AnyObject]?) {
        self.audio = audio
         self.images = images
        self.videos = videos
    }
 }
 class subAudio{
   var media_id: String = ""
   var audio_name: String = ""
   var audio_splash: String = ""
   var audio_description: String = ""
   var audio_source: String = ""
 }

 class subImage{
    
     var media_id: String = ""
    var image_name: String = ""
    var image_description: String = ""
    var optimized_image_source: String = ""
    var image_source: String = ""
    var source_info: String = ""

 }
class subVideos{

    var media_id: String = ""
    var video_name: String = ""
    var video_description: String = ""
    var video_splash: String = ""
    var video_source: String = ""
    var source_info: String = ""
   
 }
