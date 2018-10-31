//
//  BonusViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/29/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//



import UIKit

class BonusViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,DownloadBtnDelegate{
   

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tblView_bonus: UITableView!
    var getPodMediaData:[AnyObject]?
    var getReadPodMediaData = [AnyObject]()
    var downloadArray = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView_bonus.delegate = self
        tblView_bonus.dataSource = self
        
        print("getPodMediaData ==\(getPodMediaData)")
        downloadArray.removeAll()
        for i in 0..<getPodMediaData!.count {
            var dict = [String: AnyObject]()
            dict["download"] = "notDownload" as AnyObject
            downloadArray.append(dict as AnyObject)
        }
        CDBManager().podMediaInDB(podMediaArr: getPodMediaData!)
       
//        for i in 0..<getPodMediaData!.count{
//
//
//        }
        
        DispatchQueue.main.async {
            self.tblView_bonus.reloadData()
          }
        
        // Do any additional setup after loading the view.
     }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let getUnitsId    = StorageClass.getUnitsId()
        let getArticleId    = StorageClass.getArticleId()
       // let getUnitId = getUnitDict!["unit_id"] as! String
        self.getReadPodMediaData = CDBManager().getPodMediaData(getUnitsId: getUnitsId, getArticleId: getArticleId)
        DispatchQueue.main.async {
            self.tblView_bonus.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getPodMediaData!.count
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: BonusPointCell! = tblView_bonus.dequeueReusableCell(withIdentifier: "BonusPointCell") as? BonusPointCell
        if cell == nil {
            tblView_bonus.register(UINib(nibName: "BonusPointCell", bundle: nil), forCellReuseIdentifier: "BonusPointCell")
            cell = tblView_bonus.dequeueReusableCell(withIdentifier: "BonusPointCell") as? BonusPointCell
           }
        cell.downloadBtnDelegate = self
        cell.backgroundColor = CustomBGColor.grayCellBGColor
        //  cell.backgroundColor = CustomBGColor.GreenCellBGColor
        
        cell.img_circle.image = UIImage(named: "circle-uncheck")
        if  self.getReadPodMediaData.count>0{
            let getTmpDict = self.getReadPodMediaData[indexPath.row] as AnyObject
            let getReadStr = getTmpDict["read"] as? String ?? ""
            if getReadStr == "readed" {
                cell.lbl_cellNo.textColor = UIColor.white
                cell.img_circle.image = UIImage(named: "bonuGreen")
                //  cell.backgroundColor = CustomBGColor.GreenCellBGColor
                }
          }
        let getDict = getPodMediaData![indexPath.row] as! [String:AnyObject]
        let questionArr = getDict["questions"] as? [AnyObject]
        if (questionArr?.count ?? 0) > 0{
           cell.lbl_cellNo?.text = String(questionArr!.count)
        }
        let gettitle = getDict["name"] as! String
        cell.lbl_title.text = gettitle
        // cell.lbl_weekly.text = "Week-" + getWeekly + " " + gettitle
        cell.btn_download.tag = indexPath.row
    
        let getSelectDict = downloadArray[indexPath.row] as! [String: AnyObject]
        
        let getSetStr = getSelectDict["download"] as? String
        if  getSetStr == "download_proccessing"{
            cell.indicator.isHidden = false
            cell.indicator.startAnimating()
            
        }else if getSetStr == "download" {
             cell.indicator.stopAnimating()
             cell.indicator.isHidden = true
            
            let qu = getDict["url"] as? String ?? "0"
            let range1 = qu.range(of: ".mp4", options: .caseInsensitive)
            if (range1 != nil){
                cell.img_download.image = UIImage(named: "media")
            }
            let range2 = qu.range(of: ".mp3", options: .caseInsensitive)
            if (range2 != nil){
                cell.img_download.image = UIImage(named: "audio")
            }
          
            let range3 = qu.range(of: ".jpeg", options: .caseInsensitive)
            if (range3 != nil){
                cell.img_download.image = UIImage(named: "loadImg")
            }
            
            let range4 = qu.range(of: ".jpg", options: .caseInsensitive)
            if (range4 != nil){
                cell.img_download.image = UIImage(named: "loadImg")
            }
            
             //cell.img_download.image = UIImage(named: "")
        
        }else {
            cell.indicator.stopAnimating()
            cell.indicator.isHidden = true
            let qu = getDict["url"] as? String ?? "0"
            let range1 = qu.range(of: ".mp4", options: .caseInsensitive)
            if (range1 != nil){
                cell.img_download.image = UIImage(named: "media")
            }
            let range2 = qu.range(of: ".mp3", options: .caseInsensitive)
            if (range2 != nil){
                cell.img_download.image = UIImage(named: "audio")
            }
            let range3 = qu.range(of: ".jpeg", options: .caseInsensitive)
            if (range3 != nil){
                cell.img_download.image = UIImage(named: "loadImg")
            }
            let range4 = qu.range(of: ".jpg", options: .caseInsensitive)
            if (range4 != nil){
                cell.img_download.image = UIImage(named: "loadImg")
            }
            
          }
      
        return cell
    }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let getDict = getPodMediaData![indexPath.row] as? [String:AnyObject]
        print("You tapped cell number \(indexPath.row).")
        print("You tapped dict number \(getDict).")
      //  let getDict = getPodMediaData![indexPath.item] as? [String:AnyObject]
