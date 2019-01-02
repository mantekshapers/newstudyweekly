                                                                                                                                                                                                               //
//  SearchViewController.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import SDWebImage
class SearchViewController: UIViewController ,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,CustomAlertBtnDelegate{
    let customAlertController = CustomController()
    @IBOutlet weak var lbl_allbtn: UILabel!
    @IBOutlet weak var lbl_articleBtn: UILabel!
    @IBOutlet weak var llbl_mediaBtn: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tblView_search: UITableView!
    
    var dataSearchArr = [AnyObject]()
    var standardArr = [AnyObject]()
    var articleArr = [AnyObject]()
     var mediaArr = [AnyObject]()
    var psssUnitDict = [String:AnyObject]()
      var searchUnitArr = [AnyObject]()
    
    var btn_identity:String?
    var imgUrlStr:String?
    var imgSplash:String?
    var units_idTemp:String?
    var gaurInt:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        searchBar.delegate = self
        tblView_search.delegate =  self
        tblView_search.dataSource = self
        btn_identity = "standard"
        lbl_allbtn.backgroundColor = UIColor.red
        // Do any additional setup after loading the view.
//        let trU = gaurInt
//        print(gaurInt ?? 0)
//        lbl_allbtn.text = String(gaurInt ?? 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
        searchBar.backgroundColor = UIColor.clear
        searchBar.layer.backgroundColor = UIColor.clear.cgColor
        searchBar.backgroundImage = UIImage()
        DispatchQueue.main.async {
            self.tblView_search.reloadData()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if btn_identity == "standard"{
           
             return standardArr.count
            
        }else if btn_identity == "articles"{
            
            return articleArr.count
            
        }else if btn_identity == "media"{
            return mediaArr.count
        }
        return 0
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: SearchCell! = tblView_search.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell
        if cell == nil {
            tblView_search.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
            cell = tblView_search.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell
          }
//        addDict["media_id"] = getDict["media_id"] as? String as AnyObject
//        addDict["media_name"] = getDict["video_name"] as? String as AnyObject
//        addDict["media_splash"] = getDict["video_splash"] as? String as AnyObject
//        addDict["media_descriptio"] = getDict["video_description"] as? String as AnyObject
//        addDict["media_source"] = getDict["video_source"] as? String as AnyObject
        
        cell.activity_cellView.isHidden = true
        cell.imgView_search.image = UIImage(named: "")
         cell.imgView_search.backgroundColor = UIColor.clear
        if btn_identity == "standard"{
            let dataDict = standardArr[indexPath.row] as? [String:AnyObject]
            let audioName = dataDict!["title"] as? String ?? ""
            cell.lbl_searchTitle.text = audioName

        }else if btn_identity == "articles"{
            let dataDict = articleArr[indexPath.row] as? [String:AnyObject]
            let audioName = dataDict!["title"] as? String ?? ""
            cell.lbl_searchTitle.text = audioName
            
        }else if btn_identity == "media"{
             let dataDict = mediaArr[indexPath.row] as? [String:AnyObject]
             imgSplash = dataDict!["media_source"] as? String ?? " "
            let downloadData = dataDict!["download"] as? String
            
           
            let string = imgSplash
            if (string?.range(of: ".mp4")) != nil {
                if downloadData == "download"{
                   cell.imgView_search.image = UIImage(named: "video_selecetd.png")
                }else{
                     cell.imgView_search.image = UIImage(named: "video.png")
                 }
               
            }else if (string?.range(of: ".mp3")) != nil {
                if downloadData == "download"{
                    cell.imgView_search.image = UIImage(named: "music_icon_selected.png")
                }else{
                    cell.imgView_search.image = UIImage(named: "music.png")
                }
               
            }else {
                if downloadData == "download"{
                    cell.imgView_search.image = UIImage(named: "image_selected.png")
                }else{
                    cell.imgView_search.image = UIImage(named: "image.png")
                }
                
              }
            
//            if (imgSplash?.contains(".mp4"))!{
//                 cell.imgView_search.image = UIImage(named: "media.png")
//            }else{
//                 cell.imgView_search.image = UIImage(named: "audio.png")
//
//            }
            let audioName = dataDict!["media_name"] as? String ?? ""
            cell.lbl_searchTitle.text = audioName
           }
        //video_splash
//        imgSplash = CustomController.spaceStrRemovefromStr(getString: imgSplash ?? "")
//        cell.imgView_search.sd_setImage(
//            with: URL(string: "http://" + imgSplash!),
//            placeholderImage: UIImage(named: "loadImg"),
//            options: SDWebImageOptions(rawValue: 0),
//            completed: { image, error, cacheType, imageURL in
//            cell.imgView_search.image = image
//                // your rest code
//        }
//        )
//
       // cell.imgView_search.image =
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let cell = self.tblView_search.cellForRow(at: indexPath) as! SearchCell
        
//        let cell = tableView.cellForItem(at: indexPath) as! SearchCell
//        let cellIndex = indexPath.item as Int
        
        if btn_identity == "standard"{
            let dataDict = standardArr[indexPath.row] as? [String:AnyObject]
            psssUnitDict = dataDict!
          
            units_idTemp = dataDict!["unit_id"] as? String ?? ""
            
            
        }else if btn_identity == "articles"{
            let dataDict = articleArr[indexPath.row] as? [String:AnyObject]
             psssUnitDict = dataDict!
            units_idTemp = dataDict!["unit_id"] as? String ?? ""
        
        }else if btn_identity == "media"{
              var dataDict = mediaArr[indexPath.row] as? [String:AnyObject]
             psssUnitDict = dataDict!
             units_idTemp = dataDict!["unit_id"] as? String ?? ""
            
           // CommonDownloadClass().downloadVideoFile(urlFile: "")
            /*
           // VideoViewController
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let searchMediaViewController  =  story.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            
                        searchMediaViewController.getMediaDict = self.psssUnitDict
                        self.navigationController?.pushViewController(searchMediaViewController, animated: true)
                                                                                                                                                                                                                */
            let searchData =  CDBManager().getSearchMedia(getSearchDict: self.psssUnitDict,searchKey: "particulorKey")
            if searchData.count>0 {
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                let searchMediaViewController  =  story.instantiateViewController(withIdentifier: "SearchMediaViewController") as! SearchMediaViewController
                searchMediaViewController.getMediaDict = psssUnitDict
                self.navigationController?.pushViewController(searchMediaViewController, animated: true)
            }else{
                
                DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    cell.activity_cellView.isHidden = false
                    cell.activity_cellView.startAnimating()
                  }
                CommonDownloadClass().saveVideo(getMediDict: self.psssUnitDict, completion: { (urlFile, error) in
                    if error == nil{
                        dataDict?["download"] = "download" as AnyObject
                        self.mediaArr[indexPath.row] = dataDict as AnyObject
                    }
                     DispatchQueue.main.async {
                        cell.activity_cellView.stopAnimating()
                        cell.activity_cellView.isHidden = true
                        
                        self.tblView_search.reloadData()
                    }
                })
            }
            }
            
