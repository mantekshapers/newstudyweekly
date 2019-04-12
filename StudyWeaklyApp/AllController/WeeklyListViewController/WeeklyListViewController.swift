//
//  WeeklyListViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/22/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class WeeklyListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var lbl_hearderTitle: UILabel!
    
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
    
    @IBOutlet weak var tblView: UITableView!
    
    var getWeeklyDict:[String:AnyObject]?
    var weeklyArr = [AnyObject]()
    var sendUnitsDataArr = [AnyObject]()
    
    var Index  = 0
    let customAlertController = CustomController()
    
    //MARK: - UIView Life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
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
        
        let dbArr = CDBManager().getDataFromDB() as [AnyObject]
        //print(dbArr as AnyObject)
        if dbArr.count>0
        {
            let getDict = dbArr[0] as? [String:AnyObject]
           // print("getDict:\(String(describing: getDict))")
            
            lblName.text = getDict?[WSKeyValues.name] as? String ?? ""
            //print("Name:\(String(describing: lblName.text))")
            let getPoints = getDict![WSKeyValues.points] as? String ?? ""
            lblCoins.text = getPoints + " Coins"
            
            let userRoleStr = getDict!["userRole"] as? String ?? ""
            lblRole.text = userRoleStr
            
            let strChar = String(Array(self.lblName.text!)[0])
            //print("strChar:\(strChar)")
            
            btnSideMenu.setTitle(strChar, for: .normal)
            btnInitial.setTitle(strChar, for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        //print("getWeeklyDict:- \(getWeeklyDict!)")
        weeklyArr = getWeeklyDict![WSKeyValues.units] as! [AnyObject]
        lbl_hearderTitle.text = getWeeklyDict![WSKeyValues.title] as? String ?? ""
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
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
    
    //MARK: - UITableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return weeklyArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: WeeklyTableViewCell! = tblView.dequeueReusableCell(withIdentifier: "WeeklyTableViewCell") as? WeeklyTableViewCell
        if cell == nil {
            tblView.register(UINib(nibName: "WeeklyTableViewCell", bundle: nil), forCellReuseIdentifier: "WeeklyTableViewCell")
            cell = tblView.dequeueReusableCell(withIdentifier: "WeeklyTableViewCell") as? WeeklyTableViewCell
        }
        
        DispatchQueue.main.async {
        let getDict = self.weeklyArr[indexPath.row] as! [String:AnyObject]
        let getWeekly = getDict[WSKeyValues.week_num]  as! String
        let gettitle = getDict[WSKeyValues.title] as! String
        cell.lbl_weekly.text = "Week " + getWeekly + " - " + gettitle
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //print("You tapped cell number \(indexPath.row).")
        self.customAlertController.showActivityIndicatory(uiView: self.view)

        DispatchQueue.main.async {
            self.customAlertController.showActivityIndicatory(uiView: self.view)

            let getDict = self.weeklyArr[indexPath.row] as? [String:AnyObject]
            let getUnitId = getDict![WSKeyValues.unit_id] as! String
            //print("getUnitId\(getUnitId)")
            
            let weeklyUnitListVC  =  self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.WeeklyUnitListVCID) as! WeeklyUnitListVC
            weeklyUnitListVC.getUnitDict = getDict!
            weeklyUnitListVC.getUnitDataArr = self.sendUnitsDataArr
            self.customAlertController.showActivityIndicatory(uiView: self.view)

            self.navigationController?.pushViewController(weeklyUnitListVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    //MARK: - Memory warning
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}
