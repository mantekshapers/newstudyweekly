//
//  TestViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/9/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import DropDown
class TestViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,TestDelegate,QTrueFalseDelegate,QrfibDelegate,UIGestureRecognizerDelegate{
   
    
    var getUnitId:String?
    @IBOutlet weak var tbleView: UITableView!
    var testQuestionArr = [AnyObject]()
    var player:AVPlayer?
    var dragCGPoint: CGPoint?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tbleView.delegate = self
        self.tbleView.dataSource = self
        self.tbleView.estimatedRowHeight = 200
        self.tbleView.rowHeight = UITableViewAutomaticDimension
         player = AVPlayer()
        // Do any additional setup after loading the view.
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // let getUserId    = NetworkAPI.userID()
       // let postDict = ["unit_id":getUnitId]
       // getUnitId
        // FOR TEST UNIT_ID = 128061
        // article_assessment
      // replace  article_assessment with assessment_info
        
        let postDict = ["unit_id":"128061"]
        CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.assessment_info, postString: postDict as [String : String], httpMethodName: "GET") { (respose, boolTrue) in
            
            if boolTrue == false{
                //let getDict = respose as! [String:AnyObject]
                DispatchQueue.main.async {
                    //                    self.customAlertController.showCustomAlert3(getMesage: getDict["responseError"] as! String, getView: self)
                    //                    appdelegate?.hideLoader()
                }
                return
            }
            
            let getDataDict = respose as? [String: AnyObject]
            
            let getDataSuccess = getDataDict!["success"] as! [String: AnyObject]
            
            let getDataArr = getDataSuccess["questions"] as? [AnyObject]
            print("---------\(getDataArr)")
            if (getDataArr?.count)!>0{
                //self.testQuestionArr = getDataArr!
                    // let qSArr = getUnitDetailDict?["standards"] as? [AnyObject]
                    for data in getDataArr!{
                        var dataDict = [String:AnyObject]()
                        dataDict = data as! [String : AnyObject]
                        dataDict["selectAns"] = "unselect" as AnyObject
                        self.testQuestionArr.append(dataDict as AnyObject)
                        }
               }
            
            DispatchQueue.main.async {
                self.tbleView.reloadData()
                print("test Question_response =\(getDataArr!)")
             }
            
            
         }
        
        
    }
    
    
    // UITableViewAutomaticDimension calculates height of label contents/text
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Swift 4.1 and below
        let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
        let typeStr = getDICT!["type"] as! String
        if typeStr == "questions_labeling"{
            return UITableViewAutomaticDimension
        }else if typeStr == "questions_true_false"{
             return 150
        }else if typeStr == "questions_rfib"{
            return 120
        }
        return UITableViewAutomaticDimension
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//         let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
//        let typeStr = getDICT!["type"] as! String
//        if typeStr == "questions_labeling" {
//        return 200
//        }else if typeStr == "questions_mc" {
//            return 100
//        }else if typeStr == "questions_open"{
//            return 50
//        }
//        return 0
//    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testQuestionArr.count
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///let cell = UITableViewCell()
        let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
                let typeStr = getDICT!["type"] as! String
                if typeStr == "questions_labeling" {
           
                    var cell: TestLblingCell! = tbleView.dequeueReusableCell(withIdentifier: "TestLblingCell") as? TestLblingCell
                    if cell == nil {
                        tbleView.register(UINib(nibName: "TestLblingCell", bundle: nil), forCellReuseIdentifier: "TestLblingCell")
                        cell = tbleView.dequeueReusableCell(withIdentifier: "TestLblingCell") as? TestLblingCell
                    }
                    
                   // let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
                    let questStr = getDICT!["question"]  as? String
                    cell.lbl_question.attributedText = CustomController.stringFromHtml(string: questStr!)
                    let imgDict = getDICT!["questions_labeling_q_data"] as? [String: AnyObject]
                    
                    let imgUrl = imgDict!["url"] as? String
                    
                   // let imgeUrl = "https://" + urlDtr
                    CommonWebserviceClass.downloadImgFromServer(url:URL(string: imgUrl ?? "0")!) { (DATA, RESPOSE, error) in
                        if DATA != nil {
                            DispatchQueue.main.async { // Correct
                                cell.img_imgView.image = UIImage(data: DATA!)
                            }
                        }
                    }
                    cell.btn_play.tag = indexPath.row
//                     cell.btn_drag.tag = indexPath.row
//                    cell.btn_drag1.tag = indexPath.row
                    cell.btn_play.addTarget(self, action: #selector(qmcPlayClick1(_:)), for: .touchUpInside)
                  
                    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(panGesture:)))
                   // panGesture1.minimumNumberOfTouches = 1
                    panGesture.delegate = self
                    cell.lbl_drag.tag = indexPath.row
                    cell.lbl_drag.isUserInteractionEnabled = true
                    cell.lbl_drag.addGestureRecognizer(panGesture)
                    let panGesture1 = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler1(panGesture:)))
                    // panGesture1.minimumNumberOfTouches = 1
                    panGesture1.delegate = self
                    cell.lbl_drag1.tag = indexPath.row
                    cell.lbl_drag1.isUserInteractionEnabled = true
                    cell.lbl_drag1.addGestureRecognizer(panGesture1)
                    
                    return cell
                }else if typeStr == "questions_mc" {
                    var cell: Q_mc_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_mc_Cell") as? Q_mc_Cell
                    if cell == nil {
                        tbleView.register(UINib(nibName: "Q_mc_Cell", bundle: nil), forCellReuseIdentifier: "Q_mc_Cell")
                        cell = tbleView.dequeueReusableCell(withIdentifier: "Q_mc_Cell") as? Q_mc_Cell
                    }
                  //  let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
                    cell.testDelegateCall = self
                    cell.btn_a.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_b.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_c.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_d.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_a.tag = indexPath.row
                    cell.btn_b.tag = indexPath.row
                    cell.btn_c.tag = indexPath.row
                    cell.btn_d.tag = indexPath.row
                    cell.btn_play.tag = indexPath.row
                    cell.btn_play.addTarget(self, action: #selector(qmcPlayClick(_:)), for: .touchUpInside)
                    
                    let questStr = getDICT!["question"]  as? String
                    cell.lbl_qTitle.attributedText = CustomController.stringFromHtml(string: questStr!)
                    let selectAnswer = getDICT?["selectAns"] as? String
                    let getQAswerDict = getDICT!["questions_mc_correct_answer"] as? [String: AnyObject]
                    let qAndA_a = "A. \(getQAswerDict?["a"] as? String ?? "")"
                    let qAndA_b = "B. \(getQAswerDict?["b"] as? String ?? "")"
                    let qAndA_c = "C. \(getQAswerDict?["c"] as? String ?? "")"
                    let qAndA_d = "D. \(getQAswerDict?["d"] as? String ?? "")"
                    cell.btn_a.setTitle(qAndA_a, for: .normal)
                    cell.btn_b.setTitle(qAndA_b, for: .normal)
                    cell.btn_c.setTitle(qAndA_c, for: .normal)
                    cell.btn_d.setTitle(qAndA_d, for: .normal)
                    if selectAnswer == "a"{
                      cell.btn_a.backgroundColor = UIColor.green
                    }else if selectAnswer == "b"{
                        cell.btn_b.backgroundColor = UIColor.green
                    }else if selectAnswer == "c"{
                         cell.btn_c.backgroundColor = UIColor.green
                       
                    }else if selectAnswer == "d" {
                         cell.btn_d.backgroundColor = UIColor.green
                    }
                   
                    return cell
                  
                }else if typeStr == "questions_true_false"{
                    //questions_true_false
                    var cell: Q_true_false_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_true_false_Cell") as? Q_true_false_Cell
                if cell == nil {
                        tbleView.register(UINib(nibName: "Q_true_false_Cell", bundle: nil), forCellReuseIdentifier: "Q_true_false_Cell")
                        cell = tbleView.dequeueReusableCell(withIdentifier: "Q_true_false_Cell") as? Q_true_false_Cell
                    }
                    
                    cell.qTrueFalseDelegate = self
                    cell.btn_yes.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_no.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_play.tag = indexPath.row
                    cell.btn_yes.tag = indexPath.row
                    cell.btn_no.tag = indexPath.row
                    cell.btn_play.addTarget(self, action: #selector(qmcPlayClick(_:)), for: .touchUpInside)
                    
                    let questStr = getDICT!["question"]  as? String
                    cell.lbl_qTitle.attributedText = CustomController.stringFromHtml(string: questStr!)
                    let selectAnswer = getDICT?["selectAns"] as? String
//                    let getQAswerDict = getDICT!["questions_mc_correct_answer"] as? [String: AnyObject]
                    let qAndA_a = "A. True"
                    let qAndA_b = "B. False"
                  
                    cell.btn_yes.setTitle(qAndA_a, for: .normal)
                    cell.btn_no.setTitle(qAndA_b, for: .normal)
                   
                     if selectAnswer == "Yes"{
                        cell.btn_yes.backgroundColor = UIColor.green
                     }else if selectAnswer == "No"{
                        cell.btn_no.backgroundColor = UIColor.green
                      }
                    
                    return cell
                }else if typeStr == "questions_rfib"{
                    //questions_true_false
                    var cell: Q_rfib_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_rfib_Cell") as? Q_rfib_Cell
                    if cell == nil {
                        tbleView.register(UINib(nibName: "Q_rfib_Cell", bundle: nil), forCellReuseIdentifier: "Q_rfib_Cell")
                        cell = tbleView.dequeueReusableCell(withIdentifier: "Q_rfib_Cell") as? Q_rfib_Cell
                    }
                      cell.qrfibDelegate = self
                    cell.btn_qrPlay.tag = indexPath.row
                    cell.btn_down.tag = indexPath.row
                    cell.btn_qrPlay.addTarget(self, action: #selector(qmcPlayClick(_:)), for: .touchUpInside)
                    
                    let questStr = getDICT!["question"]  as? String
                    cell.lbl_qrTitle.attributedText = CustomController.stringFromHtml(string: questStr!)
                   
                    return cell
        }/*else if typeStr == "questions_open"{
                    //questions_true_false
                    var cell: Q_open_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_open_Cell") as? Q_open_Cell
                    if cell == nil {
                        tbleView.register(UINib(nibName: "Q_open_Cell", bundle: nil), forCellReuseIdentifier: "Q_open_Cell")
                        cell = tbleView.dequeueReusableCell(withIdentifier: "Q_open_Cell") as? Q_open_Cell
                    }
                    return cell
                    
                }else if typeStr == "questions_sorting"{
                    //questions_true_false
                    var cell: Q_sorting_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_sorting_Cell") as? Q_sorting_Cell
                    if cell == nil {
                        tbleView.register(UINib(nibName: "Q_sorting_Cell", bundle: nil), forCellReuseIdentifier: "Q_sorting_Cell")
                        cell = tbleView.dequeueReusableCell(withIdentifier: "Q_sorting_Cell") as? Q_sorting_Cell
                    }
                    return cell
                    
             }else if typeStr == "questions_matching"{
                    //questions_true_false
                    var cell: Q_match_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_match_Cell") as? Q_match_Cell
                    if cell == nil {
                    tbleView.register(UINib(nibName: "Q_match_Cell", bundle: nil), forCellReuseIdentifier: "Q_match_Cell")
                    cell = tbleView.dequeueReusableCell(withIdentifier: "Q_match_Cell") as? Q_match_Cell
                    }
                    return cell
                }else if typeStr == "questions_rfib"{
                    //questions_true_false
                    var cell: Q_rfib_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_rfib_Cell") as? Q_rfib_Cell
                    if cell == nil {
                    tbleView.register(UINib(nibName: "Q_rfib_Cell", bundle: nil), forCellReuseIdentifier: "Q_rfib_Cell")
                    cell = tbleView.dequeueReusableCell(withIdentifier: "Q_rfib_Cell") as? Q_rfib_Cell
                    }
                    return cell
                }else if typeStr == "questions_check_all"{
                    //questions_true_false
                    var cell: Q_check_all_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_check_all_Cell") as? Q_check_all_Cell
                    if cell == nil {
                    tbleView.register(UINib(nibName: "Q_check_all_Cell", bundle: nil), forCellReuseIdentifier: "Q_check_all_Cell")
                    cell = tbleView.dequeueReusableCell(withIdentifier: "Q_check_all_Cell") as? Q_check_all_Cell
                    }
                    return cell
                }
 */
        
        return UITableViewCell()
    }
    
    
    @objc func panGestureHandler1(panGesture recognizer: UIPanGestureRecognizer) {
       // let buttonTag = (recognizer.view?.tag)!
       // if let button = view.viewWithTag(buttonTag) as? UILabel {
        let translation = recognizer.translation(in: self.view)
           if let img_drag = recognizer.view as? UILabel{
            if recognizer.state == .began {
              //  wordButtonCenter = button.center // store old button center
                print("Cell Index==\(img_drag.tag)")
                dragCGPoint = img_drag.center
            } else if recognizer.state == .ended || recognizer.state == .failed || recognizer.state == .cancelled {
                print("Cell Index==end=\(img_drag.tag)")
                img_drag.center = dragCGPoint!
               // button.center = wordButtonCenter // restore button center
            } else {
               // let location = recognizer.location(in: view) // get pan location
              //  button.center = location // set button to where finger is
                      let translation = recognizer.translation(in: self.view)
                      // if let img_drag = recognizer.view as? UILabel{
                           img_drag.center = CGPoint(x: img_drag.center.x + translation.x, y: img_drag.center.y + translation.y)
                       // }
            }
             recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        }
        
//        let translation = recognizer.translation(in: self.view)
//        if let img_drag = recognizer.view as? UIImageView{
//            img_drag.center = CGPoint(x: img_drag.center.x + translation.x, y: img_drag.center.y + translation.y)
//        }
//        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
    }
    
    @objc func panGestureHandler(panGesture recognizer: UIPanGestureRecognizer) {
        let buttonTag = (recognizer.view?.tag)!
        if let img_drag = recognizer.view as? UILabel {

            if recognizer.state == .began {
                //  wordButtonCenter = button.center // store old button center
                 dragCGPoint = img_drag.center
            } else if recognizer.state == .ended || recognizer.state == .failed || recognizer.state == .cancelled {
                // button.center = wordButtonCenter // restore button center
                 img_drag.center = dragCGPoint!
            } else {
                let location = recognizer.location(in: view) // get pan location
                //  button.center = location // set button to where finger is
                let translation = recognizer.translation(in: self.view)
                // if let img_drag = recognizer.view as? UILabel{
                img_drag.center = CGPoint(x: img_drag.center.x + translation.x, y: img_drag.center.y + translation.y)
            }
             recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        }
//        let translation = recognizer.translation(in: self.view)
//        if let img_drag = recognizer.view as? UIImageView{
//            img_drag.center = CGPoint(x: img_drag.center.x + translation.x, y: img_drag.center.y + translation.y)
//        }
//        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
    }
    
    func qmcPlayClick1(_ sender: UIButton){
        let indexBtn = sender.tag
        
        let getDICT = testQuestionArr[indexBtn] as? [String: AnyObject]
        let AUDIOuRL = getDICT!["audio_url"] as? String
       // MediaClass().playMPSongMethod(urlMp: "https://" + AUDIOuRL!)
         playMethod(urlMP: AUDIOuRL!)
    }
    func qmcPlayClick(_ sender: UIButton) {
       let indexBtn = sender.tag
        
          let getDICT = testQuestionArr[indexBtn] as? [String: AnyObject]
        let AUDIOuRL = getDICT!["audio_url"] as? String
         playMethod(urlMP: AUDIOuRL!)
    }
    func playMethod(urlMP: String){
        let urlMp3 = URL(string: "http://" + urlMP)
        player = AVPlayer(url: urlMp3!)
        player?.play()
       }
    
    func answerSeleckMethod(getAnwr: String, btnTag: Int) {
        
         var getDict = testQuestionArr[btnTag] as? [String: AnyObject]
        
        let qAnserDict = getDict?["questions_mc_correct_answer"] as? [String: AnyObject]
        // let qAnserStr = qAnserDict!["answer"] as? String
        getDict?["selectAns"] = getAnwr as AnyObject
       // let selectAnswer = getDict?["selectAns"] as? String
//        if getAnwr == qAnserStr {
//            getDict?["selectAns"] = getAnwr as AnyObject
//        }else {
//             getDict?["selectAns"] = "unselect" as AnyObject
//        }
        
        testQuestionArr[btnTag] = getDict as AnyObject
        DispatchQueue.main.async {
            self.tbleView.reloadData()
        }
      }
    
    func answerTrueFalseMethod(answr: String, indexTag: Int) {
        
        var getDict = testQuestionArr[indexTag] as? [String: AnyObject]
        
        let qAnserDict = getDict?["questions_mc_correct_answer"] as? [String: AnyObject]
        // let qAnserStr = qAnserDict!["answer"] as? String
        getDict?["selectAns"] = answr as AnyObject
        // let selectAnswer = getDict?["selectAns"] as? String
        //        if getAnwr == qAnserStr {
        //            getDict?["selectAns"] = getAnwr as AnyObject
        //        }else {
        //             getDict?["selectAns"] = "unselect" as AnyObject
        //        }
        
        testQuestionArr[indexTag] = getDict as AnyObject
        DispatchQueue.main.async {
            self.tbleView.reloadData()
        }
        
    }
    
    
    func dropDownBtnClickSender(answr: String, indexTag: Int) {
        
    }
    
    @IBAction func finishTestBtnClick(_ sender: UIButton) {
        
      }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
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
