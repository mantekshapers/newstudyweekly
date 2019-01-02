//
//  BonusDetailsVC.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import Realm
import Retrolux
class BonusDetailsVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,BtnDelegate,AlertQuestionDelegate{
    
   
    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contenView: UIView!
    
    @IBOutlet weak var view_costHieght: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var view_media: UIView!
    
    @IBOutlet weak var lbl_description: UILabel!
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var tbl_constHieght: NSLayoutConstraint!
    
     var alertView = AlertQuestionAnswerView()
    
    var getUnitDetailDict = [String:AnyObject]()
    var questionArr = [AnyObject]()
     var tbl_height:Int?
    var articleId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.dataSource = self
        tblView.delegate = self
        print("Bonus detail list===\(getUnitDetailDict)")
        imgView.isHidden = true
        view_media.isHidden = true
        articleId = getUnitDetailDict["article_id"] as? String ?? "0"
        
        
//        let fetchQArr =  CDBManager().fetchArticleQstMethod(articlesId:articleId!)
//       if fetchQArr.count == 0{
        let qArr = getUnitDetailDict["questions"] as? [AnyObject]
        let qCount = qArr?.count ?? 0
        if qCount != 0 {
            // let qSArr = getUnitDetailDict?["standards"] as? [AnyObject]
             questionArr.removeAll()
            for data in qArr!{
                var dataDict = [String:AnyObject]()
                dataDict = data as! [String : AnyObject]
                dataDict["selectAns"] = "unselect" as AnyObject
                questionArr.append(dataDict as AnyObject)
               // CDBManager().addQuestionsInDB(articleId: articleId!,questDict:dataDict)
            }
            for i in 0..<questionArr.count {
                let j = i + 1
                tbl_height = 232 * j
            }
            tbl_height = tbl_height! + 50
        }else{
            tbl_constHieght.constant = 0
        }
//       }else{
//        questionArr = fetchQArr
//
//        for i in 0..<questionArr.count {
//            let j = i + 1
//            tbl_height = 232 * j
//        }
//        tbl_height = tbl_height! + 50
//
//        }
        
        
        let urlDtr = getUnitDetailDict["url"] as? String ?? ""
        
      //  "type": audio
        
      //  let qu = getDict["url"] as? String ?? "0"
        let range1 = urlDtr.range(of: ".mp4", options: .caseInsensitive)
        if (range1 != nil){
            view_media.isHidden = false
        }
        let range2 = urlDtr.range(of: ".mp3", options: .caseInsensitive)
        if (range2 != nil){
          
            
        }
        
        let range3 = urlDtr.range(of: ".jpeg", options: .caseInsensitive)
        if (range3 != nil){
            imgView.isHidden = false
            let imgeUrl = "https://" + urlDtr
            CommonWebserviceClass.downloadImgFromServer(url:URL(string: imgeUrl as? String ?? "0")!) { (DATA, RESPOSE, error) in
                if DATA != nil {
                    DispatchQueue.main.async { // Correct
                        self.imgView.image = UIImage(data: DATA!)
                    }
                }
            }
        }
        
        let range4 = urlDtr.range(of: ".jpg", options: .caseInsensitive)
        if (range4 != nil){
            imgView.isHidden = false
            let imgeUrl = "https://" + urlDtr
            CommonWebserviceClass.downloadImgFromServer(url:URL(string: imgeUrl as? String ?? "0")!) { (DATA, RESPOSE, error) in
                if DATA != nil {
                    DispatchQueue.main.async { // Correct
                        self.imgView.image = UIImage(data: DATA!)
                    }
                }
            }
        }
       
        
       lbl_header.text = getUnitDetailDict["name"] as? String ?? ""

//        let str = string.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
//        print(str)
           lbl_description.text =  CustomController.htmlTagRemoveFromString(getString: getUnitDetailDict["description"] as? String ?? "")//CustomController.stringFromHtml(string: getUnitDetailDict["description"] as? String ?? "")
      //  lbl_description.text = getUnitDetailDict["description"] as? String ?? ""
        
