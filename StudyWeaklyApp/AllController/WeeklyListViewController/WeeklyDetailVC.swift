//
//  WeeklyDetailVC.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/23/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import Realm
import Retrolux
class WeeklyDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource ,BtnDelegate,AlertQuestionDelegate{
   
     let customAlertController = CustomController()
    var alertView = AlertQuestionAnswerView()
    @IBOutlet weak var lbl_desConstHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tbl_constHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bonusHeghtConst: NSLayoutConstraint!
    
    @IBOutlet weak var view_contentConsHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var view_content: UIView!
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lbl_headerTitle: UILabel!
    
    @IBOutlet weak var lbl_describtions: UILabel!
    
    @IBOutlet weak var btn_collect: UIButton!
    
    
    @IBOutlet weak var btn_playOut: UIButton!
    
    var counter = 0
    var locationInt:Int = 0
    var gameTimer: Timer!
    
    var getUnitDetailDict:[String:AnyObject]?
     var getArticleDetailDict:[String:AnyObject]?
    var audioTimeArr = [AnyObject]()
    var questionData = [AnyObject]()
     var podMediaData = [AnyObject]()
    var audioTextAppend:String? = ""
    var tbl_height:Int?
    var unitsId:String?
    var articleId:String?
    var getAtributedStr:NSAttributedString?
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self
        alertView  = (Bundle.main.loadNibNamed("AlertQuestionAnswerView", owner: self, options: nil)?.first as? AlertQuestionAnswerView)!
        alertView.alertQuestionDelegate = self
        alertView.frame = self.view.frame
        alertView.center = self.view.center
        self.view.addSubview(alertView)
       self.view.bringSubview(toFront: alertView)
        alertView.isHidden = true
        
        print("units detail print==\(getUnitDetailDict)")
        
        // print("units detail print==\(getArticleDetailDict)")
          unitsId = getArticleDetailDict!["unit_id"] as? String ?? "0"
        articleId = getArticleDetailDict!["article_id"] as? String ?? "0"
        StorageClass.setUnitsId(getId: unitsId!)
        StorageClass.setArticleId(getId: articleId!)
        let getTitleStr = getUnitDetailDict?["article_title"] as? String ?? ""
        
        lbl_headerTitle.text = getTitleStr
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
//      //  getAtributedStr = CustomController.stringFromHtml(string: getContentStr)
//        lbl_describtions.attributedText = CustomController.stringFromHtml(string: getContentStr)
          lbl_describtions.text = audioTextAppend
        //audioTextAppend
        
        let qArr = getUnitDetailDict?["questions"] as? [AnyObject]
        
        let podMediaArr = getUnitDetailDict?["pod_media"] as? [AnyObject]
        if podMediaArr?.count != 0{
            podMediaData = getUnitDetailDict?["pod_media"] as! [AnyObject]
        }else{
            bonusHeghtConst.constant = 0
        }
        
