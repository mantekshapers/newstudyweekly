//
//  HomeFileViewController.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//
import UIKit
//import CommonCrypto
//import SlideMenuControllerSwift

class HomeFileViewController: UIViewController, URLSessionDelegate, URLSessionTaskDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CustomAlertBtnDelegate
{
    let customAlertController = CustomController()
    
    @IBOutlet weak var viewNavi : UIView!
    @IBOutlet weak var viewAlrtExtra : UIView!
    @IBOutlet weak var viewAlrtBG : UIView!
    @IBOutlet weak var viewAlrt : UIView!
    @IBOutlet weak var btnPin : UIButton!
    @IBOutlet weak var btnRemove : UIButton!
    @IBOutlet weak var btnClose : UIButton!
    @IBOutlet weak var lblAlrtTitle : UILabel!

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

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
   
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    var publicDataArr = [AnyObject]()
    var task : URLSessionTask!
    
    //MARK: - UIView Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        self.customAlertController.showActivityIndicatory(uiView: self.view)
        btnSideMenu.isUserInteractionEnabled = false
        
        let dbArr = CDBManager().getDataFromDB() as [AnyObject]
        //print(dbArr as AnyObject)
        if dbArr.count>0
        {
            let getDict = dbArr[0] as? [String:AnyObject]
            lblName.text = getDict?["name"] as? String ?? ""
            
            let getPoints = getDict!["points"] as? String ?? ""
            lblCoins.text = getPoints + " Coins"
            
            let userEmailStr = getDict!["userEmail"] as? String ?? ""
            //print("userEmailStr\(userEmailStr)")
            let userRoleStr = getDict!["userRole"] as? String ?? ""
            lblRole.text = userRoleStr
            
            let strChar = String(Array(self.lblName.text!)[0])
            btnSideMenu.setTitle(strChar, for: .normal)
            btnInitial.setTitle(strChar, for: .normal)
        }

        self.wsCallForHomePage()

        self.viewAlrt.layer.cornerRadius = 5.0
        self.viewAlrt.layer.masksToBounds = true
        
        btnSideMenu.layer.cornerRadius = btnSideMenu.frame.size.width / 2
        btnSideMenu.layer.masksToBounds = true
        btnInitial.layer.cornerRadius = btnInitial.frame.size.width / 2
        btnInitial.layer.masksToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        self.viewAlrtBG.addGestureRecognizer(tapGesture)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
        //Bottom Bar
        btnBack.isEnabled = false
        btnNext.isEnabled = false
        btnCopy.isEnabled = true
        btnSearch.isEnabled = true
        btnPlay.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

