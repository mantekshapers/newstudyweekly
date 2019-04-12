//
//  WeeklyDetailVC.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/23/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import Retrolux
import AVFoundation

extension String {
    var withoutHtmlTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

class WeeklyDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AVSpeechSynthesizerDelegate, BtnDelegate, AlertQuestionDelegate
{
    let synth = AVSpeechSynthesizer()
    let customAlertController = CustomController()
    var alertView = AlertQuestionAnswerView()
    
    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var view_content: UIView!
    @IBOutlet weak var view_Bonuscontent: UIView!
    @IBOutlet weak var viewImgBig: UIView!
    @IBOutlet weak var imgTopBig: UIImageView!
    @IBOutlet weak var tblView: UITableView!

    @IBOutlet weak var lbl_headerTitle: UILabel!
    @IBOutlet weak var lbl_describtions: UILabel!
    @IBOutlet weak var lblBonus: UILabel!
    @IBOutlet weak var btn_collect: UIButton!
    @IBOutlet weak var btnImgBig: UIButton!
    @IBOutlet weak var btnBonus: UIButton!

    @IBOutlet weak var viewMenu : UIView!
    @IBOutlet weak var btnSideMenu : UIButton!
    @IBOutlet weak var btnInitial : UIButton!
    @IBOutlet weak var btnSetting : UIButton!
    @IBOutlet weak var btnCoins : UIButton!
    @IBOutlet weak var btnLogout : UIButton!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblCoins : UILabel!
    @IBOutlet weak var lblRole : UILabel!
    
    @IBOutlet weak var viewBottom : UIView!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    @IBOutlet weak var btnCopy : UIButton!
    @IBOutlet weak var btnSearch : UIButton!
    @IBOutlet weak var btnPlay : UIButton!

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
    var articleId:String?
    var getAtributedStr:NSAttributedString?
    var successTmp = 0
    
    //MARK:- UIView Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tblView.isHidden = true
        DispatchQueue.main.async
            {

        self.customAlertController.showActivityIndicatory(uiView: self.view)
        }
        self.navigationController?.navigationBar.isHidden = true
        
        self.customAlertController.showActivityIndicatory(uiView: self.view)
        print("units detail print==\(String(describing: self.getUnitDetailDict))")
        self.articleId = self.getArticleDetailDict![WSKeyValues.article_id] as? String ?? "0"
        print("article detail print==\(String(describing: self.getArticleDetailDict))")
        
        self.collectRevPointMethod(articleId: self.articleId!)

        btnSideMenu.layer.cornerRadius = btnSideMenu.frame.size.width / 2
        btnSideMenu.layer.masksToBounds = true
        btnInitial.layer.cornerRadius = btnInitial.frame.size.width / 2
        btnInitial.layer.masksToBounds = true
        
        //Bottom Bar
        btnBack.isEnabled = true
        btnNext.isEnabled = false
        btnCopy.isEnabled = true
        btnSearch.isEnabled = true
        btnPlay.isEnabled = false

        lblBonus.layer.cornerRadius = lblBonus.frame.size.width / 2
        lblBonus.layer.masksToBounds = true
        btnBonus.layer.cornerRadius = 2.0
        btnBonus.layer.masksToBounds = true
        
        btn_collect.isHidden = true
        btn_collect.layer.cornerRadius = 2.0
        btn_collect.layer.masksToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        self.viewImgBig.addGestureRecognizer(tapGesture)

        synth.delegate = self
        