        if qArr?.count != 0  {
            // let qSArr = getUnitDetailDict?["standards"] as? [AnyObject]
            for data in qArr!{
                var dataDict = [String:AnyObject]()
                dataDict = data as! [String : AnyObject]
                dataDict["selectAns"] = "unselect" as AnyObject
                questionData.append(dataDict as AnyObject)
              }
//            for dataS in qSArr! {
//                 questionData.append(dataS)
//              }
            for var i in 0..<questionData.count {
                let j = i + 1
                tbl_height = 232 * j
            }
            tbl_height = tbl_height! + 50
        }else{
            tbl_constHeight.constant = 0
        }
        
        
        CDBManager().updateArticleToDB(getUnitsDetailDict: getUnitDetailDict!)
        
        
        // Do any additional setup after loading the view.
    }
  
 override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
    DispatchQueue.main.async {
        self.tblView.reloadData()
    }
   // self.scrollView.contentSize =
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if tbl_constHeight.constant != 0{
        self.tblView.frame = CGRect(x:0,y:(self.lbl_describtions.frame.origin.y  + (self.lbl_describtions.frame.size.height + 60)),width:self.view_content.frame.size.width,height: self.tblView.frame.size.height)
        self.tbl_constHeight.constant = CGFloat(Float(tbl_height!))
        self.view_contentConsHeight.constant = (self.tblView.frame.origin.y + self.tblView.frame.size.height) + self.tbl_constHeight.constant
        
        print("height_y \(self.tbl_constHeight.constant) & \(self.tblView.frame.origin.y) & label height \(self.lbl_describtions.frame.size.height)")
        self.scrollView.contentSize = CGSize(width: self.view_content.frame.size.width, height: (self.view_content.frame.size.height))
        }
       }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 232
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionData.count
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: QuestionTableViewCell! = tblView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as? QuestionTableViewCell
        if cell == nil {
            tblView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
            cell = tblView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as? QuestionTableViewCell
        }
        cell.btnDelegateCall = self
        cell.btn_out.tag = indexPath.row
        cell.btn_b.tag = indexPath.row
        cell.btn_c.tag = indexPath.row
        cell.btn_d.tag = indexPath.row
        
        let getQDict = self.questionData[indexPath.row] as? [String:AnyObject]
        let selectAnswer = getQDict?["selectAns"] as? String
        let answer_points = String(getQDict?["points_possible"] as! Int)
     
        let getQStr = getQDict!["question"] as? String
        let getAStr = getQDict!["a"] as? String
        let getBStr = getQDict!["b"] as? String
        let getCStr = getQDict!["c"] as? String
        let getDStr = getQDict!["d"] as? String
        
        let getDificultStr = getQDict!["difficulty"] as? String
        if getDificultStr == "1" {
          cell.view_qType.backgroundColor = CustomBGColor.qHeaderCellBGColor
            cell.lbl_qtype.text = "Easy Question:"
        }else if getDificultStr == "2" {
             cell.view_qType.backgroundColor = CustomBGColor.qHeaderCellBGColor
             cell.lbl_qtype.text = "Medium Question:"
            
        }else if getDificultStr == "3" {
             cell.view_qType.backgroundColor = CustomBGColor.qHeaderCellBGColor
             cell.lbl_qtype.text = "Hard Question:"
          }
       // let getDificultStr = getQDict!["d"] as? String
        
        cell.lbl_question?.text = getQStr
        cell.lbl_a?.text = getAStr
        cell.lbl_b?.text = getBStr
        cell.lbl_c?.text = getCStr
        cell.lbl_d?.text = getDStr
        cell.img_a.image = UIImage()
        cell.img_b.image = UIImage()
        cell.img_c.image = UIImage()
        cell.img_d.image = UIImage()
        if selectAnswer == "a"{
         cell.img_a?.image = UIImage(named: "circle-check")
         cell.lbl_points.text = "+ \(answer_points)" + ( " rev points")
        }else if selectAnswer == "b"{
             cell.img_b?.image = UIImage(named: "circle-check")
            cell.lbl_points.text = "+\(answer_points)" + " rev points"
        }else if selectAnswer == "c"{
            
             cell.img_c?.image = UIImage(named: "circle-check")
            cell.lbl_points.text = "+\(answer_points)" + (" rev points")
        }else if selectAnswer == "d" {
            
             cell.img_d.image = UIImage(named: "circle-check")
            cell.lbl_points.text = "+\(answer_points)" + ("rev points")
         }
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        print("You tapped cell number \(indexPath.row).")
        
        //let getDict = unitArr[indexPath.item] as? [String:AnyObject]
        
