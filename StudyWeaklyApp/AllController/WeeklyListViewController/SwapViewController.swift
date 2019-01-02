
//
//  SwapViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 11/29/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

protocol SwapDelegateClass:class{
    func swapBackDataSendMethod(index:Int,swipDict:[String:AnyObject])
}
class SwapViewController: UIViewController {

     weak var swapDelegateClass: SwapDelegateClass?
    var getDict:[String:AnyObject]?
    var getIndex:Int? = -1
    var tagArr = [Int]()
    var setArr = [AnyObject]()
    var imgView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        let getSortDict = getDict!["questions_matching_correct_answer"]  as? [String: AnyObject]
        let getSetsArr = getSortDict!["sets"]  as? [AnyObject]
        print("wiew did load setData array==\(getSetsArr)")
        var x_axix:Int = 130
        var yView_axix:Int = 74
        for i in 0..<getSetsArr!.count {
            let dict = getSetsArr?[i] as? [String:AnyObject]
            let rightDict = dict?["right"] as? [String:AnyObject]
            let getText = rightDict!["text"] as? String
             let lbl_match = UILabel()
            let view_Color = UIImageView()
            view_Color.tag = i + 10
            view_Color.frame = CGRect(x: x_axix, y: yView_axix, width: 100, height: 100)
            lbl_match.frame = CGRect(x: x_axix + 110, y: yView_axix, width: Int(self.view.frame.size.width - CGFloat(x_axix + 120)), height: 100)
           // lbl_match.backgroundColor = UIColor.red
           // view_Color.backgroundColor = UIColor.yellow
            //panRec.addTarget(self, action: "draggedView:")
            lbl_match.numberOfLines = 0
            lbl_match.text = getText
            self.view.addSubview(lbl_match)
            self.view.addSubview(view_Color)
            view_Color.image = UIImage(named: "drop_image.png")
            yView_axix = yView_axix + 120
            tagArr.append(i + 10)
            
        }

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        "sets": [
//        {
//        "left": {
//        "image": "https:\/\/s3-us-west-2.amazonaws.com\/static.studiesweekly.com\/online\/upload\/CA4_36 cover copy0.jpg",
//        "text": "Olive Mann Isbell"
//        },
//        "right": {
//        "image": "",
//        "text": "helped to open a school in one of California's mission"
//        }
//        },
        let getSortDict = getDict!["questions_matching_correct_answer"]  as? [String: AnyObject]
        let getSetsArr = getSortDict!["sets"]  as? [AnyObject]
        print("setData array==\(getSetsArr)")
        var x_axix:Int = 16
        var y_axix:Int = 74
        for i in 0..<getSetsArr!.count {
            
            let panRec = UIPanGestureRecognizer()
            let commonLeftDict = getSetsArr![i] as? [String:AnyObject]
            
            print("===Common left====\(commonLeftDict)")
            let leftDictTmp = commonLeftDict!["left"] as? [String:AnyObject]
            let imgeLeftStr = leftDictTmp!["image"] as? String
           let imgView = UIImageView()
            let imgView1 = UIImageView()
           // imgView1.backgroundColor = UIColor.red
            imgView.tag = i
            imgView1.frame = CGRect(x: x_axix, y: y_axix, width: 100, height: 100)
            imgView.frame = CGRect(x: x_axix, y: y_axix, width: 100, height: 100)
            
          //  imgView.backgroundColor = UIColor.green
            //panRec.addTarget(self, action: "draggedView:")
            imgView.tag = i
            self.view.addSubview(imgView1)
            self.view.addSubview(imgView)
            imgView1.image = UIImage(named: "drag_icon.png")
            // drag_icon
            // self.view?.bringSubview(toFront: imgView!)
            panRec.addTarget(self, action: #selector(draggedView))
            imgView.addGestureRecognizer(panRec)
            imgView.isUserInteractionEnabled = true
            y_axix = y_axix + 120
            
            if imgeLeftStr != "" {
                
                DispatchQueue.global().async {
                let urlStr = CustomController.backSlaceRemoveFromUrl(urlStr: imgeLeftStr! )
                let url = URL(string: urlStr) as? URL
                // let coverImage = getMediaDict!["media_splash"] as? String ?? "0"
                // DispatchQueue.global(qos: .background).async {
                CommonWebserviceClass.downloadImgFromServer(url:url!) { (DATA, RESPOSE, error) in
                    if DATA != nil {
                        DispatchQueue.main.async { // Correct
                            imgView.image = UIImage(data: DATA!)
                        }
                    }else{
                        
                        imgView.image = nil
                    }
                    
                    }
                }
                // }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func draggedView(sender:UIPanGestureRecognizer){
        print("panning")
        let translation = sender.translation(in: self.view)
        print("the translation x:\(translation.x) & y:\(translation.y)")
        if let img_drag = sender.view as? UIImageView {
            
            if sender.state == .began {
                //  wordButtonCenter = button.center // store old button center
               // dragCGPoint = img_drag.center
            }else if sender.state == .changed{
                
            } else if sender.state == .ended{
                
            } else if sender.state == .failed || sender.state == .cancelled {
                // button.center = wordButtonCenter // restore button center
               // img_drag.center = dragCGPoint!
            }
            //sender.view.
            var tmp_x=sender.view?.center.x  //x translation
            var tmp1_y=sender.view?.center.y //y translation
            print("x....=\(Int(tmp_x!)) && y....=\(Int(tmp1_y!))")
            //set limitation for x and y origin
            
            let imgView = sender.view as! UIImageView
            sender.view?.center = CGPoint(x: tmp_x!+translation.x, y: tmp1_y!+translation.y)
            for var i in 0..<tagArr.count {
                let tag_View = tagArr[i] as Int
                let getView = self.view.viewWithTag(tag_View) as! UIImageView
                print("view frameX===\(getView.center.x) view frameY===\(getView.center.y)")
                if (Int(tmp_x!) >= (Int(getView.frame.origin.x) + 20) && Int(tmp_x!) <= (Int(getView.frame.origin.x) + 50)) && (Int(tmp1_y!) >= Int(getView.frame.origin.y + 40) && Int(tmp1_y!) <= Int(getView.frame.origin.y + 60)){
                    let getView1 = self.view.viewWithTag(tag_View) as! UIImageView
                    let newPos = CGPoint(x:sender.view!.center.x + translation.x, y:sender.view!.center.y + translation.y)
                   // sender.view?.center = getView1.center
                    UIApplication.shared.keyWindow!.bringSubview(toFront: sender.view!)
                    // sender.view?.center = getView1.center
                    //                DispatchQueue.main.async {
                    //                     imgView.bringSubview(toFront: getView1)
                    //                }
                    // view_drop1.addSubview(sender.view!)
                    let tag = img_drag.tag as Int
                    print("===tag print ==\(tag)")
                    var getSortDict = getDict?["questions_matching_correct_answer"]  as? [String: AnyObject]
                    setArr = getSortDict?["sets"]  as! [AnyObject]
                    var setSubDict = setArr[tag] as? [String:AnyObject]
                     var CommonSubDict = setArr[i] as? [String:AnyObject]
                    
                     var setLeftDict = setSubDict?["left"] as? [String:AnyObject]
                    // var setRightDict = setSubDict?["right"] as? [String:AnyObject]
                    
                     var setRightDict = CommonSubDict?["right"] as? [String:AnyObject]
                    
                    let imgLeftTmp = setLeftDict?["image"] as? String
                    setRightDict?["image"] = imgLeftTmp as AnyObject//imgLeftTmp as AnyObject
                   // setLeftDict?["image"] = "" as AnyObject
                    //  print("left image==\(leftDict)")
                   // setSubDict?["left"] = setLeftDict as AnyObject
                    
                      print("--------------------setSubDict-----------------\(setSubDict!)")
                    //  print("commonLeft==\(commonLeftDict)")
                    CommonSubDict?["right"] = setRightDict as AnyObject
                    // print("commonRight==\(commonRightDict)")
                     print("--------------------setRightSubDict-----------------\(setSubDict!)")
                    
                    setArr[i] = CommonSubDict as AnyObject
                    getSortDict?["sets"]  = setArr as AnyObject
                    getDict?["questions_matching_correct_answer"]  = getSortDict as AnyObject
                    print("--------------------swapdictprint-----------------\(getDict!)")
                   }
                sender.setTranslation(CGPoint.zero, in: self.view)
            }
          
          //  sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
   /*
    func metho(){
        
        print("panning")
        let translation = sender.translation(in: self.view)
        print("the translation x:\(translation.x) & y:\(translation.y)")
        if let img_drag = sender.view as? UIImageView {
            
            if sender.state == .began {
                //  wordButtonCenter = button.center // store old button center
                // dragCGPoint = img_drag.center
            }else if sender.state == .changed{
                
            } else if sender.state == .ended{
                
            } else if sender.state == .failed || sender.state == .cancelled {
                // button.center = wordButtonCenter // restore button center
                // img_drag.center = dragCGPoint!
            }
            //sender.view.
            var tmp=sender.view?.center.x  //x translation
            var tmp1=sender.view?.center.y //y translation
            print("x....=\(tmp) && y....=\(tmp1)")
            //set limitation for x and y origin
            
            let imgView = sender.view as! UIImageView
            sender.view?.center = CGPoint(x: tmp!+translation.x, y: tmp1!+translation.y)
            for var i in 0..<tagArr.count {
                let tag = tagArr[i] as Int
                let getView = self.view.viewWithTag(tag) as! UIImageView
                print("view frameX===\(getView.frame.origin.x) view frameY===\(getView.frame.origin.y)")
                if (Int(tmp!) > Int((getView.frame.origin.x)) && Int(tmp!) < Int(((getView.frame.origin.x) + 100))) && Int(tmp1!) > Int((getView.frame.origin.y)) && Int(tmp1!) < Int(((getView.frame.origin.y) + 100)) {
                    let getView1 = self.view.viewWithTag(tag) as! UIImageView
                    let newPos = CGPoint(x:sender.view!.center.x + translation.x, y:sender.view!.center.y + translation.y)
                    // sender.view?.center = getView1.center
                    UIApplication.shared.keyWindow!.bringSubview(toFront: sender.view!)
                    // sender.view?.center = getView1.center
                    //                DispatchQueue.main.async {
                    //                     imgView.bringSubview(toFront: getView1)
                    //                }
                    // view_drop1.addSubview(sender.view!)
                    let tag = img_drag.tag as Int
                    print("===tag print ==\(tag)")
                    var getSortDict = getDict?["questions_matching_correct_answer"]  as? [String: AnyObject]
                    setArr = getSortDict?["sets"]  as! [AnyObject]
                    var setSubDict = setArr[tag] as? [String:AnyObject]
                    var setLeftDict = setSubDict?["left"] as? [String:AnyObject]
                    var setRightDict = setSubDict?["right"] as? [String:AnyObject]
                    let imgLeftTmp = setLeftDict?["image"] as? String
                    setRightDict?["image"] = imgLeftTmp as AnyObject//imgLeftTmp as AnyObject
                    // setLeftDict?["image"] = "" as AnyObject
                    //  print("left image==\(leftDict)")
                    // setSubDict?["left"] = setLeftDict as AnyObject
                    
                    print("--------------------setSubDict-----------------\(setSubDict!)")
                    //  print("commonLeft==\(commonLeftDict)")
                    setSubDict?["right"] = setRightDict as AnyObject
                    // print("commonRight==\(commonRightDict)")
                    print("--------------------setRightSubDict-----------------\(setSubDict!)")
                    
                    
                    setArr[tag] = setSubDict as AnyObject
                    getSortDict?["sets"]  = setArr as AnyObject
                    getDict?["questions_matching_correct_answer"]  = getSortDict as AnyObject
                    print("--------------------swapdictprint-----------------\(getDict!)")
                }
                sender.setTranslation(CGPoint.zero, in: self.view)
            }
            
            //  sender.setTranslation(CGPoint.zero, in: self.view)
        }
        
    }
    
    */
    @IBAction func backBtnClick(_ sender: UIButton) {
        
        swapDelegateClass?.swapBackDataSendMethod(index:getIndex!,swipDict:getDict!)
        
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