//                let story = UIStoryboard.init(name: "Main", bundle: nil)
//                let bonusDetailsVC  =  story.instantiateViewController(withIdentifier: "BonusDetailsVC") as! BonusDetailsVC
//                bonusDetailsVC.
//                self.navigationController?.pushViewController(bonusDetailsVC, animated: true)
        
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let bonusViewController = story.instantiateViewController(withIdentifier: "BonusDetailsVC") as? BonusDetailsVC
        bonusViewController?.getUnitDetailDict = getDict!
        self.navigationController?.pushViewController(bonusViewController!, animated: true)
    }
    
    func downloadedCellBtnClick(indexCell: UIButton) {
        
        let position: CGPoint = indexCell.convert(CGPoint.zero, to: tblView_bonus)
        if let indexPath = self.tblView_bonus.indexPathForRow(at: position) {
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
            
        DispatchQueue.global(qos: .background).async {
              let row = indexPath.row
            let dict1 = self.getPodMediaData![indexPath.row] as? [String:AnyObject]
            // var dict1 =  self.downloadArray[indexPath.row] as? [String: AnyObject]
            //self.downloadArray[indexPath.row] = dict as AnyObject
            let urlStr = dict1!["url"] as? String ?? ""
            
            let converUrl = "https://" + urlStr
            
            
            
            CommonWebserviceClass.loadFileAsync(url: URL(string: converUrl as? String ?? "0")!, completion: { (urlFile, error) in
                if error == nil {
                    DispatchQueue.main.async { // Correct
                        dict!["download"] = "download" as AnyObject
                        self.downloadArray[row] = dict as AnyObject
                        self.tblView_bonus.reloadData()
                    }
                    
                }else{
                    
                    DispatchQueue.main.async { // Correct
                        dict!["download"] = "notDownload" as AnyObject
                        self.downloadArray[row] = dict as AnyObject
                        print("===\(dict)")
                        self.tblView_bonus.reloadData()
                    }
                }
            })
            /*
            CommonWebserviceClass.downloadImgFromServer(url:URL(string: converUrl as? String ?? "0")!) { (DATA, RESPOSE, error) in
                if DATA != nil {
                    DispatchQueue.main.async { // Correct
                             dict!["download"] = "notDownload" as AnyObject
                            self.downloadArray[row] = dict as AnyObject
                            self.tblView_bonus.reloadData()
                    }
                }else{
                    
                    DispatchQueue.main.async { // Correct
                        dict!["download"] = "notDownload" as AnyObject
                        self.downloadArray[row] = dict as AnyObject
                        print("===\(dict)")
                        self.tblView_bonus.reloadData()
                    }
                }
            }*/
        }
        }
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
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
