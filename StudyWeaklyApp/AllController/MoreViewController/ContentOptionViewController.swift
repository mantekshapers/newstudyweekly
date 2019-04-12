
//
//  ContentOptionViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/8/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class ContentOptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
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

    let titleArr = ["Article Audio","Article Images","Related Media","Blackline Masters",]
    var switchAssignData = [AnyObject]()
    
    //MARK: - UIView Life Cycle
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

        switchAssignData = CDBManager().fetchSwitchOnMethod()
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)
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
    }
    
    //MARK: - UIButton Method
    func switchValueDidChange(_ sender: UISwitch)
    {
        let switchTag = sender.tag
        if switchTag == 0
        {
            if sender.isOn
            {
                CDBManager().addSwitchInCDB(onSwitch: "on", switchType: "audioSwitch")
            }
            else
            {
                CDBManager().addSwitchInCDB(onSwitch: "off", switchType: "audioSwitch")
            }
        }
        else if switchTag == 1
        {
            if sender.isOn
            {
                CDBManager().addSwitchInCDB(onSwitch: "on", switchType: "imageSwitch")
            }
            else
            {
                CDBManager().addSwitchInCDB(onSwitch: "off", switchType: "imageSwitch")
            }
        }
        else if switchTag == 2
        {
            if sender.isOn
            {
                CDBManager().addSwitchInCDB(onSwitch: "on", switchType: "mediaSwitch")
            }
            else
            {
                CDBManager().addSwitchInCDB(onSwitch: "off", switchType: "mediaSwitch")
            }
        }
        let app = UIApplication.shared.delegate as! AppDelegate
        app.getWiFiOnMethod()
    }
    
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

    //MARK: - UITable Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: ContentOptionCell! = tblView.dequeueReusableCell(withIdentifier: "ContentOptionCell") as? ContentOptionCell
        if cell == nil {
            tblView.register(UINib(nibName: "ContentOptionCell", bundle: nil), forCellReuseIdentifier: "ContentOptionCell")
            cell = tblView.dequeueReusableCell(withIdentifier: "ContentOptionCell") as? ContentOptionCell
        }
        
        //        switchDict["imageSwitch"] = imgOn as AnyObject
        //        switchDict["audioSwitch"] = audioOn as AnyObject
        //        switchDict["mediaSwitch"] = mediaOn as AnyObject
        cell.switch_out.tag = indexPath.row
        cell.switch_out.isOn = false
        let getTitleStr = titleArr[indexPath.row]
        cell.lbl_title.text = getTitleStr
        
        if (switchAssignData.count)>0
        {
            let dictTmp = switchAssignData[0] as? [String:AnyObject]
            
            print("dict data ===///==\(String(describing: dictTmp))")
            if indexPath.row == 0
            {
                let audioTmp = dictTmp!["audioSwitch"] as? String
                if  audioTmp == "on"
                {
                    cell.switch_out.isOn = true
                }
            }
            else if indexPath.row == 1
            {
                let img = dictTmp!["imageSwitch"] as? String
                if img == "on"
                {
                    cell.switch_out.isOn = true
                }
            }
            else if indexPath.row == 2
            {
                let mediaTmp = dictTmp?["mediaSwitch"] as? String
                if mediaTmp == "on"
                {
                    cell.switch_out.isOn = true
                }
            }
        }
        
        cell.switch_out.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        // cell.lbl_weekly.text = "Week-" + getWeekly + " " + gettitle
        return cell
    }
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
