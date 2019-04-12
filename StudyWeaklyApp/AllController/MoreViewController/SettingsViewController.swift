//
//  SettingsViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/8/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import SystemConfiguration
class SettingsViewController: UIViewController
{
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var lbl_gb: UILabel!
    @IBOutlet weak var lbl_max: UILabel!
    
    @IBOutlet weak var wifiSwitch: UISwitch!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
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
    
    //MARK: - UIVivew Life Cycle
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

        let spaceData = StorageSizeClass.getStorageSpace() as Double
        print("device space showing now..\(spaceData)")
        
       /// NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willChange(UIWindowDidBecomeVisible), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name:NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
       // wifiSwitch.setOn(false, animated: false)
      }
    
    @objc func willEnterForeground()
    {
        // do stuff
        print("hello detect ==")
        if NetworkCheckWifiReachbility.iswifi() == true
        {
            print("WIFI IS ON THIS TIME and working ")
            wifiSwitch.isOn = true
            StorageClass.setWifi(setBool: true)
        }
        else
        {
            print("WIFI IS OFF THIS TIME and not working ")
            wifiSwitch.isOn = false
            StorageClass.setWifi(setBool: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        if NetworkCheckWifiReachbility.iswifi() == true
        {
            print("WIFI IS ON THIS TIME and working ")
            wifiSwitch.isOn = true
            StorageClass.setWifi(setBool: true)
        }
        else
        {
            print("WIFI IS OFF THIS TIME and not working ")
            wifiSwitch.isOn = false
            StorageClass.setWifi(setBool: false)
        }
        let nOnOff = StorageClass.getNotificationOnOff()
        if nOnOff == "on"
        {
            notificationSwitch.isOn = true
        }
        else
        {
             notificationSwitch.isOn = false
        }
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
    
    @IBAction func notificatonSwitchOnOff(_ sender: UISwitch)
    {
        if sender.isOn
        {
             NotificationClass.notification.notificationOnMethod()
        }
        else
        {
              NotificationClass.notification.notificationOffMethod()
        }
    }
    
    @IBAction func wifiBtnOnOff(_ sender: UISwitch)
    {
        let settingsURL = URL(string: "App-Prefs:root=WIFI")
        if UIApplication.shared.canOpenURL(settingsURL!)
        {
            if #available(iOS 10.0, *)
            {
                UIApplication.shared.open(settingsURL!, options: [:], completionHandler: nil)
             }
            else
            {
                UIApplication.shared.openURL(settingsURL!)
              }
          }
      }
    
    @IBAction func storageSliderClick(_ sender: UISlider)
    {
        var currentValue = Int(sender.value)
        print("Slider changing to \(currentValue) ?")
        lbl_max.text = "Max Size: \(currentValue) GB"
    }
    
    @IBAction func contentBtnClick(_ sender: UIButton)
    {
        let boolTmp =  StorageClass.getWifi()
        if boolTmp == false
        {
            CustomController().showCustomAlert3(getMesage: "Please switch on of WIFI", getView: self)
            return
        }
        let contentOptionVC  =  self.storyboard?.instantiateViewController(withIdentifier: "ContentOptionVC") as! ContentOptionViewController
        self.navigationController?.pushViewController(contentOptionVC, animated: true)
    }

//    func toggleWiFi() {
//        let app = XCUIApplication()
//        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
//
//        // open control center
//        let coord1 = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.99))
//        let coord2 = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
//        coord1.press(forDuration: 0.1, thenDragTo: coord2)
//
//        let wifiButton = springboard.switches["wifi-button"]
//        wifiButton.tap()
//
//        // open your app back again
//        springboard.otherElements["com.your.app.identifier"].tap()
//    }
//
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