            return
         }
      
            let postDict = ["unit_id":units_idTemp]
           DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                // cell.progressBar.isHidden = false
                // cell.progressBar.progress = 0
                cell.activity_cellView.isHidden = false
                cell.activity_cellView.startAnimating()
            }
                CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.unitsName, postString: postDict as! [String : String], httpMethodName: "GET") { (respose, boolTrue) in
                    if boolTrue == false{
                        DispatchQueue.main.async {
                             cell.activity_cellView.stopAnimating()
                             cell.activity_cellView.isHidden = true
                          }
                        return
                    }
                    var unitsDataDict = [String:AnyObject]()
                  
                    let getDict = respose as! [String: AnyObject]
                    
                    print("search media article==\(getDict)")
                    unitsDataDict["units"] = getDict["success"] as AnyObject
                    unitsDataDict["unit_id"] = self.units_idTemp as AnyObject
                    
                    let searchGetData = getDict["success"] as! [AnyObject]
                    self.searchUnitArr = searchGetData
                   // unitData.append(unitsDataDict as AnyObject)
                      DispatchQueue.main.async {
                        cell.activity_cellView.stopAnimating()
                        cell.activity_cellView.isHidden = true
                    let story = UIStoryboard.init(name: "Main", bundle: nil)
                    let weeklyUnitListVC1  =  story.instantiateViewController(withIdentifier: "WeeklyUnitListVC") as! WeeklyUnitListVC
                    weeklyUnitListVC1.typeGetTitle = "FromSearch"
                    weeklyUnitListVC1.getUnitDict = self.psssUnitDict
                    weeklyUnitListVC1.unitArr =  ((self.searchUnitArr as AnyObject) as? [AnyObject])!
                        
                        self.navigationController?.pushViewController(weeklyUnitListVC1, animated: true)
                       }
                    /*
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
                         
                            CDBManager().addUnitsCDBData(publicationIdStr: getPublicationId!, object: unitData)
                         
                            
                            self.tblView_search.reloadData()
 
                        }
                     
                    }
                */
                 
               // }
                
              }
           }
        }
    @IBAction func btnsClick(_ sender: UIButton) {
         lbl_allbtn.backgroundColor = UIColor.clear
        lbl_articleBtn.backgroundColor = UIColor.clear
        llbl_mediaBtn.backgroundColor = UIColor.clear
        let btnTag = sender.tag as Int
        if btnTag == 0 {
            btn_identity = "standard"
             lbl_allbtn.backgroundColor = UIColor.red
           
        }else if btnTag == 1 {
            btn_identity = "articles"
             lbl_articleBtn.backgroundColor = UIColor.red
        }else {
             btn_identity = "media"
             llbl_mediaBtn.backgroundColor = UIColor.red
         }
        DispatchQueue.main.async {
            self.tblView_search.reloadData()
        }
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            return
        }
        if btn_identity == "standard"{
            searchMethod(methodName: WebserviceName.searchStandard, terms: searchBar.text!)
        }else if btn_identity == "articles"{
             searchMethod(methodName: WebserviceName.searchArticles, terms: searchBar.text!)
            
        }else if btn_identity == "media"{
             searchMethod(methodName: WebserviceName.searchMedia, terms: searchBar.text!)
        }
         searchBar.resignFirstResponder()
    }
    
    func searchMethod(methodName:String,terms:String){
        dataSearchArr.removeAll()
        CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + methodName, postString: ["term":terms], httpMethodName: "GET") { (response, booll) in
            if booll == false {
                print(booll)
            }else{
                print("Searching RESPOSE",response!)
                if response is Array<Any> {
                    self.dataSearchArr = response as! [AnyObject]
                    if self.btn_identity == "standard"{
                        self.standardArr = self.dataSearchArr
                    }else if self.btn_identity == "articles"{
                        self.articleArr = self.dataSearchArr
                    }else if self.btn_identity == "media"{
                        self.mediaArr = self.dataSearchArr
                    }
                    
                }else{
                let getDict = response as! [String: AnyObject]
                let keyArr = Array(getDict.keys)
                if keyArr .contains("error") {
                    self.customAlertController.delegate  = self
                    self.customAlertController.showCustomServerErrorAlert(getMesage: "Your session expired.Please login again", getView: self)
                    
                }else{
                    
                    let addOnRes = Media(audio: getDict["audio"] as? [AnyObject], images: getDict["images"] as? [AnyObject], videos: getDict["videos"] as? [AnyObject])
                    
//                     print("==Udio_audio==\(addOnRes.audio)")
//                     print("==Udio_image==\(addOnRes.images)")
//                     print("==Udio_video==\(addOnRes.videos)")
                
                    let audioArr = getDict["audio"] as? [AnyObject]
              
                    if (audioArr?.count)!>0{
                        for x in 0..<audioArr!.count {
                            var addDict = [String:AnyObject]()
                            let getDict = audioArr![x] as! [String:AnyObject]
                            addDict["media_id"] = getDict["media_id"] as? String as AnyObject
                             addDict["media_name"] = getDict["audio_name"] as? String as AnyObject
                             addDict["media_splash"] = getDict["audio_splash"] as? String as AnyObject
                             addDict["media_description"] = getDict["audio_descriptio"] as? String as AnyObject
                             addDict["media_source"] = getDict["audio_source"] as? String as AnyObject
                             addDict["download"] = "notDownload" as AnyObject
                            self.dataSearchArr.append(addDict as AnyObject)
                            }
                    }
//                    "media_id": "1703",
//                    "image_name": "Constitution of the United States",
//                    "image_description": "<p>\n\tThe Constitution of the United States\n<\/p>",
//                    "optimized_image_source": null,
//                    "image_source": "s3-us-west-2.amazonaws.com\/static.studiesweekly.com\/online\/resources\/55\/75\/constitution_1_of_4_630.jpg",
//                    "source_info": "[Public Domain]"
                    
                    let imageArr = getDict["images"] as? [AnyObject]

                    if (imageArr?.count)!>0{
                        for x in 0..<imageArr!.count {
                            var addDict = [String:AnyObject]()
                            let getDict = imageArr![x] as! [String:AnyObject]
                            
                            addDict["media_id"] = getDict["media_id"] as? String as AnyObject
                            addDict["media_name"] = getDict["image_name"] as? String as AnyObject
                            addDict["media_splash"] = getDict["source_info"] as? String as AnyObject
                            addDict["media_description"] = getDict["image_description"] as? String as AnyObject
                            addDict["media_source"] = getDict["image_source"] as? String as AnyObject
                            addDict["download"] = "notDownload" as AnyObject
                            self.dataSearchArr.append(addDict as AnyObject)
                        }
                    }
                    
                    let videoArr = getDict["videos"] as? [AnyObject]
                    
                    if (videoArr?.count)!>0{
                        for x in 0..<videoArr!.count {
                            var addDict = [String:AnyObject]()
                            let getDict = videoArr![x] as! [String:AnyObject]
                            addDict["media_id"] = getDict["media_id"] as? String as AnyObject
                            addDict["media_name"] = getDict["video_name"] as? String as AnyObject
                            addDict["media_splash"] = getDict["video_splash"] as? String as AnyObject
                            addDict["media_description"] = getDict["video_description"] as? String as AnyObject
                            addDict["media_source"] = getDict["video_source"] as? String as AnyObject
                            addDict["download"] = "notDownload" as AnyObject
                            self.dataSearchArr.append(addDict as AnyObject)
                        }
                    }
                
                        //self.customAlertController.hideActivityIndicator(uiView: self.view)
            
                    if self.btn_identity == "standard"{
                        self.standardArr = self.dataSearchArr
                    }else if self.btn_identity == "articles"{
                        self.articleArr = self.dataSearchArr
                    }else if self.btn_identity == "media"{
                        let dataFetch  =  CDBManager().getSearchMedia(getSearchDict: self.psssUnitDict,searchKey: "AllFetch")
                        for var i in 0..<dataFetch.count{
                            let dataDict = dataFetch[i] as? [String:AnyObject]
                            let nediaIdTmp = dataDict!["media_id"] as? String
                            let nediaSourceTmp = dataDict!["media_source"] as? String
                            for var j in 0..<self.dataSearchArr.count{
                                var data1Dict = self.dataSearchArr[j] as? [String:AnyObject]
                                let nediaIdTmp1 = data1Dict!["media_id"] as? String
                                
                                if nediaIdTmp == nediaIdTmp1 {
                                    data1Dict!["download"] = "download" as AnyObject
                                    data1Dict!["media_source"] = nediaSourceTmp as AnyObject
                                    self.dataSearchArr[j] = data1Dict as AnyObject
                                    
                                    print("nediaIdTmp==\(nediaIdTmp)& nediaIdTmp1==\(nediaIdTmp1)")
                                }
                                
                            }
                            
                        }
                        self.mediaArr = self.dataSearchArr
                        
                        print(" media data print==\(self.mediaArr)")
                    }
                    }
                }
                DispatchQueue.main.async {
                    self.tblView_search.reloadData()
                    
                }
                }
            
            }
    }
    
    
    func customAlertBtnClick(getAlertTitle: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootViewCallMethod(getAlertTitle:getAlertTitle)
    }
    
    @IBAction func backSearchBtnClick(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
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
