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
import AVFoundation

extension String {
    var withoutHtmlsTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

class BonusDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, BtnDelegate, AlertQuestionDelegate, AVSpeechSynthesizerDelegate
{
    let synth = AVSpeechSynthesizer()
let customAlertController = CustomController()
    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var lbl_description: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var view_media: UIView!

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnImgBig: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var viewImgBig: UIView!
    @IBOutlet weak var imgTopBig: UIImageView!

    @IBOutlet weak var tblView: UITableView!
    
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

    var alertView = AlertQuestionAnswerView()
    var counter = 0
    var locationInt:Int = 0
    var gameTimer: Timer!

    var audioTimeArr = [AnyObject]()
    var audioTextAppend:String? = ""
    var getUnitDetailDict = [String:AnyObject]()
    var questionArr = [AnyObject]()
     var tbl_height:Int?
    var articleId:String?
    
    var strImgVideo = ""
    //MARK: - UIView Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tblView.isHidden = true
        self.customAlertController.showActivityIndicatory(uiView: self.view)

        self.navigationController?.navigationBar.isHidden = true
        synth.delegate = self

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

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        self.viewImgBig.addGestureRecognizer(tapGesture)

        print("Bonus detail list===\(getUnitDetailDict)")
        imgView.isHidden = true
        view_media.isHidden = true
        articleId = getUnitDetailDict[WSKeyValues.article_id] as? String ?? "0"
        
        let urlDtr = getUnitDetailDict["url"] as? String ?? ""
        let range1 = urlDtr.range(of: ".mp4", options: .caseInsensitive)
        if (range1 != nil)
        {
            imgView.isHidden = true
            view_media.isHidden = false
            btnPlay.isEnabled = false
        }
        let range2 = urlDtr.range(of: ".mp3", options: .caseInsensitive)
        if (range2 != nil)
        {
            imgView.isHidden = true
            view_media.isHidden = true
            btnPlay.isEnabled = true
        }
        
        let range3 = urlDtr.range(of: ".jpeg", options: .caseInsensitive)
        if (range3 != nil)
        {
            btnPlay.isEnabled = false
            imgView.isHidden = false
            view_media.isHidden = true

            let strURL = urlDtr
            let strWithNoSpace = strURL.replacingOccurrences(of: " ", with: "%20")

            //var urlString :String = strURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!

            let imgeUrl = "https://" + strWithNoSpace
            CommonWebserviceClass.downloadImgFromServer(url:URL(string: imgeUrl as? String ?? "0")!) { (DATA, RESPOSE, error) in
                if DATA != nil {
                    DispatchQueue.main.async { // Correct
                        self.imgView.image = UIImage(data: DATA!)
                        self.imgTopBig.image = UIImage(data: DATA!)
                    }
                }
            }
        }
        
        let range4 = urlDtr.range(of: ".jpg", options: .caseInsensitive)
        if (range4 != nil){
            btnPlay.isEnabled = false
            imgView.isHidden = false
            view_media.isHidden = true

            let strURL = urlDtr
            let strWithNoSpace = strURL.replacingOccurrences(of: " ", with: "%20")

            let imgeUrl = "https://" + strWithNoSpace
            CommonWebserviceClass.downloadImgFromServer(url:URL(string: imgeUrl as? String ?? "0")!) { (DATA, RESPOSE, error) in
                if DATA != nil {
                    DispatchQueue.main.async { // Correct
                        self.imgView.image = UIImage(data: DATA!)
                        self.imgTopBig.image = UIImage(data: DATA!)
                    }
                }
            }
        }
        
        self.lbl_header.text = getUnitDetailDict["name"] as? String ?? ""
        self.lbl_description.text =  CustomController.htmlTagRemoveFromString(getString: getUnitDetailDict["description"] as? String ?? "")
        self.lbl_description.font = UIFont(name: "Helvetica Neue", size: 13.0)
        self.lbl_description.textColor = UIColor.black
        self.lbl_description.numberOfLines = 4

        print("lbl_description y: \(self.lbl_description.frame.origin.y)")
        print("lbl_description ht: \(self.lbl_description.frame.size.height)")
        print("lbl_description frame: \(self.lbl_description.frame)")

        let qArr = getUnitDetailDict["questions"] as? [AnyObject]
        let qCount = qArr?.count ?? 0
        if qCount != 0
        {
            tblView.isHidden = false
            questionArr.removeAll()
            
            for data in qArr!
            {
                var dataDict = [String:AnyObject]()
                dataDict = data as! [String : AnyObject]
                dataDict["selectAns"] = "unselect" as AnyObject
                questionArr.append(dataDict as AnyObject)
            }
            
            for i in 0..<questionArr.count
            {
                let j = i + 1
                tbl_height = 300 * j
            }
            tbl_height = tbl_height! + 100
            
            self.tblView.frame = CGRect(x: 0, y: 315, width: self.view.frame.size.width, height: CGFloat(tbl_height!))
            
            print("tbl_height: \(String(describing: self.tbl_height))")
            print("tblView ht: \(self.tblView.frame.size.height)")
            print("tblView frame: \(self.tblView.frame)")

            self.contenView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: CGFloat(tbl_height!) + 20)
            
            print("contenView y: \(self.contenView.frame.origin.y)")
            print("contenView ht: \(self.contenView.frame.size.height)")
            print("contenView frame: \(self.contenView.frame)")
        }
        else
        {
            tblView.isHidden = true
            self.tblView.frame = CGRect(x: 0, y:315, width: self.view.frame.size.width, height: 0)

            self.contenView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 548)
            