         CDBManager().updatePodToDB(getPodDetailDict: getUnitDetailDict)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        alertView  = (Bundle.main.loadNibNamed("AlertQuestionAnswerView", owner: self, options: nil)?.first as? AlertQuestionAnswerView)!
        alertView.alertQuestionDelegate = self
        alertView.frame = self.view.frame
        alertView.center = self.view.center
        self.view.addSubview(alertView)
        self.view.bringSubview(toFront: alertView)
        alertView.isHidden = true
        if tbl_constHieght.constant != 0{
            self.tblView.frame = CGRect(x:0,y:(self.lbl_description.frame.origin.y  + (self.lbl_description.frame.size.height + 60)),width:self.contenView.frame.size.width,height: self.tblView.frame.size.height)
            self.tbl_constHieght.constant = CGFloat(Float(tbl_height!))
            self.view_costHieght.constant = (self.tblView.frame.origin.y + self.tblView.frame.size.height) + self.tbl_constHieght.constant
            print("height_y \(self.tbl_constHieght.constant) & \(self.tblView.frame.origin.y) & label height \(self.lbl_description.frame.size.height)")
            self.scrollView.contentSize = CGSize(width: self.contenView.frame.size.width, height: (self.contenView.frame.size.height))
            
               }
        }
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 232
       }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArr.count
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
        
        let getQDict = self.questionArr[indexPath.row] as? [String:AnyObject]
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
        
        cell.lbl_question?.text = CustomController.htmlTagRemoveFromString(getString: getQStr ?? "")
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
    
    
    func answerSeleckMethod(getAnwr: String, btnTag: Int) {
        var getDict = questionArr[btnTag] as? [String:AnyObject]
        let getAnswer = getDict?["answer"] as? String
        let getQuestion_id = getDict!["question_id"] as? String
        NetworkCheckReachbility.isConnectedToNetwork { (boolTrue) in
            if boolTrue == false{
                //  self.customAlertController.showCustomAlert3(getMesage: AlertTitle.networkStr, getView: self)
                if getAnswer == getAnwr {
                    
                    print("ANSWER IS MATHCED--\(getAnwr)")
                    //  dataDict["selectAns"] = "unselect" as AnyObject
                    getDict?["selectAns"] = getAnwr as AnyObject
                    self.questionArr[btnTag] = getDict as AnyObject
                    
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
                        self?.questionArr[btnTag] = getDict as AnyObject
                         let articleIdTmp = getDict?["article_id"] as? String
                        let answer_points = String(getDict?["points_possible"] as! Int)
                       //  CDBManager().updateArticleOfQuestionMethod(articleId: articleIdTmp!, questDict: getDict!)
                        DispatchQueue.main.async {
                            self?.tblView.reloadData()
                            self?.alertView.isHidden = false
                            self?.alertView.lbl_title.text = "Correct Answer!"
                            self?.alertView.lbl_showPoints.text = "You just earned " + (answer_points + " rev points")
                            self?.alertView.img_question.image = UIImage(named: "correct_answer_image")
                           //  CDBManager().updateUserRevPointCDBData(revPoints: String(answer_points))
                         }
                     }
                    
                } else {
                    // This shouldn't be called. We should only make this request if the answer is correct
                    self?.alertView.isHidden = false
                    self?.alertView.lbl_title.text = "Wrong Answer!"
                    self?.alertView.lbl_showPoints.text = "You did not  earn" + " rev points"
                    self?.alertView.img_question.image = UIImage(named: "wrong_answer_image")
                    return
                }
            }
        }
    }
    
    func oKayAlertBtnClick() {
        alertView.isHidden = true
    }
    
    func cancelAlertBtnClick() {
        alertView.isHidden = true
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
         //MediaClass.playVideoMethod(getUrl: "", view: contenView)
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
