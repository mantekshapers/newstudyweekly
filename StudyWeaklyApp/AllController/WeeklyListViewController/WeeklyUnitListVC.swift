//
//  WeeklyUnitListVC.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/22/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
class WeeklyUnitListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIApplicationDelegate
{
    let customAlertController = CustomController()
    
    @IBOutlet weak var lbl_headerTitle: UILabel!
    @IBOutlet weak var tblView_unit: UITableView!
    
    @IBOutlet weak var viewTestBottom : UIView!
    @IBOutlet weak var viewMenu : UIView!
    @IBOutlet weak var btnSideMenu : UIButton!
    @IBOutlet weak var btnInitial : UIButton!
    @IBOutlet weak var btnSetting : UIButton!
    @IBOutlet weak var btnCoins : UIButton!
    @IBOutlet weak var btnLogout : UIButton!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblCoins : UILabel!
    @IBOutlet weak var lblRole : UILabel!
    @IBOutlet weak var viewTest : UIView!
    @IBOutlet weak var viewScore : UIView!
    @IBOutlet weak var viewBottom : UIView!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    @IBOutlet weak var btnCopy : UIButton!
    @IBOutlet weak var btnSearch : UIButton!
    @IBOutlet weak var btnPlay : UIButton!

    @IBOutlet weak var btnTest : UIButton!
    @IBOutlet weak var btnScore : UIButton!

    var unitArr = [AnyObject]()
    var getUnitDataArr = [AnyObject]()
    var articleDataArr = [AnyObject]()
    var getUnitDict:[String:AnyObject] = [:]
    var typeGetTitle:String? = nil
    