            print("contenView y: \(self.contenView.frame.origin.y)")
            print("contenView ht: \(self.contenView.frame.size.height)")
            print("contenView frame: \(self.contenView.frame)")
        }

        self.scrollView.contentSize = CGSize(width: self.contenView.frame.size.width, height: self.contenView.frame.size.height + 20)
        
        print("scrollView width: \(self.scrollView.contentSize.width)")
        print("scrollView ht: \(self.scrollView.contentSize.height)")

         CDBManager().updatePodToDB(getPodDetailDict: getUnitDetailDict)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        alertView  = (Bundle.main.loadNibNamed("AlertQuestionAnswerView", owner: self, options: nil)?.first as? AlertQuestionAnswerView)!
        alertView.alertQuestionDelegate = self
        alertView.frame = self.view.frame
        alertView.center = self.view.center
        self.view.addSubview(alertView)
        self.view.bringSubview(toFront: alertView)
        alertView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
         super.viewDidAppear(animated)
        
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
        self.customAlertController.hideActivityIndicator(uiView: self.view)

    }
    
    //MARK: - User Define Method
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer)
    {
        self.viewImgBig.isHidden = true
    }

    func answerSeleckMethod(getAnwr: String, btnTag: Int)
    {
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
                }
                else
                {
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
                
                if isCorrect.boolValue
                {
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
                }
                else
                {
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
        myMutableString = NSMutableAttributedString(string: audioTextAppend!, attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 15.0)!])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 166/255, green: 166/255, blue: 237/255, alpha: 1.0), range: NSRange(location:locationInt,length:lentth))
        lbl_description.attributedText = myMutableString
        lbl_description.numberOfLines = 4
        //lbl_description.sizeToFit()
        //lbl_description.frame = CGRect(x: 15, y: self.imgView.frame.origin.y + self.imgView.frame.size.height + 20, width: self.view.frame.size.width - 30 , height: self.lbl_description.frame.size.height + 10)
       // self.lblDescHtConstraint.constant = self.lbl_description.frame.size.height

        //-----Frame
       /* if self.view.frame.width == 320
        {
            self.imgView.frame = CGRect(x: 15, y:15, width: self.view.frame.size.width - 30, height: 200)
            self.btnImgBig.frame = CGRect(x: 15, y:15, width: self.view.frame.size.width - 30, height: 200)
            lbl_description.frame = CGRect(x: 15, y: 220, width: self.view.frame.size.width - 30 , height: lbl_description.frame.size.height)
        }
        else if self.view.frame.width == 375
        {
            self.imgView.frame = CGRect(x: 15, y:15, width: self.view.frame.size.width - 30, height: 250)
            self.btnImgBig.frame = CGRect(x: 15, y:15, width: self.view.frame.size.width - 30, height: 250)
            lbl_description.frame = CGRect(x: 15, y: 270, width: self.view.frame.size.width - 30 , height: lbl_description.frame.size.height)
        }
        else if self.view.frame.width == 414
        {
            self.imgView.frame = CGRect(x: 15, y:15, width: self.view.frame.size.width - 30, height: 280)
            self.btnImgBig.frame = CGRect(x: 15, y:15, width: self.view.frame.size.width - 30, height: 280)
            lbl_description.frame = CGRect(x: 15, y: 300, width: self.view.frame.size.width - 30 , height: lbl_description.frame.size.height)
        }*/
        locationInt = (locationInt + 1) + wordStr.count
        counter += 1
        TextToSpeechClass().startSpeechMethod(getWord:wordStr)
    }

    //MARK: - UIButton Method
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
    
    @IBAction func btnBigImgClicked(_ sender: UIButton)
    {
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)
        self.viewImgBig.isHidden = false
    }
    
    //MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 230
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return questionArr.count
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
        
        let getQDict = self.questionArr[indexPath.row] as? [String:AnyObject]
        let selectAnswer = getQDict?["selectAns"] as? String
        let answer_points = String(getQDict?["points_possible"] as! Int)
        
        let getQStr = getQDict!["question"] as? String
        let getQNewStr = getQStr?.withoutHtmlsTags
        print("getQNewStr!\(String(describing: getQNewStr))")

        let getAStr = getQDict!["a"] as? String
        let getBStr = getQDict!["b"] as? String
        let getCStr = getQDict!["c"] as? String
        let getDStr = getQDict!["d"] as? String
        
        let getDificultStr = getQDict!["difficulty"] as? String
        if getDificultStr == "1"
        {
            cell.view_qType.backgroundColor = UIColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 1.0)
            cell.lbl_qtype.text = "Easy Question:"
        }
        else if getDificultStr == "2"
        {
            cell.view_qType.backgroundColor = UIColor.init(red: 240/255, green: 173/255, blue: 78/255, alpha: 1.0)
            cell.lbl_qtype.text = "Medium Question:"
        }
        else if getDificultStr == "3"
        {
            cell.view_qType.backgroundColor = UIColor.init(red: 217/255, green: 83/255, blue: 79/255, alpha: 1.0)
            cell.lbl_qtype.text = "Hard Question:"
        }
        // let getDificultStr = getQDict!["d"] as? String
        
        //cell.lbl_question?.text = CustomController.htmlTagRemoveFromString(getString: getQStr ?? "")
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
            cell.lbl_points.text = "+ \(answer_points)" + ( " rev points")
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
            cell.lbl_points.text = "+\(answer_points)" + (" rev points")
        }else if selectAnswer == "d" {
            
            cell.img_d.image = UIImage(named: "circle-check")
            cell.backgroundColor = UIColor.init(red: 252.0/255.0, green: 255.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            cell.lbl_points.text = "+\(answer_points)" + ("rev points")
        }
        
        return cell
    }
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