        viewAlrtBG.isHidden = true
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)
    }
    
    //MARK: - Ws Method
    func wsCallForHomePage()
    {
        NetworkCheckReachbility.isConnectedToNetwork { (bool1) in
            if bool1 == false
            {
                self.publicDataArr = CDBManager().getpublicationFromDB() as [AnyObject]
                DispatchQueue.main.async{
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.btnSideMenu.isUserInteractionEnabled = true
                }
                return
            }

            let userId = NetworkAPI.userID() ?? ""
            let parameters = ["user_id": userId]
            CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.pulications, postString: parameters, httpMethodName: "GET")
            { (response, booll) in
                if booll == false
                {
                    //print("publications error",response as Any)
                    CustomController.showMessage(message: "Server Error")
                }
                else
                {
                    //print("publications RESPOSE",response as Any)
                    let getDict = response as! [String: AnyObject]
                    let keyArr = Array(getDict.keys)
                    if keyArr .contains("error")
                    {
                        self.customAlertController.delegate  = self
                        self.customAlertController.showCustomServerErrorAlert(getMesage: "Your is session expired.Please login again", getView: self)
                    }
                    else
                    {
                        self.btnSideMenu.isUserInteractionEnabled = true
                        CDBManager().addPublicationCDBData(object: getDict)
                        self.publicDataArr = CDBManager().getpublicationFromDB() as [AnyObject]
                        //print("publication==\(self.publicDataArr)")
                        DispatchQueue.main.async {
                            //print("publication=count =\(self.publicDataArr.count)")
                            self.collectionView.reloadData()
                            self.collectionView.collectionViewLayout.invalidateLayout()
                        }
                    }
                }
                DispatchQueue.main.async {
                    
                }
            }
        }
    }

    //MARK: - User Define Method
    func customAlertBtnClick(getAlertTitle: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootViewCallMethod(getAlertTitle:getAlertTitle)
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer)
    {
        if gesture.state != .ended
        {
            return
        }
        
        let point = gesture.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        let checkDownload = publicDataArr[(indexPath?.item)!]["publication_download"] as? String ?? ""
        if checkDownload == "downloaded"
        {
            self.openPinPopup()
            if let indexPath = indexPath
            {
                //print("Find index path\(indexPath.row)")
                btnRemove.tag = indexPath.row
                btnPin.tag = indexPath.row
                viewAlrtBG.isHidden = false
                lblAlrtTitle.text = publicDataArr[indexPath.item]["title"] as? String
            }
            else
            {
                //print("Could not find index path")
            }
        }
        else
        {
            CustomController.showMessage(message: "Please download publication first")
        }
        
    }
    
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer)
    {
        self.closePinPopup()
    }

    func openPinPopup()
    {
        self.viewAlrtBG.alpha = 0.0
        self.viewAlrtExtra.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
            self.viewAlrtBG.alpha = 1
            self.viewAlrtBG.transform = .identity
            self.viewAlrtBG.isHidden = false
        })
    }
    
    func closePinPopup()
    {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.viewAlrtExtra.transform = CGAffineTransform(scaleX: 0.9, y:0.9)
            //self.viewAlrtBG.alpha = 0.0

        }) { (success) in
            self.viewAlrtBG.isHidden = true
        }
    }
    
    //MARK: - UIButton Method
    @IBAction func btnPinclicked(_ sender: UIButton)
    {
        self.closePinPopup()
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        let getUnitsId    = StorageClass.getUnitsId()
        //print("getUnitId:- \(getUnitsId)")
    }
    
    @IBAction func btnRemoveclicked(_ sender: UIButton)
    {
        self.closePinPopup()
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        var dictGet = publicDataArr[sender.tag] as? [String: AnyObject]
        dictGet?["publication_download"] = "notDownload" as String as AnyObject
        publicDataArr[sender.tag] = dictGet! as AnyObject
        let publicationIdStr = dictGet!["publication_id"] as? String
        CDBManager().deletDownloadedPublicationFromDB(publicationId: publicationIdStr!)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func btnCancelclicked(_ sender: UIButton)
    {
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)
        self.closePinPopup()
    }
    
    @IBAction func searchBtnClick(_ sender: UIButton)
    {
        viewAlrtBG.isHidden = true
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.SearchViewControllerID) as! SearchViewController
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @IBAction func fileBtnClick(_ sender: UIButton)
    {
        viewAlrtBG.isHidden = true
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        let tabViewController  =  self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
        self.navigationController?.pushViewController(tabViewController, animated: true)
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
           // viewMenu.isHidden = true
        }
    }

    @IBAction func btnSettingsClicked(_ sender: UIButton)
    {
        viewAlrtBG.isHidden = true
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        let settingController = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.SettingsViewControllerID) as! SettingsViewController
        self.navigationController?.pushViewController(settingController, animated: true)
    }
    
    @IBAction func btnLogoutClicked(_ sender: UIButton)
    {
        viewAlrtBG.isHidden = true
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)

        CDBManager().deleteAllCDB()
        NetworkAPI.removeUserId()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootViewCallMethod(getAlertTitle:"sessionExpired")
    }

    //MARK: - Collection view data source and its delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return publicDataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! CollectionViewCell
        cell.selectedBackgroundView = nil
        
        viewMenu.isHidden = true
        CommonFunctions.closeMenu(view: viewMenu)
        cell.imgCell.layer.borderColor = UIColor.lightGray.cgColor
        cell.imgCell.layer.borderWidth = 1.0
        
        //print("publicDataArr:- \(publicDataArr)")
        let getDict = publicDataArr[indexPath.item] as? [String:AnyObject]
        cell.lbl_title.text = CustomController.checkNullString(strToCompare: getDict!["title"] as! String)
        
        let checkDownload = getDict!["publication_download"] as? String ?? ""
        if checkDownload == "downloaded"
        {
            cell.view_fade.alpha = 0
        }
        else
        {
            cell.view_fade.alpha = 0.85
        }
        
        let coverUrl =  getDict!["cover_url"] as? String ?? ""
        //print("coverUrl=\(coverUrl)")
        
        CommonWebserviceClass.downloadImgFromServer(url:URL(string: coverUrl)!) { (DATA, RESPOSE, error) in
            if DATA != nil {
                DispatchQueue.main.async { // Correct
                    print("DATA:-\(String(describing: DATA))")
                    print("coverUrl:-\(String(describing: coverUrl))")
                    print("RESPOSE:-\(String(describing: RESPOSE))")


                    cell.imgCell.image = UIImage(data: DATA!)
                    self.customAlertController.hideActivityIndicator(uiView: self.view)
                }
            }
        }
        configureCell(cell: cell, forItemAtIndexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    func configureCell(cell: CollectionViewCell, forItemAtIndexPath: NSIndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let view =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as UICollectionReusableView
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let yourWidth = collectionView.frame.size.width/3.0
        let yourHeight = yourWidth * 1.5

        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        let cellIndex = indexPath.item as Int

        NetworkCheckReachbility.isConnectedToNetwork
            { (boolTrue) in
                if boolTrue == false
                {
                    CustomController.showMessage(message: AlertTitle.networkStr)
                    return
                }
                
        self.customAlertController.showActivityIndicatory(uiView: self.view)
        
        var unitData = [AnyObject]()
        let getDict = self.publicDataArr[indexPath.item] as? [String:AnyObject]
        let getUnitArr = getDict!["units"] as? [AnyObject]
        let getPublicationId = getDict!["publication_id"] as? String
        
        //print("=========\(String(describing: getDict))=====\(String(describing: getPublicationId))")
        let unitsArrData = CDBManager().getUnitsDataFromUnitsTable(searchUnits:getPublicationId!)
        
        if unitsArrData.count>0
        {
            DispatchQueue.main.async {
                let weeklyListViewController  = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.WeeklyListViewControllerID) as! WeeklyListViewController
                weeklyListViewController.getWeeklyDict = getDict
                weeklyListViewController.sendUnitsDataArr = unitsArrData
                self.navigationController?.pushViewController(weeklyListViewController, animated: true)
                return
            }
        }
        
        DispatchQueue.main.async {
            cell.progressBar.isHidden = false
            cell.progressBar.progress = 0
            cell.activitiView.isHidden = false
            cell.bringSubview(toFront: cell.activitiView)
            cell.activitiView.startAnimating()
        }
        
        var progressDoubl:Float? = 0
        var countHit:Int = 0
        for data in getUnitArr!
        {
            let getUnitId = data["unit_id"] as! String
            let postDict = ["unit_id":getUnitId]
         //   DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    cell.activitiView.isHidden = false
                    cell.activitiView.startAnimating()
                }
            
                CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.unitsName, postString: postDict, httpMethodName: "GET") { (respose, boolTrue) in
                    if boolTrue == false
                    {
                        DispatchQueue.main.async {
                            cell.activitiView.stopAnimating()
                            cell.activitiView.isHidden = true
                            cell.progressBar.progress = Float((progressDoubl!/Float(getUnitArr!.count)))
                            //unitData.removeAll()
                        }
                        return
                    }
                    var unitsDataDict = [String:AnyObject]()
                    let getDict = respose as! [String: AnyObject]
                    unitsDataDict["units"] = getDict["success"] as AnyObject
                    unitsDataDict["unit_id"] = getUnitId as AnyObject
                    unitData.append(unitsDataDict as AnyObject)
                    
                    DispatchQueue.main.async {
                        countHit = countHit + 1
                        progressDoubl = progressDoubl! + 1
                        cell.progressBar.progress = Float((progressDoubl!/Float(getUnitArr!.count)))
                        if countHit == getUnitArr!.count
                        {
                            cell.activitiView.stopAnimating()
                            cell.activitiView.isHidden = true
                            cell.progressBar.isHidden = true
                            //print("unit response:",unitData,unitData.count)
                            var pubDict = self.publicDataArr[cellIndex] as? [String: AnyObject]
                            pubDict!["publication_download"] = "downloaded" as AnyObject
                            self.publicDataArr[cellIndex] = pubDict as AnyObject
                            //   CDBManager().unitsDeleteFromDB()
                            CDBManager().addUnitsCDBData(publicationIdStr: getPublicationId!, object: unitData)
                            unitData.removeAll()
                            
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            //}
        }
    }
}
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
    
// MARK: - Memory Warning
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
