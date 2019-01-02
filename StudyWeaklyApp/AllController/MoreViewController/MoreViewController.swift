//
//  MoreViewController.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lbl_nameTitle: UILabel!
    
    @IBOutlet weak var lbl_points: UILabel!
    
    @IBOutlet weak var lbl_class: UILabel!
    
    @IBOutlet weak var lbl_setting: UILabel!
    
    @IBOutlet weak var view_classHieghtCons: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_line: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        imgProfile = circularImage.isCircularImg(imgView: imgProfile)
        // Do any additional setup after loading the view.
       }
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(true)
        let dbArr = CDBManager().getDataFromDB() as [AnyObject]
          print(dbArr as AnyObject)
        if dbArr.count>0{
//            dataSetDict["name"] = data.value(forKey: "userName") as AnyObject
//            dataSetDict["user_id"] = data.value(forKey: "user_id") as AnyObject
//            dataSetDict["nastudent_password"] = data.value(forKey: "userPassword") as AnyObject
//            dataSetDict["points"] = data.value(forKey: "userPoints") as AnyObject
            let getDict = dbArr[0] as? [String:AnyObject]
            lbl_nameTitle.text = getDict?["name"] as? String ?? ""
            let getPoints = getDict!["points"] as? String ?? ""
            lbl_points.text = getPoints + " Points"
              let userEmailStr = getDict!["userEmail"] as? String ?? ""
              let userRoleStr = getDict!["userRole"] as? String ?? ""
            if userRoleStr == "teacher"{
                lbl_line.backgroundColor = UIColor.lightGray
                view_classHieghtCons.constant = 56
            }else{
               
                 lbl_line.backgroundColor = UIColor.clear
                 view_classHieghtCons.constant = 0
            }
           }
       }
    
    @IBAction func logOutBtnClick(_ sender: Any) {
        CDBManager().deleteAllCDB()
         NetworkAPI.removeUserId()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootViewCallMethod(getAlertTitle:"sessionExpired")
        
      }
    @IBAction func profileItemBtnClicks(_ sender: UIButton) {
        
    }
    
    @IBAction func settingBtnClick(_ sender: Any) {
        
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let settingController = story.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
    let na = UINavigationController(rootViewController: settingController)
        self.slideMenuController()?.changeMainViewController(na, close: true)
    }
    
    
    
    @IBAction func btnClassClick(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let settingController = story.instantiateViewController(withIdentifier: "ClassViewController") as! ClassViewController
        let na = UINavigationController(rootViewController: settingController)
        self.slideMenuController()?.changeMainViewController(na, close: true)
        
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
