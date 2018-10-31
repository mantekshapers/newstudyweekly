//
//  SearchMediaViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/23/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import AVFoundation
class SearchMediaViewController: UIViewController {
    
    @IBOutlet weak var img_searchImg: UIImageView!
    
    
    @IBOutlet weak var img_Search1: UIImageView!
    @IBOutlet weak var view_mediaContent: UIView!
    
    @IBOutlet weak var view_searchVideo: UIView!
    
    @IBOutlet weak var lbl_mediaTitle: UILabel!
    
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var btn_play: UIButton!
    var mediaType:String? = nil
    
    var getMediaDict:[String:AnyObject]?
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var urlCommon:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        print("Search media Dict=\(getMediaDict!)")
        //  "type": audio
        img_searchImg.isHidden = true
        view_mediaContent.isHidden = true
        img_Search1.isHidden = true
        view_searchVideo.isHidden = true
        let urlDtr = getMediaDict!["media_source"] as? String ?? "0"
         let urlString = urlDtr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "0"
        let mediaDescriptionStr = getMediaDict!["media_descriptio"] as? String ?? "0"
         let media_nameTitle = getMediaDict!["media_name"] as? String ?? "0"
        self.lbl_mediaTitle.text = media_nameTitle
        
        let range1 = urlDtr.range(of: ".mp4", options: .caseInsensitive)
        if (range1 != nil){
            view_mediaContent.isHidden = false
            view_searchVideo.isHidden = false
            mediaType = "mp4"
            urlCommon = urlString
          AudioPlayClass.AudioPlayShareInstant.videoSetUrlMethod(videoUrl: urlCommon!,view: self.view_searchVideo)
        }
        
        let range2 = urlDtr.range(of: ".mp3", options: .caseInsensitive)
        if (range2 != nil){
              mediaType = "mp3"
            view_mediaContent.isHidden = false
            img_searchImg.isHidden = false
             urlCommon = "http://" + urlString
            AudioPlayClass.AudioPlayShareInstant.playUsingAVPlayer(url: urlCommon!,content: img_searchImg)
           
            let coverImage = getMediaDict!["media_splash"] as? String ?? "0"
            let imgeUrl = "https://" + coverImage
            CommonWebserviceClass.downloadImgFromServer(url:URL(string: imgeUrl as? String ?? "0")!) { (DATA, RESPOSE, error) in
                if DATA != nil {
                    DispatchQueue.main.async { // Correct
                        self.img_searchImg.image = UIImage(data: DATA!)
                    }
                }
             }
            
         }

        let range3 = urlDtr.range(of: ".jpeg", options: .caseInsensitive)
        if (range3 != nil){
            img_Search1.isHidden = false
            let imgeUrl = "https://" + urlDtr
            CommonWebserviceClass.downloadImgFromServer(url:URL(string: imgeUrl as? String ?? "0")!) { (DATA, RESPOSE, error) in
                if DATA != nil {
                    DispatchQueue.main.async { // Correct
                        self.img_Search1.image = UIImage(data: DATA!)
                    }
                }
            }
        }
        
      
        let range4 = urlDtr.range(of: ".jpg", options: .caseInsensitive)
        if (range4 != nil){
            img_Search1.isHidden = false
            let imgeUrl = "https://" + urlDtr
            CommonWebserviceClass.downloadImgFromServer(url:URL(string: imgeUrl as? String ?? "0")!) { (DATA, RESPOSE, error) in
                if DATA != nil {
                    DispatchQueue.main.async { // Correct
                        self.img_Search1.image = UIImage(data: DATA!)
                    }
                }else{
                    
                }
            }
        }
        let range5 = urlDtr.range(of: ".png", options: .caseInsensitive)
        if (range5 != nil){
            img_Search1.isHidden = false
            let imgeUrl = "https://" + urlDtr
            CommonWebserviceClass.downloadImgFromServer(url:URL(string: imgeUrl as? String ?? "0")!) { (DATA, RESPOSE, error) in
                if DATA != nil {
                    DispatchQueue.main.async { // Correct
                        self.img_Search1.image = UIImage(data: DATA!)
                    }
                }
            }
        }
        self.textView.text = mediaDescriptionStr
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        AudioPlayClass.AudioPlayShareInstant.stopAudio()
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
     }
    
    @IBAction func playBtnClick(_ sender: UIButton) {
        if mediaType == "mp4"{
           AudioPlayClass.AudioPlayShareInstant.videoPlay()
       // MediaClass().videoPlay(getUrl: urlCommon!, view: self.view_searchVideo)
            
         }else {
            if !sender.isSelected {
              sender.isSelected = true
              AudioPlayClass.AudioPlayShareInstant.playAudio()
            }else {
                 sender.isSelected = false
                 AudioPlayClass.AudioPlayShareInstant.pauseAudio()
             }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
