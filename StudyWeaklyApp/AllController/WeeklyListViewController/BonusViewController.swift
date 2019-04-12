//
//  BonusViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/29/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class BonusViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DownloadBtnDelegate
{
    let customAlertController = CustomController()
    var getPodMediaData:[AnyObject]?
    var getReadPodMediaData = [AnyObject]()
    var downloadArray = [AnyObject]()
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tblView_bonus: UITableView!

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

    var strVideoImg = ""
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
        
        print("getPodMediaData ==\(String(describing: self.getPodMediaData))")
        self.downloadArray.removeAll()
        for i in 0..<self.getPodMediaData!.count
        {
            let dictTmp = self.getPodMediaData![i] as! [String: AnyObject]
            var dict = [String: AnyObject]()
            let arId = dictTmp[WSKeyValues.article_id] as? String
            let media_id = dictTmp[WSKeyValues.media_id] as? String
            dict["download"] = "notDownload" as AnyObject
            dict[WSKeyValues.article_id] = arId as AnyObject
            dict[WSKeyValues.media_id] = media_id as AnyObject
            self.downloadArray.append(dict as AnyObject)
        }
        CDBManager().podMediaInDB(podMediaArr: self.getPodMediaData!)
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
        self.customAlertController.showActivityIndicatory(uiView: self.view)
        
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
        
        let getUnitsId    = StorageClass.getUnitsId()
        let getArticleId    = StorageClass.getArticleId()
         print("getUnitsId:\(getUnitsId)")
         print("getArticleId:\(getArticleId)")
        
        self.getReadPodMediaData = CDBManager().getPodMediaData(getUnitsId: getUnitsId, getArticleId: getArticleId)
        print("self.getReadPodMediaData:\(self.getReadPodMediaData)")

        let dataFetch  =  CDBManager().getPodDownloadMediaMethod(getSearchDict: [:],searchKey: "AllFetch")
        print("=======\(downloadArray)")
        print("dataFetch:\(dataFetch)")

        for var i in 0..<dataFetch.count
        {
            let dataDict = dataFetch[i] as? [String:AnyObject]
            print("dataDict:\(String(describing: dataDict))")
            let nediaIdTmp = dataDict![WSKeyValues.media_id] as? String
             print("nediaIdTmp:\(String(describing: nediaIdTmp))")

             let articleIdTmp = dataDict![WSKeyValues.article_id] as? String
            print("articleIdTmp:\(String(describing: articleIdTmp))")

            let nediaSourceTmp = dataDict!["media_source"] as? String
            print("nediaSourceTmp:\(String(describing: nediaSourceTmp))")

            for var j in 0..<self.downloadArray.count
            {
                var data1Dict = self.downloadArray[j] as? [String:AnyObject]
                print("data1Dict:\(String(describing: data1Dict))")

                let nediaIdTmp1 = data1Dict![WSKeyValues.media_id] as? String
                print("nediaIdTmp1:\(String(describing: nediaIdTmp1))")

                 let articleTmp1 = data1Dict![WSKeyValues.article_id] as? String
                print("articleTmp1:\(String(describing: articleTmp1))")

                if nediaIdTmp == nediaIdTmp1 && articleIdTmp == articleTmp1
                {
                    data1Dict!["download"] = "download" as AnyObject
                   // data1Dict!["media_source"] = nediaSourceTmp as AnyObject
                   downloadArray[j] = data1Dict as AnyObject
                    
                    print("nediaIdTmp==\(String(describing: nediaIdTmp))& nediaIdTmp1==\(String(describing: nediaIdTmp1))")
                }
            }
        }
        
         DispatchQueue.main.async {
            self.tblView_bonus.reloadData()
            self.customAlertController.hideActivityIndicator(uiView: self.view)
        }
    }
    
    //MARK: - User Define Method
    func downloadedCellBtnClick(indexCell: UIButton)
    {
        let app = UIApplication.shared.delegate as! AppDelegate
        let arr = app.wifiDataArr
        if arr.count == 0
        {
            self.customAlertController.showCustomAlert3(getMesage: "Please switch on to download", getView: self)
            return
        }
        
        let dictTmp = arr[0] as? [String:AnyObject]
        let position: CGPoint = indexCell.convert(CGPoint.zero, to: tblView_bonus)
        if let indexPath = self.tblView_bonus.indexPathForRow(at: position)
        {
            let section = indexPath.section
            let row = indexPath.row
            // let indexPath = inde//NSIndexPath(forRow: row, inSection: section)
            let cell = self.tblView_bonus.cellForRow(at: indexPath as IndexPath) as? BonusPointCell
            cell?.indicator.startAnimating()
            var dict =  self.downloadArray[indexPath.row] as? [String: AnyObject]
            dict!["download"] = "download_proccessing" as AnyObject
            self.downloadArray[indexPath.row] = dict as AnyObject
            DispatchQueue.main.async { // Correct
                self.tblView_bonus.reloadData()
            }
            let dataDict = getPodMediaData![row] as! [String: AnyObject]
            let string  = dataDict["url"] as? String ?? ""
            
            if (string.range(of: ".mp4")) != nil
            {
                let mediaTmp = dictTmp!["mediaSwitch"] as? String
                if  mediaTmp != "on" {
                    self.customAlertController.showCustomAlert3(getMesage: "Please switch on to medioSwitch", getView: self)
                    return
                }
            }
            else if (string.range(of: ".mp3")) != nil
            {
                let audioTmp = dictTmp!["audioSwitch"] as? String
                if audioTmp != "on"
                {
                    self.customAlertController.showCustomAlert3(getMesage: "Please switch on to audioSwitch", getView: self)
                    return
                }
            }
            else
            {
                let imgTmp = dictTmp!["imageSwitch"] as? String
                if  imgTmp != "on"
                {
                    self.customAlertController.showCustomAlert3(getMesage: "Please switch on to imageSwitch", getView: self)
                    return
                }
            }
            
            DispatchQueue.global(qos: .background).async {
                let row = indexPath.row
                let dict1 = self.getPodMediaData![indexPath.row] as? [String:AnyObject]
                // var dict1 =  self.downloadArray[indexPath.row] as? [String: AnyObject]
                //self.downloadArray[indexPath.row] = dict as AnyObject
                
                let urlStr = dict1!["url"] as? String ?? ""
                let converUrl = "https://" + urlStr
                print("converUrl\(converUrl)")
                CommonDownloadClass().savePodMediaMethod(getMediDict: dict1!, completion: { (urlFile, error) in
                    if error == nil
                    {
                        DispatchQueue.main.async { // Correct
                            dict!["download"] = "download" as AnyObject
                            self.downloadArray[row] = dict as AnyObject
                            self.tblView_bonus.reloadData()
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async { // Correct
                            dict!["download"] = "notDownload" as AnyObject
                            self.downloadArray[row] = dict as AnyObject
                            print("dict===\(String(describing: dict))")
                            self.tblView_bonus.reloadData()
                        }
                    }
                })
            }
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
    
    //MARK: - UITableView Delegates and Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return getPodMediaData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: BonusPointCell! = tblView_bonus.dequeueReusableCell(withIdentifier: "BonusPointCell") as? BonusPointCell
        if cell == nil {
            tblView_bonus.register(UINib(nibName: "BonusPointCell", bundle: nil), forCellReuseIdentifier: "BonusPointCell")
            cell = tblView_bonus.dequeueReusableCell(withIdentifier: "BonusPointCell") as? BonusPointCell
           }
        cell.downloadBtnDelegate = self
        cell.backgroundColor = CustomBGColor.grayCellBGColor
        cell.lbl_cellNo.layer.cornerRadius = cell.lbl_cellNo.frame.size.width / 2
        cell.lbl_cellNo.layer.masksToBounds = true
        
        cell.img_circle.image = UIImage(named: "circle-uncheck")
        var strRead = ""
        if  self.getReadPodMediaData.count>0
        {
            let getTmpDict = self.getReadPodMediaData[indexPath.row] as AnyObject
            print("getTmpDict:\(getTmpDict)")
            
            let getReadStr = getTmpDict["read"] as? String ?? ""
            print("getReadStr:\(getReadStr)")
            cell.lbl_cellNo.textColor = UIColor.white

            if getReadStr == "readed"
            {
                strRead = "readed"
                cell.img_circle.image = UIImage(named: "bonuGreen")
                cell.viewColor.backgroundColor = UIColor.init(red: 189.0/255.0, green: 223.0/255, blue: 199.0/255.0, alpha: 1.0)
            }
            else
            {
                strRead = "notReaded"
                cell.viewColor.backgroundColor = UIColor.init(red: 206.0/255.0, green: 206.0/255, blue: 206.0/255.0, alpha: 0.5)
            }
        }
        
        let getDict = getPodMediaData![indexPath.row] as! [String:AnyObject]
        let questionArr = getDict["questions"] as? [AnyObject]
        if (questionArr?.count ?? 0) > 0
        {
           cell.lbl_cellNo?.text = String(questionArr!.count)
        }
        let gettitle = getDict["name"] as! String
        cell.lbl_title.text = gettitle
        // cell.lbl_weekly.text = "Week-" + getWeekly + " " + gettitle
        cell.btn_download.tag = indexPath.row
    
        if downloadArray.count > 0
        {
            let getSelectDict = downloadArray[indexPath.row] as! [String: AnyObject]
            
            let getSetStr = getSelectDict["download"] as? String
            if  getSetStr == "download_proccessing"
            {
                cell.indicator.isHidden = false
                cell.indicator.startAnimating()
            }
            else if getSetStr == "download"
            {
                if strRead == "readed"
                {
                    cell.lbl_cellNo.isHidden = true
                    cell.img_circle.isHidden = false
                    cell.img_circle.image = UIImage(named: "bonuGreen")
                }
                else
                {
                    cell.lbl_cellNo.isHidden = false
                    cell.img_circle.isHidden = true
                    cell.lbl_cellNo.backgroundColor = UIColor.init(red: 252/255, green: 175/255, blue: 21/255, alpha: 1.0)
                }
                cell.indicator.stopAnimating()
                cell.indicator.isHidden = true
                
                let qu = getDict["url"] as? String ?? "0"
                let range1 = qu.range(of: ".mp4", options: .caseInsensitive)
                if (range1 != nil)
                {
                    cell.img_download.image = UIImage(named: "video_selecetd.png")
                }
                let range2 = qu.range(of: ".mp3", options: .caseInsensitive)
                if (range2 != nil)
                {
                    cell.img_download.image = UIImage(named: "music_icon_selected.png")
                }
                
                let range3 = qu.range(of: ".jpeg", options: .caseInsensitive)
                if (range3 != nil){
                    cell.img_download.image = UIImage(named: "image_selected.png")
                }
                
                let range4 = qu.range(of: ".jpg", options: .caseInsensitive)
                if (range4 != nil){
                    cell.img_download.image = UIImage(named: "image_selected.png")
                }
                
                let range5 = qu.range(of: ".png", options: .caseInsensitive)
                if (range5 != nil){
                    cell.img_download.image = UIImage(named: "image_selected.png")
                }
                //cell.img_download.image = UIImage(named: "")
            }
            else
            {
                cell.indicator.stopAnimating()
                cell.indicator.isHidden = true
                
                cell.lbl_cellNo.isHidden = false
                cell.img_circle.isHidden = true
                cell.lbl_cellNo.backgroundColor = UIColor.init(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)

                let qu = getDict["url"] as? String ?? "0"

                if strRead == "readed"
                {
                    let range1 = qu.range(of: ".mp4", options: .caseInsensitive)
                    if (range1 != nil)
                    {
                        cell.img_download.image = UIImage(named: "video_selecetd.png")
                    }
                    let range2 = qu.range(of: ".mp3", options: .caseInsensitive)
                    if (range2 != nil)
                    {
                        cell.img_download.image = UIImage(named: "music_icon_selected.png")
                    }
                    
                    let range3 = qu.range(of: ".jpeg", options: .caseInsensitive)
                    if (range3 != nil){
                        cell.img_download.image = UIImage(named: "image_selected.png")
                    }
                    
                    let range4 = qu.range(of: ".jpg", options: .caseInsensitive)
                    if (range4 != nil){
                        cell.img_download.image = UIImage(named: "image_selected.png")
                    }
                    
                    let range5 = qu.range(of: ".png", options: .caseInsensitive)
                    if (range5 != nil){
                        cell.img_download.image = UIImage(named: "image_selected.png")
                    }
                }
                else
                {
                    let range1 = qu.range(of: ".mp4", options: .caseInsensitive)
                    if (range1 != nil){
                        cell.img_download.image = UIImage(named: "video.png")
                    }
                    let range2 = qu.range(of: ".mp3", options: .caseInsensitive)
                    if (range2 != nil){
                        cell.img_download.image = UIImage(named: "music.png")
                    }
                    let range3 = qu.range(of: ".jpeg", options: .caseInsensitive)
                    if (range3 != nil){
                        cell.img_download.image = UIImage(named: "image.png")
                    }
                    let range4 = qu.range(of: ".jpg", options: .caseInsensitive)
                    if (range4 != nil){
                        cell.img_download.image = UIImage(named: "image.png")
                    }
                    let range5 = qu.range(of: ".png", options: .caseInsensitive)
                    if (range5 != nil){
                        cell.img_download.image = UIImage(named: "image.png")
                    }
                }

            }
        }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.customAlertController.showActivityIndicatory(uiView: self.view)
        let getDict = getPodMediaData![indexPath.row] as? [String:AnyObject]
        print("You tapped cell number \(indexPath.row).")
        print("You tapped dict number \(String(describing: getDict)).")
        
        let qu = getDict!["url"] as? String ?? "0"
        let range1 = qu.range(of: ".mp4", options: .caseInsensitive)
        if (range1 != nil)
        {
            strVideoImg = "Video"
        }
        let range2 = qu.range(of: ".mp3", options: .caseInsensitive)
        if (range2 != nil)
        {
            strVideoImg = "Audio"
        }
        
        let range3 = qu.range(of: ".jpeg", options: .caseInsensitive)
        if (range3 != nil){
            strVideoImg = "Image"
        }
        
        let range4 = qu.range(of: ".jpg", options: .caseInsensitive)
        if (range4 != nil){
            strVideoImg = "Image"
        }
        
        let range5 = qu.range(of: ".png", options: .caseInsensitive)
        if (range5 != nil){
            strVideoImg = "Image"
        }
        let dataFetch  =  CDBManager().getPodDownloadMediaMethod(getSearchDict: getDict!,searchKey: "particulorKey")
        DispatchQueue.main.async
            {
                self.customAlertController.showActivityIndicatory(uiView: self.view)

                let bonusViewController = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.BonusDetailsVCID) as? BonusDetailsVC
                bonusViewController?.strImgVideo = self.strVideoImg
                bonusViewController?.getUnitDetailDict = getDict!
                self.navigationController?.pushViewController(bonusViewController!, animated: true)
        }

      /*  if dataFetch.count>0
        {
            DispatchQueue.main.async
                {
                let bonusViewController = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.BonusDetailsVCID) as? BonusDetailsVC
                bonusViewController?.getUnitDetailDict = getDict!
                self.navigationController?.pushViewController(bonusViewController!, animated: true)
            }
        }
        else
        {
            self.customAlertController.hideActivityIndicator(uiView: self.view)
        }*/
    }
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()

    }
}
