//
//  HomeFileViewController.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//
import UIKit
//import Retrolux
import CommonCrypto
import SlideMenuControllerSwift
class HomeFileViewController: UIViewController,URLSessionDelegate, URLSessionTaskDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SlideMenuControllerDelegate,CustomAlertBtnDelegate,PinItDelegateClass {
   

    var pinView = PinClass()
    let customAlertController = CustomController()
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
   
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    var publicDataArr = [AnyObject]()
     var task : URLSessionTask!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
        NetworkCheckReachbility.isConnectedToNetwork { (bool1) in
            
            if bool1 == false {
                self.publicDataArr = CDBManager().getpublicationFromDB() as [AnyObject]
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    //self.customAlertController.hideActivityIndicator(uiView: self.view)
                }
                return
                
            }
            
       // CDBManager().unitsDeleteFromDB()
        let userId = NetworkAPI.userID() ?? ""
        let parameters = ["user_id": userId]
            self.customAlertController.showActivityIndicatory(uiView: self.view)
        CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.pulications, postString: parameters, httpMethodName: "GET") { (response, booll) in
            if booll == false {
                print(booll) 
                print("publications error",response)
               // self.customAlertController.delegate = self
                self.customAlertController.showCustomAlert3(getMesage: "Server error", getView: self)
            }else{
                print("publications RESPOSE",response)
                let getDict = response as! [String: AnyObject]
                let keyArr = Array(getDict.keys)
                if keyArr .contains("error") {
                    self.customAlertController.delegate  = self
                self.customAlertController.showCustomServerErrorAlert(getMesage: "Your session expired.Please login again", getView: self)
                   
                }else{
                    
               //  CDBManager().deletePublicationAllCDB()
                
                //self.publicDataArr = (getDict["success"] as? [AnyObject])!
                    CDBManager().addPublicationCDBData(object: getDict)
                    self.publicDataArr = CDBManager().getpublicationFromDB() as [AnyObject]
                     print("publication==\(self.publicDataArr)")
                DispatchQueue.main.async {
                     print("publication=count =\(self.publicDataArr.count)")
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    //self.customAlertController.hideActivityIndicator(uiView: self.view)
                }
            }
            }
            DispatchQueue.main.async {
                self.customAlertController.hideActivityIndicator(uiView: self.view)
              }
          }
            
    }
        // Do any additional setup after loading the view.
       }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
        pinView  = (Bundle.main.loadNibNamed("PinClass", owner: self, options: nil)?.first as? PinClass)!
        pinView.pinInDelegateClass = self
        pinView.frame = self.view.frame
        pinView.center = self.view.center
        self.view.addSubview(pinView)
        self.view.bringSubview(toFront: pinView)
        pinView.isHidden = true
    }
   override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(true)
    }
    func customAlertBtnClick(getAlertTitle: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootViewCallMethod(getAlertTitle:getAlertTitle)
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        if gesture.state != .ended {
            return
        }
        
        let point = gesture.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
           // var cell = self.collectionView.cellForItem(at: indexPath)
            print("Find index path\(indexPath.row)")
            print(indexPath.row)
            pinView.isHidden = false
            pinView.btn_pinIt.tag = indexPath.row
            pinView.btn_remove.tag = indexPath.row
        } else {
            print("Could not find index path")
        }

      }
    
    
    func pinItMethodCall(getIndex: Int) {
                pinView.isHidden = true
         let getUnitsId    = StorageClass.getUnitsId()
//           let spaceData = StorageSizeClass.getStorageSpace() as Double
//        print("device space showing now..\(spaceData)")
           }
    
    func removeMethodCall(getIndex: Int) {
         self.pinView.isHidden = true
        var dictGet = publicDataArr[getIndex] as? [String: AnyObject]
        dictGet?["publication_download"] = "notDownload" as String as AnyObject
      // publicDataArr.count
        publicDataArr[getIndex] = dictGet! as AnyObject
        let publicationIdStr = dictGet!["publication_id"] as? String
          self.pinView.isHidden = true
        CDBManager().deletDownloadedPublicationFromDB(publicationId: publicationIdStr!)
        DispatchQueue.main.async {
             self.collectionView.reloadData()
           }
        
      }
    
    func cancelMethodCall() {
         pinView.isHidden = true
        
     }
    //MARK: Collection view data source and its delegate
    
        func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            return 1     //return number of sections in collection view
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return publicDataArr.count    //return number of rows in section
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! CollectionViewCell
            let getDict = publicDataArr[indexPath.item] as? [String:AnyObject]
            cell.lbl_title.text = getDict!["title"] as? String ?? ""
            let coverUrl =  getDict!["cover_url"] as? String ?? ""
           // var pubDict = publicDataArr[cellIndex] as? [String: AnyObject]
          let checkDownload = getDict!["publication_download"] as? String ?? ""
            // cell.imgCell.alpha = 0
             cell.view_fade.backgroundColor = UIColor.gray
            cell.view_fade.alpha = 0.6
            if checkDownload == "downloaded" {
                 cell.view_fade.alpha = 0
            }
            print("hell image url=\(coverUrl)")
            CommonWebserviceClass.downloadImgFromServer(url:URL(string: coverUrl as? String ?? "0")!) { (DATA, RESPOSE, error) in
                if DATA != nil {
                DispatchQueue.main.async { // Correct
                     cell.imgCell.image = UIImage(data: DATA!)
                   }
                }
            }
            configureCell(cell: cell, forItemAtIndexPath: indexPath as NSIndexPath)

            return cell      //return your cell
        }
        func configureCell(cell: CollectionViewCell, forItemAtIndexPath: NSIndexPath) {
        }
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let view =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as UICollectionReusableView
            return view
        }
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let nbCol = 2
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(nbCol - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(nbCol))
            return CGSize(width: size, height: size)
        }
        func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
            return true
        }
        func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            print("Starting Index: \(sourceIndexPath.item)")
             let sourceDict = publicDataArr[sourceIndexPath.item] as AnyObject
            print("Ending Index: \(destinationIndexPath.item)")
            let desDict = publicDataArr[destinationIndexPath.item] as AnyObject
            publicDataArr[sourceIndexPath.item] = desDict
            publicDataArr[destinationIndexPath.item] = sourceDict
            collectionView.reloadData()
        }
        //MARK: UICollectionViewDelegate
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            let cellIndex = indexPath.item as Int
            var unitData = [AnyObject]()
            let getDict = publicDataArr[indexPath.item] as? [String:AnyObject]
            let getUnitArr = getDict!["units"] as? [AnyObject]
            let getPublicationId = getDict!["publication_id"] as? String
            
            print("=========\(getDict)=====\(getPublicationId)")
            let unitsArrData = CDBManager().getUnitsDataFromUnitsTable(searchUnits:getPublicationId!)
            
            if unitsArrData.count>0{
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                let weeklyListViewController  =  story.instantiateViewController(withIdentifier: "WeeklyListViewController") as! WeeklyListViewController
                weeklyListViewController.getWeeklyDict = getDict
                weeklyListViewController.sendUnitsDataArr = unitsArrData
                self.navigationController?.pushViewController(weeklyListViewController, animated: true)
                return
            }
          //  print("publications array\(publicationData)")
           
            
           
          //  print("unitArray count==\(String(describing: getUnitArr?.count))")
         //   DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    cell.progressBar.isHidden = false
                    cell.progressBar.progress = 0
                    cell.activitiView.isHidden = false
                    cell.activitiView.startAnimating()
                 }
                 var progressDoubl:Float? = 0
                 var countHit:Int = 0
            for data in getUnitArr!{
                let getUnitId = data["unit_id"] as! String
                let postDict = ["unit_id":getUnitId]
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                   // cell.progressBar.isHidden = false
                   // cell.progressBar.progress = 0
                    cell.activitiView.isHidden = false
                    cell.activitiView.startAnimating()
                }
               
                CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.unitsName, postString: postDict, httpMethodName: "GET") { (respose, boolTrue) in
                    if boolTrue == false{
//                        let getDict = respose as! [String:AnyObject]
//                        DispatchQueue.main.async {
//                            self.customAlertController.showCustomAlert3(getMesage: getDict["responseError"] as! String, getView: self)
//                            appdelegate?.hideLoader()
//                        }
                         DispatchQueue.main.async {
                        cell.activitiView.stopAnimating()
                        cell.activitiView.isHidden = true
                        cell.progressBar.progress = Float((progressDoubl!/Float(getUnitArr!.count)))
                            unitData.removeAll()
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
                        if countHit == getUnitArr!.count {
                            cell.activitiView.stopAnimating()
                             cell.activitiView.isHidden = true
                             cell.progressBar.isHidden = true
                            print("unit response",unitData,unitData.count)
                            var pubDict = self.publicDataArr[cellIndex] as? [String: AnyObject]
                            pubDict!["publication_download"] = "downloaded" as AnyObject
                            self.publicDataArr[cellIndex] = pubDict as AnyObject
                         //   CDBManager().unitsDeleteFromDB()
                           CDBManager().addUnitsCDBData(publicationIdStr: getPublicationId!, object: unitData)
                            unitData.removeAll()
                           
                            self.collectionView.reloadData()
                           }
                       
                    }
               }
            }
           // }
         }
        
            /*
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let weeklyListViewController  =  story.instantiateViewController(withIdentifier: "WeeklyListViewController") as! WeeklyListViewController
            weeklyListViewController.getWeeklyDict = getDict
            self.navigationController?.pushViewController(weeklyListViewController, animated: true)
            */
           // downloadVideoFile()
        }
        
        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            // When user deselects the cell
          }
    
    @IBAction func menuBtnClick(_ sender: Any) {
          self.slideMenuController()?.openLeft()
      }

    @IBAction func searchBtnClick(_ sender: UIButton) {
         let story = UIStoryboard.init(name: "Main", bundle: nil)
         let searchViewController  =  story.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(searchViewController, animated: true)
        
    }
    
    @IBAction func fileBtnClick(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let searchViewController  =  story.instantiateViewController(withIdentifier: "ScreenViewController") as! ScreenViewController
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
/*
    lazy var session : URLSession = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        // let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.mainQueue)
        // let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        return session
    }()
    
    func downloadVideoFile(getUrlUnitId:String){
     
       // s3-us-west-2.amazonaws.com/static.studiesweekly.com/online/masterResources/audio/new35/149076/final.mp3
   // let s = "https://dl.dropboxusercontent.com/u/87285547/09%20Working%20Man_%20Finding%20My%20Way.mp3"
        let s = "https://s3-us-west-2.amazonaws.com/static.studiesweekly.com/online/masterResources/audio/new35/149076/final.mp3"
    let url = NSURL(string:s)!
    let req = NSMutableURLRequest(url:url as URL)
    let task = self.session.downloadTask(with: req as URLRequest)
    self.task = task
    task.resume()

    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        print("downloaded=7 \(100*writ/exp)")
        
       // self.counter = Float(100*writ/exp)
        
       // guard let url = downloadTask.originalRequest?.url,
           //let download = downloadService.activeDownloads[url]  else { return }
        // 2
      //  download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        // 3
        //let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite,
                                                 // countStyle: .file)
        // 4
//        DispatchQueue.main.async {
//            if let trackCell = self.tableView.cellForRow(at: IndexPath(row: download.track.index,
//                                                                       section: 0)) as? TrackCell {
//                trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
//            }
//        }
    //}
    
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        // unused in this example
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("completed: error: \(error)")
    }
    
    // this is the only required NSURLSessionDownloadDelegate method
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("didFinishDownloading")
        
    }
    */
   
     // let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.mainQueue)
    

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