    //MARK: - UIView Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.customAlertController.showActivityIndicatory(uiView: self.view)
        }
        
        self.navigationController?.navigationBar.isHidden = true
        self.viewMenu.isHidden = true
        self.viewTestBottom.isHidden = true
        
        self.viewScore.backgroundColor = UIColor.init(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0)
        self.viewTest.backgroundColor = UIColor.init(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0)
        self.btnScore.isUserInteractionEnabled = false
        self.btnTest.isUserInteractionEnabled = false

        CommonFunctions.closeMenu(view: viewMenu)

        //Side Menu
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
        
        //print("getUnitDict:=\(getUnitDict)")
        self.lbl_headerTitle?.text = getUnitDict[WSKeyValues.title] as? String
        self.wsForAssessmentsAvail(unit_id: getUnitDict[WSKeyValues.unit_id] as! String)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.customAlertController.showActivityIndicatory(uiView: self.view)

            let getUnitId = self.getUnitDict["unit_id"] as! String

            if self.typeGetTitle != "FromSearch"
            {
                for i in 0..<self.getUnitDataArr.count
                {
                   // let getDict1 = self.getUnitDataArr[i] as! [String: AnyObject]
                    let getArr = self.getUnitDataArr[i]["units"] as! [AnyObject]
                   // print("getArr\(getArr)")
                    if getArr.count > 0
                    {
                        for j in 0..<getArr.count
                        {
                            let getTemp = getArr[j]
                            let getUnitsId = getTemp["unit_id"] as! String
                            //print("unitId\(String(describing: getUnitsId))")
                            if getUnitId == getUnitsId
                            {
                                //print("gwetTemp\(getTemp["units"])")
                                if (getTemp["units"] == nil || getTemp["units"] is NSNull)
                                {
                                    //CustomController.showMessage(message: "No data found")

                                }
                                else
                                {
                                    self.unitArr = (getTemp["units"] as? [AnyObject])!
                                    
                                    if self.unitArr.count > 0
                                    {
                                        self.viewTestBottom.isHidden = false
                                        CDBManager().addArticleInDB(getArticleData: self.unitArr,saveUnitsId: getUnitsId)
                                    }
                                    else
                                    {
                                        self.customAlertController.hideActivityIndicator(uiView: self.view)
                                        
                                        self.viewTestBottom.isHidden = true
                                        let uiAlert = UIAlertController(title: "Studies Weekly", message: "There are currently no articles for this week.We are working to add the articles as soon as possible. Please check back soon.", preferredStyle: UIAlertControllerStyle.alert)
                                        print("Click of default button")
                                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                            print("Click of default button")
                                            self.customAlertController.hideActivityIndicator(uiView: self.view)
                                            
                                        }))
                                        self.present(uiAlert, animated: true, completion: nil)

                                    }
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                CDBManager().addArticleInDB(getArticleData: self.unitArr,saveUnitsId: self.getUnitDict[WSKeyValues.unit_id] as! String)
            }
        }
        self.customAlertController.hideActivityIndicator(uiView: self.view)
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
        self.customAlertController.showActivityIndicatory(uiView: self.view)
        }

        let dbArr = CDBManager().getDataFromDB() as [AnyObject]
        //print(dbArr as AnyObject)
        if dbArr.count>0
        {
            let getDict = dbArr[0] as? [String:AnyObject]
            //print("getDict:\(String(describing: getDict))")
            
            lblName.text = getDict?["name"] as? String ?? ""
            //print("Name:\(String(describing: lblName.text))")
            let getPoints = getDict!["points"] as? String ?? ""
            lblCoins.text = getPoints + " Coins"
            
            let userRoleStr = getDict!["userRole"] as? String ?? ""
            lblRole.text = userRoleStr
            
            let strChar = String(Array(self.lblName.text!)[0])
            //print("strChar:\(strChar)")
            
            btnSideMenu.setTitle(strChar, for: .normal)
            btnInitial.setTitle(strChar, for: .normal)
        }

        self.articleDataArr = CDBManager().getArticleData(getUnitsId: self.getUnitDict[WSKeyValues.unit_id] as! String)
        self.tblView_unit.reloadData()
        self.customAlertController.hideActivityIndicator(uiView: self.view)
    }
    
    //MARK: - User Define Method
    func wsForAssessmentsAvail(unit_id: String)
    {
        self.customAlertController.showActivityIndicatory(uiView: self.view)
        let getUserId = NetworkAPI.userID()
        let postDict = [WSKeyValues.unit_id:unit_id,WSKeyValues.user_id: getUserId]
        CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.assessmentAvailable, postString: postDict as! [String : String], httpMethodName: "GET") { (respose, boolTrue) in
            self.customAlertController.showActivityIndicatory(uiView: self.view)

            if boolTrue == false
            {
                let getDict = respose as! [String:AnyObject]
               // print("getDict:\(getDict)")
                return
            }
            
            let getDict = respose as? [String:String]
            let avaibleStr = getDict!["valueKey"]
            DispatchQueue.main.async {
                self.viewTestBottom.isHidden = false
            }

            DispatchQueue.main.async {
                if avaibleStr == "1"
                {
                    self.viewScore.backgroundColor = UIColor.init(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0)
                    self.viewTest.backgroundColor = UIColor.init(red: 31/255, green: 167/255, blue: 47/255, alpha: 1.0)
                    
                    self.btnScore.isUserInteractionEnabled = false
                    self.btnTest.isUserInteractionEnabled = true
                }
                else
                {
                    self.viewScore.backgroundColor = UIColor.init(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0)
                    self.viewTest.backgroundColor = UIColor.init(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0)
                    
                    self.btnScore.isUserInteractionEnabled = false
                    self.btnTest.isUserInteractionEnabled = false
                }
            }
            //print("unit response",getDict as Any)
        }
    }

    //MARK: - UIButton Methods
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
    
    @IBAction func backBtnClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
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

        for vc in (self.navigationController?.viewControllers ?? []) {
            if vc is HomeFileViewController {
                _ = self.navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }

    @IBAction func testScoreBtnClick(_ sender: UIButton)
    {
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        let scoreViewController  =  self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.ScoreViewControllerID) as! ScoreViewController
        scoreViewController.getUnitId = getUnitDict[WSKeyValues.test_id] as? String
        self.navigationController?.pushViewController(scoreViewController, animated: true)
    }
    
    @IBAction func testBtnClick(_ sender: UIButton)
    {
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        let testViewController  =  self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.TestViewControllerID) as! TestViewController
        testViewController.getUnitId = getUnitDict[WSKeyValues.unit_id] as? String
        self.navigationController?.pushViewController(testViewController, animated: true)
    }

    //MARK: - UITableView Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return unitArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: WeeklyUnitListCell! = tblView_unit.dequeueReusableCell(withIdentifier: "WeeklyUnitListCell") as? WeeklyUnitListCell
        if cell == nil
        {
            tblView_unit.register(UINib(nibName: "WeeklyUnitListCell", bundle: nil), forCellReuseIdentifier: "WeeklyUnitListCell")
            cell = tblView_unit.dequeueReusableCell(withIdentifier: "WeeklyUnitListCell") as? WeeklyUnitListCell
        }
        
        cell.imgView.image = UIImage(named: "circle-uncheck")
        if  self.articleDataArr.count>0
        {
            let getReadStr = self.articleDataArr[indexPath.row]["read"] as? String ?? ""
            if getReadStr == "readed"
            {
                cell.imgView.image = UIImage(named: "circle-check")
                cell.viewColor.backgroundColor = UIColor.init(red: 189.0/255.0, green: 223.0/255, blue: 199.0/255.0, alpha: 1.0)
            }
            else
            {
                cell.viewColor.backgroundColor = UIColor.init(red: 206.0/255.0, green: 206.0/255, blue: 206.0/255.0, alpha: 1.0)
            }
        }
        DispatchQueue.main.async {
            cell.lbl_title.text = self.unitArr[indexPath.row][WSKeyValues.article_title] as? String
            self.customAlertController.hideActivityIndicator(uiView: self.view)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.customAlertController.showActivityIndicatory(uiView: self.view)

        DispatchQueue.main.async {
            print("You tapped cell number \(indexPath.row).")

            let getDict = self.unitArr[indexPath.row] as? [String:AnyObject]
            let getArtcleDict =   self.articleDataArr[indexPath.row]  as? [String: AnyObject]
            let weeklyDetailVC  =   self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.WeeklyDetailVCID) as! WeeklyDetailVC
            weeklyDetailVC.getUnitDetailDict = getDict
            weeklyDetailVC.getArticleDetailDict = getArtcleDict
            self.navigationController?.pushViewController(weeklyDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
