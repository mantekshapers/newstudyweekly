//
//  DemoTestViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/18/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class DemoTestViewController: UIViewController {
    
    @IBOutlet weak var txtView: UITextView!
    
    var getUnitDetailDict:[String:AnyObject]?
    var getArticleDetailDict:[String:AnyObject]?
     var audioTimeArr = [AnyObject]()
     var audioTextAppend:String? = ""
    var counter = 0
    var locationInt:Int = 0
    var gameTimer: Timer!
    var attributedTemp = NSMutableAttributedString()
    var attributedTemp1 = NSAttributedString()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.audioTimeArr = (getUnitDetailDict?["audio_times"] as? [AnyObject])!
        for i in 0..<self.audioTimeArr.count {
            let audioDict = self.audioTimeArr[i] as! [String:AnyObject]
            let getWord = audioDict["word"] as! String
            if i == 0 {
                audioTextAppend = audioTextAppend?.appending(getWord)
            }else{
                
                audioTextAppend = audioTextAppend! + " " + getWord
            }
        }
        
        let getContentStr = getUnitDetailDict?["content"] as? String ?? ""
        
        print(getContentStr)
        let att = CustomController.stringFromHtml(string: getContentStr)
       // print("attributed string==\(CustomController.stringFromHtml(string: getContentStr))")
        attributedTemp1 = CustomController.stringFromHtml(string: getContentStr)!
       // attributedTemp.append(att!)
          txtView.attributedText = CustomController.stringFromHtml(string: getContentStr)
       // txtView.text = getContentStr
        // Do any additional setup after loading the view.
           print("attributedTemp1\(attributedTemp1)")
       }
    
    
    @IBAction func playBtnClick(_ sender: UIButton) {
        counter = 0
        locationInt = 0
        if sender.isSelected {
            sender.isSelected = false
            gameTimer.invalidate()
            gameTimer = nil
        }else {
            sender.isSelected = true
            gameTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
        
        
    }
    
    func timerAction() {
        
        if counter == self.audioTimeArr.count {
            counter = 0
            locationInt = 0
            gameTimer.invalidate()
            return
        }
        
        let getDict = self.audioTimeArr[counter] as? [String:AnyObject]
        if counter == 0 {
            
             let wordStr = getDict!["word"] as! String
            let range = NSMutableAttributedString(attributedString: attributedTemp1).mutableString.range(of: wordStr)
            locationInt = range.location
            
            print("==Helo length\(locationInt)== PRINTT RANGE==\(range)== word print==\(wordStr.count)")
        }
        
     //   let getDict = self.audioTimeArr[counter] as? [String:AnyObject]
        
        let wordStr = getDict!["word"] as! String
         print("word print123==\(wordStr.count) and word==\(wordStr)")
        var lentth:Int = wordStr.count
        print("..........word count ==\(lentth)")
        //        var myString:NSString = "I AM KIRIT MODI"
        var myMutableString = NSMutableAttributedString()
        if locationInt != 0{
            // let string = getAtributedStr?.string
            myMutableString = NSMutableAttributedString(attributedString: attributedTemp1)//NSMutableAttributedString(string: audioTextAppen, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
            myMutableString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.red, range: NSRange(location:locationInt ,length:lentth + 1))
        }else {
            
            myMutableString = NSMutableAttributedString(attributedString: attributedTemp1)//NSMutableAttributedString(string: audioTextAppen, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
            myMutableString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.red, range: NSRange(location:locationInt,length:lentth))
        }
        
       
       
        // set label Attribute
        txtView.attributedText = myMutableString
       
        TextToSpeechClass().startSpeechMethod(getWord:wordStr)
        locationInt = (locationInt + 1) + wordStr.count
        counter += 1
    }
    @IBAction func backBtncLICK(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
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