//        let story = UIStoryboard.init(name: "Main", bundle: nil)
//        let weeklyDetailVC  =  story.instantiateViewController(withIdentifier: "WeeklyDetailVC") as! WeeklyDetailVC
//        weeklyDetailVC.getUnitDetailDict = getDict
//        self.navigationController?.pushViewController(weeklyDetailVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      //  let headerView = Bundle.main.loadNibNamed("ExampleTableHeaderView", owner: self, options: nil)?.first as? UIView
        let headerView1 = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as? HeaderView
        headerView1?.lbl_headerTitle.text = "Questions"
        
        return headerView1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    // cell btn delegate method call
    
    func answerSeleckMethod(getAnwr: String,btnTag: Int) {
    
        var getDict = questionData[btnTag] as? [String:AnyObject]
        let getAnswer = getDict?["answer"] as? String
        let getQuestion_id = getDict!["question_id"] as? String
        NetworkCheckReachbility.isConnectedToNetwork { (boolTrue) in
            if boolTrue == false{
//                self.customAlertController.showCustomAlert3(getMesage: AlertTitle.networkStr, getView: self)
                if getAnswer == getAnwr {
                    
                    print("ANSWER IS MATHCED--\(getAnwr)")
                    //  dataDict["selectAns"] = "unselect" as AnyObject
                    getDict?["selectAns"] = getAnwr as AnyObject
                    self.questionData[btnTag] = getDict as AnyObject
                    
                    let answer_points = String(getDict?["points_possible"] as! Int)
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                        self.alertView.isHidden = false
                        self.alertView.lbl_title.text = "Correct Answer!"
                        self.alertView.lbl_showPoints.text = "You just earned " + (answer_points + " rev points")
                        self.alertView.img_question.image = UIImage(named: "correct_answer_image")
                    }
                    
                }else {
                    self.alertView.isHidden = false
                    self.alertView.lbl_title.text = "Wrong Answer!"
                    self.alertView.lbl_showPoints.text = "You did not  earn" + " rev points"
                    self.alertView.img_question.image = UIImage(named: "wrong_answer_image")
                    print(" Answer is not matched--\(getAnwr)")
                    //getDict?["selectAns"] = getAnwr as AnyObject
                    // questionData[btnTag] = getDict as AnyObject
                }
                return
            }
            
           // let getUserId    = NetworkAPI.userID()
            
            let postDict = ["question_id":"5363600","answer": "a"]
            //        let appdelegate = UIApplication.shared.delegate as? AppDelegate
            //        DispatchQueue.main.async {
            //            appdelegate?.showLoader()
            //        }
            //
            /*
            CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.quesAns_mc, postString: postDict, httpMethodName: "POST") { (respose, boolTrue) in
                
                if boolTrue == false{
                    let getDict = respose as! [String:AnyObject]
                    DispatchQueue.main.async {
                       
                    }
                    return
                }
                
                let getDict = respose as! [String: AnyObject]
                print("----- getQuestion Response--\(getDict)")
                let errorStr = getDict["error"] as? String
                if errorStr == "you cannot update this user" || errorStr == "points are already redeemed"{
                    DispatchQueue.main.async {
                        self.customAlertController.showCustomAlert3(getMesage: errorStr!, getView: self)
                    }
                    return
                    
                }
                print("collection point response",getDict)
            }
            
            */
            
            let parameters = QuestionSendParameter(question_id: Field(getQuestion_id!), answer: Field(getAnwr))
              NetworkAPI.postMCAnswer(parameters).enqueue { [weak self] response in
                guard let isCorrect = response.body?.correct else {
                   // callback(response.error?.localizedDescription)
                    return
                   }
                if isCorrect.boolValue {
                    
                    DispatchQueue.main.async {
                        print("success \(isCorrect.boolValue) && \(isCorrect)")
                        getDict?["selectAns"] = getAnwr as AnyObject
                        self?.questionData[btnTag] = getDict as AnyObject
                        
                        let answer_points = String(getDict?["points_possible"] as! Int)
                        DispatchQueue.main.async {
                            self?.tblView.reloadData()
                            self?.alertView.isHidden = false
                            self?.alertView.lbl_title.text = "Correct Answer!"
                            self?.alertView.lbl_showPoints.text = "You just earned " + (answer_points + " rev points")
                            self?.alertView.img_question.image = UIImage(named: "correct_answer_image")
                        }
                    }

                   // callback(nil)
                    
                } else {
                    // This shouldn't be called. We should only make this request if the answer is correct
                    self?.alertView.isHidden = false
                    self?.alertView.lbl_title.text = "Wrong Answer!"
                    self?.alertView.lbl_showPoints.text = "You did not  earn" + " rev points"
                    self?.alertView.img_question.image = UIImage(named: "wrong_answer_image")
                    return
                   // debug("ERROR - Possible Data Corruption")
                    //callback(nil)
                }
            }
                /*
                guard let me = self else {
                    return
                }
                switch response.interpreted {
                case .success(let value):
                    guard let userID = value.success?.correct else {
                        self?.alertView.isHidden = false
                        self?.alertView.lbl_title.text = "Wrong Answer!"
                        self?.alertView.lbl_showPoints.text = "You did not  earn" + " rev points"
                        self?.alertView.img_question.image = UIImage(named: "wrong_answer_image")
                        return
                    }
                    DispatchQueue.main.async {
                        print("success \(userID) && \(value.success?.correct)")
                        getDict?["selectAns"] = getAnwr as AnyObject
                        self?.questionData[btnTag] = getDict as AnyObject
                        
                        let answer_points = String(getDict?["points_possible"] as! Int)
                        DispatchQueue.main.async {
                            self?.tblView.reloadData()
                            self?.alertView.isHidden = false
                            self?.alertView.lbl_title.text = "Correct Answer!"
                            self?.alertView.lbl_showPoints.text = "You just earned " + (answer_points + " rev points")
                            self?.alertView.img_question.image = UIImage(named: "correct_answer_image")
                        }
                    }
                case .failure(_):
                     print("success error")
                }
 
            }
 */
          //  NetworkAPI.postMCAnswer(parameters).enqueue(callback: )
//            let parameters = LoginParameters(username:Field((self.login_txtField?.text)!),password: Field((self.password_txtField?.text)!))
//            NetworkAPI.login(parameters).enqueue { [weak self] response in
//                guard let me = self else {
//                    DispatchQueue.main.async { self?.customAlertController.hideActivityIndicator(uiView: (self?.view)!)
//                    }
//                    return
//                }
//                DispatchQueue.main.async{
//                    self?.customAlertController.hideActivityIndicator(uiView: (self?.view)!)
//                }
//                switch response.interpreted {
//                case .success(let value):
//                    NetworkAPI.setLoginCookie(using: response)
//                    guard let userID = value.success?.user_id else {
//                        return
//                    }
//                    DispatchQueue.main.async {
//                        print("success \(userID) && \(value.success?.role ?? "")")
//                    }
//                }
//            }
      //  }
    
       }
        
    }
    
    func oKayAlertBtnClick() {
        alertView.isHidden = true
        
    }
    
    func cancelAlertBtnClick() {
         alertView.isHidden = true
    }
    
    
    
    @IBAction func downloadBtnClick(_ sender: UIButton) {
      
       // gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
      }
    
    @IBAction func collectBtnClick(_ sender: UIButton) {
        
    let getUserId    = NetworkAPI.userID()
        
        let postDict = ["article_id":articleId,"user_id": getUserId]
//        let appdelegate = UIApplication.shared.delegate as? AppDelegate
//        DispatchQueue.main.async {
//            appdelegate?.showLoader()
//        }
//
        CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.collectCointsName, postString: postDict as! [String : String], httpMethodName: "GET") { (respose, boolTrue) in
            
            if boolTrue == false{
                let getDict = respose as! [String:AnyObject]
                DispatchQueue.main.async {
//                    self.customAlertController.showCustomAlert3(getMesage: getDict["responseError"] as! String, getView: self)
//                    appdelegate?.hideLoader()
                }
                return
            }
            
            let getDict = respose as! [String: AnyObject]
            let errorStr = getDict["error"] as? String
            if errorStr == "you cannot update this user" || errorStr == "points are already redeemed"{
                 DispatchQueue.main.async {
                self.customAlertController.showCustomAlert3(getMesage: errorStr!, getView: self)
                      return
                }
              
              }
            print("collection point response",getDict)
           }
    
      }
    
    func timerAction() {
        
        if counter == self.audioTimeArr.count {
            counter = 0
            locationInt = 0
            gameTimer.invalidate()
            btn_playOut.isSelected = false
            return
          }
        
        let getDict = self.audioTimeArr[counter] as? [String:AnyObject]
        
        let wordStr = getDict!["word"] as! String
        
        let lentth:Int = wordStr.count
        //        var myString:NSString = "I AM KIRIT MODI"
        var myMutableString = NSMutableAttributedString()
       // let string = getAtributedStr?.string
        myMutableString = NSMutableAttributedString(string: audioTextAppend!, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:locationInt,length:lentth))
        // set label Attribute
         lbl_describtions.attributedText = myMutableString
        locationInt = (locationInt + 1) + wordStr.count
        counter += 1
       TextToSpeechClass().startSpeechMethod(getWord:wordStr)
    }
    
    @IBAction func bonuPointClick(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let bonusViewController  =  story.instantiateViewController(withIdentifier: "BonusViewController") as! BonusViewController
        bonusViewController.getPodMediaData = podMediaData
        self.navigationController?.pushViewController(bonusViewController, animated: true)
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
       
           //  gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
      
        
    }
    
    
    @IBAction func backBtnclick(_ sender: UIButton) {
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