        alertView  = (Bundle.main.loadNibNamed("AlertQuestionAnswerView", owner: self, options: nil)?.first as? AlertQuestionAnswerView)!
        alertView.alertQuestionDelegate = self
        alertView.frame = self.view.frame
        alertView.center = self.view.center
        self.view.addSubview(alertView)
        self.view.bringSubview(toFront: alertView)
        alertView.isHidden = true
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        DispatchQueue.main.async
            {
                self.customAlertController.showActivityIndicatory(uiView: self.view)
                StorageClass.setUnitsId(getId: self.getArticleDetailDict![WSKeyValues.unit_id] as? String ?? "0")
                StorageClass.setArticleId(getId: self.articleId!)
                self.audioTimeArr = (self.getUnitDetailDict?[WSKeyValues.audio_times] as? [AnyObject])!
                
                for i in 0..<self.audioTimeArr.count
                {
                    let audioDict = self.audioTimeArr[i] as! [String:AnyObject]
                    let getWord = audioDict[WSKeyValues.word] as! String
                    if i == 0
                    {
                        self.audioTextAppend = self.audioTextAppend?.appending(getWord)
                    }
                    else
                    {
                        self.audioTextAppend = self.audioTextAppend! + " " + getWord
                    }
                }
                
                let getContentStr = self.getUnitDetailDict?[WSKeyValues.content] as? String ?? ""
                print("getContentStr\(getContentStr)")
                
                let contentArr : [String] = getContentStr.components(separatedBy: "//")
                let strContent22 : String = contentArr[1]

                let contentArr1 : [String] = strContent22.components(separatedBy: " ")
                let strContent1 : String = contentArr1[0]

                let contentArr2 : [String] = strContent1.components(separatedBy: "\"")
                let strContent3 : String = contentArr2[0]
                let strUrl = strContent3

                let coverUrl = "https://" + strUrl
                print("coverUrl=\(coverUrl)")

                if coverUrl.isEmpty
                {
                    print("image empty")
                    let image = UIImage(named:"bgNoImg")
                    self.imgTop.image = image
                    self.imgTopBig.image = image
                }
                else
                {
                    let url = URL(string: coverUrl)
                    DispatchQueue.global().async { [weak self] in
                        if let data = try? Data(contentsOf: url!) {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self?.imgTop.image = image
                                    self?.imgTopBig.image = image
                                }
                            }
                        }
                    }
                }
                
                //-----Frame
                self.lbl_describtions.text = self.audioTextAppend
                self.lbl_describtions.font = UIFont(name: "Helvetica Neue", size: 13.0)
                self.lbl_describtions.textColor = UIColor.black

                print("lbl_describtions y: \(self.lbl_describtions.frame.origin.y)")
                print("lbl_describtions ht: \(self.lbl_describtions.frame.size.height)")
                print("lbl_describtions frame: \(self.lbl_describtions.frame)")

                print("btn_collect y: \(self.btn_collect.frame.origin.y)")
                print("btn_collect ht: \(self.btn_collect.frame.size.height)")
                print("btn_collect frame: \(self.btn_collect.frame)")

                //audioTextAppend
                let fetchQArr =  CDBManager().fetchArticleQstMethod(articlesId:self.articleId!)
                if fetchQArr.count == 0
                {
                    let qArr = self.getUnitDetailDict?[WSKeyValues.questions] as? [AnyObject]
                    if qArr?.count != 0
                    {
                        self.tblView.isHidden = false
                        for data in qArr!
                        {
                            var dataDict = [String:AnyObject]()
                            dataDict = data as! [String : AnyObject]
                            dataDict["selectAns"] = "unselect" as AnyObject
                            self.questionData.append(dataDict as AnyObject)
                            CDBManager().addQuestionsInDB(articleId: self.articleId!,questDict:dataDict)
                        }
                        
                        for var i in 0..<self.questionData.count
                        {
                            let j = i + 1
                            self.tbl_height = 280 * j
                        }
                        self.tbl_height = self.tbl_height! + 50
                        self.tblView.frame = CGRect(x: 0, y:335, width: self.view.frame.size.width, height: 810)
                    }
                    else
                    {
                        self.tblView.isHidden = true
                        self.tblView.frame = CGRect(x: 0, y:335, width: self.view.frame.size.width, height: 0)
                    }
                    print("tbl_height: \(String(describing: self.tbl_height))")
                    print("tblView ht: \(self.tblView.frame.size.height)")
                    print("tblView frame: \(self.tblView.frame)")

                    let podMediaArr = self.getUnitDetailDict?[WSKeyValues.pod_media] as? [AnyObject]
                    if podMediaArr?.count != 0
                    {
                        self.podMediaData = self.getUnitDetailDict?[WSKeyValues.pod_media] as! [AnyObject]
                        self.view_Bonuscontent.isHidden = false
                        if self.tblView.isHidden == true //table hidden hai
                        {
                            self.view_Bonuscontent.frame = CGRect(x: 0, y: 335, width: self.view.frame.size.width, height: 50)
                        }
                        else
                        {
                            self.view_Bonuscontent.frame = CGRect(x: 0, y: 1155, width: self.view.frame.size.width, height: 50)
                        }
                        print("view_Bonuscontent y: \(self.view_Bonuscontent.frame.origin.y)")
                        print("view_Bonuscontent ht: \(self.view_Bonuscontent.frame.size.height)")
                        print("view_Bonuscontent frame: \(self.view_Bonuscontent.frame)")
                        
                        self.view_content.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50 + self.view_Bonuscontent.frame.size.height+self.view_Bonuscontent.frame.origin.y+10)

                        print("view_content y: \(self.view_content.frame.origin.y)")
                        print("view_content ht: \(self.view_content.frame.size.height)")
                        print("view_content frame: \(self.view_content.frame)")
                    }
                    else
                    {
                        self.view_Bonuscontent.isHidden = true
                        if self.tblView.isHidden == true//table hidden hai
                        {
                            self.view_content.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 548)
                        }
                        else
                        {
                            self.view_content.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1155)
                        }
                    }
                    print("view_content y: \(self.view_content.frame.origin.y)")
                    print("view_content ht: \(self.view_content.frame.size.height)")
                    print("view_content frame: \(self.view_content.frame)")
                    
                    self.scrollView.contentSize = CGSize(width: self.view_content.frame.size.width, height: self.view_content.frame.size.height)
                    
                    print("scrollView width: \(self.scrollView.contentSize.width)")
                    print("scrollView ht: \(self.scrollView.contentSize.height)")
                }
                else
                {
                    self.questionData = fetchQArr
                    for var i in 0..<self.questionData.count
                    {
                        let j = i + 1
                        self.tbl_height = 280 * j
                    }
                    self.tbl_height = self.tbl_height! + 50

                    if self.questionData.count > 0
                    {
                        self.tblView.isHidden = false
                        self.tblView.frame = CGRect(x: 0, y: 335, width: self.view.frame.size.width, height: 810)
                    }
                    else
                    {
                        self.tblView.isHidden = true
                        self.tblView.frame = CGRect(x: 0, y: 335, width: self.view.frame.size.width, height: 0)
                    }
                    print("tbl_height: \(String(describing: self.tbl_height))")
                    print("tblView ht: \(self.tblView.frame.size.height)")
                    print("tblView frame: \(self.tblView.frame)")
                    
                    let podMediaArr = self.getUnitDetailDict?[WSKeyValues.pod_media] as? [AnyObject]
                    if podMediaArr?.count != 0
                    {
                        self.view_Bonuscontent.isHidden = false
                        if self.tblView.isHidden == true //table hidden hai
                        {
                            self.view_Bonuscontent.frame = CGRect(x: 0, y: 335, width: self.view.frame.size.width, height: 50)
                        }
                        else
                        {
                            self.view_Bonuscontent.frame = CGRect(x: 0, y: 1155, width: self.view.frame.size.width, height: 50)
                        }
                        self.podMediaData = self.getUnitDetailDict?[WSKeyValues.pod_media] as! [AnyObject]
                        print("view_Bonuscontent y: \(self.view_Bonuscontent.frame.origin.y)")
                        print("view_Bonuscontent ht: \(self.view_Bonuscontent.frame.size.height)")
                        print("view_Bonuscontent frame: \(self.view_Bonuscontent.frame)")
                        
                        self.view_content.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50 + self.view_Bonuscontent.frame.size.height + self.view_Bonuscontent.frame.origin.y + 10)

                        print("view_content y: \(self.view_content.frame.origin.y)")
                        print("view_content ht: \(self.view_content.frame.size.height)")
                        print("view_content frame: \(self.view_content.frame)")
                    }
                    else
                    {
                        self.view_Bonuscontent.isHidden = true
                        if self.tblView.isHidden == true  //table hidden hai
                        {
                            self.view_content.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 548)
                        }
                        else
                        {
                            self.view_content.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1155)
                        }
                        print("view_content y: \(self.view_content.frame.origin.y)")
                        print("view_content ht: \(self.view_content.frame.size.height)")
                        print("view_content frame: \(self.view_content.frame)")
                    }
                    
                    self.scrollView.contentSize = CGSize(width: self.view_content.frame.size.width, height: self.view_content.frame.size.height + 20)
                    
                    print("scrollView width: \(self.scrollView.contentSize.width)")
                    print("scrollView ht: \(self.scrollView.contentSize.height)")

                }
                CDBManager().updateArticleToDB(getUnitsDetailDict: self.getUnitDetailDict!)
        }
        self.tblView.reloadData()
    }
  
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)
        
        let getTitleStr = getUnitDetailDict?[WSKeyValues.article_title] as? String ?? ""
        lbl_headerTitle.text = getTitleStr
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
        
        let dbArr = CDBManager().getDataFromDB() as [AnyObject]
        print(dbArr as AnyObject)
        if dbArr.count>0
        {
            let getDict = dbArr[0] as? [String:AnyObject]
            print("getDict:\(String(describing: getDict))")
            
            lblName.text = getDict?[WSKeyValues.name] as? String ?? ""
            print("Name:\(String(describing: lblName.text))")
            let getPoints = getDict![WSKeyValues.points] as? String ?? ""
            lblCoins.text = getPoints + " Coins"
            
            let userRoleStr = getDict!["userRole"] as? String ?? ""
            lblRole.text = userRoleStr
            
            let strChar = String(Array(self.lblName.text!)[0])
            print("strChar:\(strChar)")
            
            btnSideMenu.setTitle(strChar, for: .normal)
            btnInitial.setTitle(strChar, for: .normal)
        }
      //  self.customAlertController.hideActivityIndicator(uiView: self.view)
    }

    //MARK: - User Define Method
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer)
    {
        self.viewImgBig.isHidden = true
    }
    
    func answerSeleckMethod(getAnwr: String,btnTag: Int)
    {
        var getDict = questionData[btnTag] as? [String:AnyObject]
        let getAnswer = getDict?[WSKeyValues.answer] as? String
        let getQuestion_id = getDict![WSKeyValues.question_id] as? String
        
        NetworkCheckReachbility.isConnectedToNetwork { (boolTrue) in
            if boolTrue == false
            {
                if getAnswer == getAnwr
                {
                    print("ANSWER IS MATHCED--\(getAnwr)")
                    getDict?["selectAns"] = getAnwr as AnyObject
                    self.questionData[btnTag] = getDict as AnyObject
                    
                    let answer_points = String(getDict?[WSKeyValues.points_possible] as! Int)
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                        self.alertView.isHidden = false
                        self.alertView.lbl_title.text = "Correct Answer!"
                        self.alertView.lbl_showPoints.text = "You just earned " + (answer_points + " rev points")
                        self.alertView.img_question.image = UIImage(named: "correct_answer_image")
                    }
                }
                else
                {
                    self.alertView.isHidden = false
                    self.alertView.lbl_title.text = "Wrong Answer!"
                    self.alertView.lbl_showPoints.text = "You did not  earn" + " rev points"
                    self.alertView.img_question.image = UIImage(named: "wrong_answer_image")
                    print(" Answer is not matched--\(getAnwr)")
                }
                return
            }
            let postDict = ["question_id":"5363600","answer": "a"]
            print("postDict: \(postDict)")
            
            /*
             CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.assessments_answer_mc, postString: postDict, httpMethodName: "POST") { (respose, boolTrue) in
             
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
            
            //This below ws is for getting answer and check either it is correct or not
            self.customAlertController.showActivityIndicatory(uiView: self.view)
            let parameters = QuestionSendParameter(question_id: Field(getQuestion_id!), answer: Field(getAnwr))
            NetworkAPI.postMCAnswer(parameters).enqueue { [weak self] response in
                guard let isCorrect = response.body?.correct else {
                    // callback(response.error?.localizedDescription)
                    return
                }
                
                if isCorrect.boolValue
                {
                    DispatchQueue.main.async
                        {
                        print("success \(isCorrect.boolValue) && \(isCorrect)")
                        getDict?["selectAns"] = getAnwr as AnyObject
                        self?.questionData[btnTag] = getDict as AnyObject
                        let articleIdTmp = getDict?[WSKeyValues.article_id] as? String
                        
                        // CDBManager().addQuestionsInDB(articleId: articleIdTmp!,questDict:getDict!)
                        CDBManager().updateArticleOfQuestionMethod(articleId: articleIdTmp!, questDict: getDict!)
                        
                        let answer_points = String(getDict?[WSKeyValues.points_possible] as! Int)
                        DispatchQueue.main.async {
                            self?.tblView.reloadData()
                            self?.alertView.isHidden = false
                            self?.alertView.lbl_title.text = "Correct Answer!"
                            self?.alertView.lbl_showPoints.text = "You just earned " + (answer_points + " rev points")
                            self?.alertView.img_question.image = UIImage(named: "correct_answer_image")
                            CDBManager().updateUserRevPointCDBData(revPoints: String(answer_points))
                        }
                    }
                }
                else
                {
                    // This shouldn't be called. We should only make this request if the answer is correct
                    self?.alertView.isHidden = false
                    self?.alertView.lbl_title.text = "Wrong Answer!"
                    self?.alertView.lbl_showPoints.text = "You did not  earn" + " rev points"
                    self?.alertView.img_question.image = UIImage(named: "wrong_answer_image")
                    // return
                    // debug("ERROR - Possible Data Corruption")
                    //callback(nil)
                }
                self?.customAlertController.hideActivityIndicator(uiView: (self?.view)!)
            }
        }
    }
    
    func oKayAlertBtnClick()
    {
        alertView.isHidden = true
    }
    
    func cancelAlertBtnClick()
    {
        alertView.isHidden = true
    }

    func timerAction()
    {
        if counter == self.audioTimeArr.count
        {
            counter = 0
            locationInt = 0
            gameTimer.invalidate()
            btnPlay.isSelected = false
            return
        }
        
        let getDict = self.audioTimeArr[counter] as? [String:AnyObject]
        let wordStr = getDict![WSKeyValues.word] as! String
        
        let lentth:Int = wordStr.count
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: audioTextAppend!, attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 13.0)!])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 166/255, green: 166/255, blue: 237/255, alpha: 1.0), range: NSRange(location:locationInt,length:lentth))
        lbl_describtions.attributedText = myMutableString
        lbl_describtions.numberOfLines = 4
        //lbl_describtions.sizeToFit()
        //lbl_describtions.frame = CGRect(x: lbl_describtions.frame.origin.x, y: imgTop.frame.size.height + imgTop.frame.origin.y + 10, width: self.view.frame.size.width - 30 , height: lbl_describtions.frame.size.height)
        //lblDescHtConstraint.constant = lbl_describtions.frame.size.height
        
        locationInt = (locationInt + 1) + wordStr.count
        counter += 1
        TextToSpeechClass().startSpeechMethod(getWord:wordStr)
    }

    func collectRevPointMethod(articleId:String)
    {
        let postDict = ["article_id":articleId]
        self.customAlertController.showActivityIndicatory(uiView: self.view)
        CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.articleRedeem, postString: postDict as! [String : String], httpMethodName: "GET") { (respose, boolTrue) in
            self.customAlertController.showActivityIndicatory(uiView: self.view)
            if boolTrue == false
            {
                let getDict = respose as! [String:AnyObject]
                print("getDict\(getDict)")
                return
            }
            let getDict = respose as! [String: AnyObject]
            let keyArr = Array(getDict.keys)
            if keyArr .contains("error")
            {
                let errorStr = getDict["error"] as? String
                if errorStr == "you cannot update this user" || errorStr == "points are already redeemed"
                {
                    //-----Frame
                    
                    DispatchQueue.main.async {
                        self.btn_collect.isHidden = false
                    self.btn_collect.frame = CGRect(x:25, y:285, width: self.view.frame.size.width - 50, height: 40)
                    }
                    
                    self.btn_collect.setTitle("Already redeemed Rev points", for: .normal)
                    self.btn_collect.backgroundColor = UIColor.gray
                    self.btn_collect.isUserInteractionEnabled = false
                    
                    let uiAlert = UIAlertController(title: "Studies Weekly", message: errorStr!, preferredStyle: UIAlertControllerStyle.alert)
                    print("Click of default button")
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        print("Click of default button")
                        self.customAlertController.hideActivityIndicator(uiView: self.view)

                    }))
                    self.present(uiAlert, animated: true, completion: nil)
                    return
                }
            }
            else
            {
                let tmpInt = getDict["success"] as? Int
                print(tmpInt!)
                self.successTmp = tmpInt!
                if self.successTmp != nil
                {
                    self.btn_collect.setTitle("Collect 5 Rev Coins", for: .normal)
                    self.btn_collect.isUserInteractionEnabled = false
                    self.btn_collect.backgroundColor = UIColor.init(red: 254/255, green: 177/255, blue: 10/255, alpha: 1.0)
                }
            }
        }
    }
    
    //MARK: - UIBUtton Method
    @IBAction func backBtnClick(_ sender: UIButton)
    {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func menuBtnClick(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        if sender.isSelected
        {
            viewMenu.isHidden = false
            CommonFunctions.openMenu(view: viewMenu)
        }
        else
        {
            CommonFunctions.closeMenu(view: viewMenu)
        }
    }
    
    @IBAction func btnSettingsClicked(_ sender: UIButton)
    {
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        let settingController = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.SettingsViewControllerID) as! SettingsViewController
        self.navigationController?.pushViewController(settingController, animated: true)
    }
    
    @IBAction func btnLogoutClicked(_ sender: UIButton)
    {
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        CDBManager().deleteAllCDB()
        NetworkAPI.removeUserId()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootViewCallMethod(getAlertTitle:"sessionExpired")
    }
    
    @IBAction func fileBtnClick(_ sender: UIButton)
    {
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        let tabViewController  =  self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.TabViewControllerID) as! TabViewController
        self.navigationController?.pushViewController(tabViewController, animated: true)
    }
    
    @IBAction func searchBtnClick(_ sender: UIButton)
    {
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.SearchViewControllerID) as! SearchViewController
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @IBAction func homeBtnClick(_ sender: UIButton)
    {
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        DispatchQueue.main.async {
            
            for vc in (self.navigationController?.viewControllers ?? []) {
                if vc is HomeFileViewController {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
    
    @IBAction func btnBigImgClicked(_ sender: UIButton)
    {
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)
        self.viewImgBig.isHidden = false
    }
    
    @IBAction func downloadBtnClick(_ sender: UIButton)
    {
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)
        // gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @IBAction func collectBtnClick(_ sender: UIButton)
    {
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        self.btn_collect.setTitle("Redeemed Rev points", for: .normal)
        self.btn_collect.isUserInteractionEnabled = false

        
        CDBManager().updateUserRevPointCDBData(revPoints: String(successTmp))
        self.customAlertController.showCustomAlert3(getMesage: "Rev Point have successfully collect", getView: self)

        let getUserId    = NetworkAPI.userID()
        print("getUserId\(String(describing: getUserId))")

        self.customAlertController.showActivityIndicatory(uiView: self.view)
        self.collectRevPointMethod(articleId: articleId!)
    }
    
    @IBAction func bonuPointClick(_ sender: UIButton)
    {
        self.customAlertController.showActivityIndicatory(uiView: self.view)
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)
        
        let bonusViewController  =  self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.BonusViewControllerID) as! BonusViewController
        bonusViewController.getPodMediaData = podMediaData
        self.customAlertController.hideActivityIndicator(uiView: self.view)
        self.navigationController?.pushViewController(bonusViewController, animated: true)
    }
    
    @IBAction func playBtnClick(_ sender: UIButton)
    {
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        counter = 0
        locationInt = 0
        if sender.isSelected
        {
            sender.isSelected = false
            gameTimer.invalidate()
            gameTimer = nil
        }
        else
        {
            sender.isSelected = true
            gameTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
        
        //  gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        // TextToSpeechClass().startSpeechMethod(getWord:lbl_describtions.text!)
    }
    
    //MARK: - UITableView DataSource and Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 230
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return questionData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
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
        print("getQDict:\(String(describing: getQDict))")

        let selectAnswer = getQDict?["selectAns"] as? String
        print("selectAnswer:\(String(describing: selectAnswer))")

        let answer_points = String(getQDict?[WSKeyValues.points_possible] as! Int)
        print("answer_points:\(answer_points)")

     
        let getQStr = getQDict![WSKeyValues.question] as? String
        print("getQStr:\(String(describing: getQStr))")
        let getQNewStr = getQStr?.withoutHtmlTags
        print("getQNewStr!\(String(describing: getQNewStr))")

        let getAStr = getQDict!["a"] as? String
        let getBStr = getQDict!["b"] as? String
        let getCStr = getQDict!["c"] as? String
        let getDStr = getQDict!["d"] as? String
        
        print("getAStr:-\(String(describing: getAStr))")
        print("getBStr:-\(String(describing: getBStr))")
        print("getCStr:-\(String(describing: getCStr))")
        print("getDStr:-\(String(describing: getDStr))")

        let getDificultStr = getQDict![WSKeyValues.difficulty] as? String
        if getDificultStr == "1"
        {
            cell.view_qType.backgroundColor = UIColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 1.0)
            cell.lbl_qtype.text = "Easy Question:"
        }
        else if getDificultStr == "2"
        {
            cell.view_qType.backgroundColor = UIColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 1.0)
            cell.lbl_qtype.text = "Medium Question:"
        }
        else if getDificultStr == "3"
        {
            cell.view_qType.backgroundColor = UIColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 1.0)
            cell.lbl_qtype.text = "Hard Question:"
        }
        
        cell.lbl_question?.text = getQNewStr
        cell.lbl_a?.text = getAStr
        cell.lbl_b?.text = getBStr
        cell.lbl_c?.text = getCStr
        cell.lbl_d?.text = getDStr
        cell.img_a.image = UIImage()
        cell.img_b.image = UIImage()
        cell.img_c.image = UIImage()
        cell.img_d.image = UIImage()
        
        if selectAnswer == "a"
        {
            cell.img_a?.image = UIImage(named: "circle-check")
            cell.backgroundColor = UIColor.init(red: 252.0/255.0, green: 255.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            cell.lbl_points.text = "+ \(answer_points)" + " rev points"
        }
        else if selectAnswer == "b"
        {
            cell.img_b?.image = UIImage(named: "circle-check")
            cell.backgroundColor = UIColor.init(red: 252.0/255.0, green: 255.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            cell.lbl_points.text = "+\(answer_points)" + " rev points"
        }
        else if selectAnswer == "c"
        {
            cell.img_c?.image = UIImage(named: "circle-check")
            cell.backgroundColor = UIColor.init(red: 252.0/255.0, green: 255.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            cell.lbl_points.text = "+\(answer_points)" + " rev points"
        }
        else if selectAnswer == "d"
        {
            cell.img_d.image = UIImage(named: "circle-check")
            cell.backgroundColor = UIColor.init(red: 252.0/255.0, green: 255.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            cell.lbl_points.text = "+\(answer_points)" + "rev points"
        }
       //self.customAlertController.hideActivityIndicator(uiView: self.view)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You tapped cell number \(indexPath.row).")
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView1 = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as? HeaderView
        headerView1?.lbl_headerTitle.text = "Questions"
        headerView1?.lbl_headerTitle.textColor = UIColor.white
        headerView1?.lbl_headerTitle.font = UIFont(name:"Helvetica Neue", size: 15.0)

        return headerView1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }
    
/*
    @IBAction func playBtnClick(_ sender: UIButton) {
        

        
        //  gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        // TextToSpeechClass().startSpeechMethod(getWord:lbl_describtions.text!)
        
        let string =  lbl_describtions.text
        let utterance = AVSpeechUtterance(string: string!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synth.speak(utterance)
        
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
        print("Speaker class range ==")
        
        let mutablestring = NSMutableAttributedString(string: utterance.speechString)
        
        // mutablestring.addAttribute(UIColor.red, value: nil, range: characterRange)
        
        mutablestring.addAttribute(NSForegroundColorAttributeName , value: UIColor.red, range: characterRange)
        self.lbl_describtions.attributedText = mutablestring
        
        
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("Speaker class started")
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("Speaker class finished")
       self.lbl_describtions.attributedText = NSAttributedString(string: utterance.speechString)
    }
    
    */
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
