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
class WeeklyUnitListVC: UIViewController ,UITableViewDataSource,UITableViewDelegate,UIApplicationDelegate{
    
      let customAlertController = CustomController()
    @IBOutlet weak var lbl_headerTitle: UILabel!
    
    @IBOutlet weak var tblView_unit: UITableView!
    
    @IBOutlet weak var testView_constHeight: NSLayoutConstraint!
    var unitArr = [AnyObject]()
     var getUnitDataArr = [AnyObject]()
    var articleDataArr = [AnyObject]()
    var getUnitDict:[String:AnyObject] = [:]
    var typeGetTitle:String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        "article_id" = 27327;
//        content = "grown. What might have been different if the Russians and the Aleut had shared STARTOFFOUNDTEXTpublicENDOFFOUNDTEXT space fairly? Where in your community is there a debate over STARTOFFOUNDTEXTpublicENDOFFOUNDTEXT land? How should";
//        "publication_id" = 6388;
//        title = "Vitus Bering and Russian Colonies in Alaska";
//        "unit_id" = 6449;
        
        self.tblView_unit.dataSource = self
        self.tblView_unit.delegate = self
        testView_constHeight.constant = 0
       // /online/api/v2/app/units?unit_id=127809
        print("title==\(getUnitDict)")
        self.lbl_headerTitle?.text = getUnitDict["title"] as? String
        let getUnitId = getUnitDict["unit_id"] as! String
        if typeGetTitle != "FromSearch"{
          for i in 0..<getUnitDataArr.count {
          let getDict1 = getUnitDataArr[i] as! [String: AnyObject]
          let getArr = getDict1["units"] as! [AnyObject]
            for j in 0..<getArr.count {
                let getTemp = getArr[j]
                let getUnitsId = getTemp["unit_id"] as? String
                print("unitId\(getUnitsId)")
                if getUnitId == getUnitsId {
                    unitArr = (getTemp["units"] as? [AnyObject])!
                    CDBManager().addArticleInDB(getArticleData: unitArr,saveUnitsId: getUnitsId!)
                }
          }
        }
        }else{
            
            CDBManager().addArticleInDB(getArticleData: unitArr,saveUnitsId: getUnitId)
        }
        
        
      //  let getUnitId = getUnitDict["unit_id"] as! String
       // self.articleDataArr = CDBManager().getArticleData(getUnitsId: getUnitId)
        
        DispatchQueue.main.async {
            print("articleDataArr===\(self.articleDataArr)")
            self.tblView_unit.reloadData()
        }
        
         let getUserId    = NetworkAPI.userID()
        let postDict = ["unit_id":getUnitId,"user_id": getUserId]
//        let appdelegate = UIApplication.shared.delegate as? AppDelegate
//        DispatchQueue.main.async {
//             appdelegate?.showLoader()
//        }

        CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.testAvailable, postString: postDict as! [String : String], httpMethodName: "GET") { (respose, boolTrue) in
            
            if boolTrue == false{
                let getDict = respose as! [String:AnyObject]
                DispatchQueue.main.async {
//                    self.customAlertController.showCustomAlert3(getMesage: getDict["responseError"] as! String, getView: self)
//                    appdelegate?.hideLoader()
                }
                return
             }
           
            let getDict = respose as? [String:String]
            let avaibleStr = getDict!["valueKey"]
           
            DispatchQueue.main.async {
              
                if avaibleStr == "1"{
                    self.testView_constHeight.constant = 60
                }else {
                    self.testView_constHeight.constant = 0
                    
                }
            }
            print("unit response",getDict)
             }
 
        // Do any additional setup after loading the view.
        }
    
    
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
         let getUnitId = getUnitDict["unit_id"] as! String
        self.articleDataArr = CDBManager().getArticleData(getUnitsId: getUnitId)
        
        DispatchQueue.main.async {
            print("articleDataArr===\(self.articleDataArr)")
            self.tblView_unit.reloadData()
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unitArr.count
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: WeeklyUnitListCell! = tblView_unit.dequeueReusableCell(withIdentifier: "WeeklyUnitListCell") as? WeeklyUnitListCell
        if cell == nil {
            tblView_unit.register(UINib(nibName: "WeeklyUnitListCell", bundle: nil), forCellReuseIdentifier: "WeeklyUnitListCell")
            cell = tblView_unit.dequeueReusableCell(withIdentifier: "WeeklyUnitListCell") as? WeeklyUnitListCell
        }
         cell.imgView.image = UIImage(named: "circle-uncheck")
        if  self.articleDataArr.count>0{
            let getTmpDict = self.articleDataArr[indexPath.row] as AnyObject
            let getReadStr = getTmpDict["read"] as? String ?? ""
            if getReadStr == "readed" {
                 cell.imgView.image = UIImage(named: "circle-check")
          //  cell.backgroundColor = CustomBGColor.GreenCellBGColor
            }
        }
       
        let getDict = unitArr[indexPath.row] as! [String:AnyObject]
        let gettitle = getDict["article_title"] as! String
        cell.lbl_title.text = gettitle
       // cell.lbl_weekly.text = "Week-" + getWeekly + " " + gettitle
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        print("You tapped cell number \(indexPath.row).")
           let getDict = unitArr[indexPath.row] as? [String:AnyObject]
           let getArtcleDict =   self.articleDataArr[indexPath.row]  as? [String: AnyObject]
       
      
        
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let weeklyDetailVC  =  story.instantiateViewController(withIdentifier: "WeeklyDetailVC") as! WeeklyDetailVC
        weeklyDetailVC.getUnitDetailDict = getDict
        weeklyDetailVC.getArticleDetailDict = getArtcleDict
        self.navigationController?.pushViewController(weeklyDetailVC, animated: true)
        
//        let story = UIStoryboard.init(name: "Main", bundle: nil)
//        let weeklyDetailVC  =  story.instantiateViewController(withIdentifier: "DemoTestViewController") as! DemoTestViewController
//        weeklyDetailVC.getUnitDetailDict = getDict
//        weeklyDetailVC.getArticleDetailDict = getArtcleDict
//        self.navigationController?.pushViewController(weeklyDetailVC, animated: true)
        
    }
    
    @IBAction func testScoreBtnClick(_ sender: UIButton) {
        
        let getUnitId = getUnitDict["unit_id"] as! String
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let scoreViewController  =  story.instantiateViewController(withIdentifier: "ScoreViewController") as! ScoreViewController
        scoreViewController.getUnitId = getUnitId
        self.navigationController?.pushViewController(scoreViewController, animated: true)
        
    }
    
    @IBAction func testBtnClick(_ sender: UIButton) {
        
      //  http://s3-us-west-2.amazonaws.com/audio-test-questions/2994814.mp3
        
         let getUnitId = getUnitDict["unit_id"] as! String

        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let testViewController  =  story.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
        testViewController.getUnitId = getUnitId
        self.navigationController?.pushViewController(testViewController, animated: true)
        
//        let story = UIStoryboard.init(name: "Main", bundle: nil)
//        let testViewController  =  story.instantiateViewController(withIdentifier: "GestureVC") as! GestureVC
//        self.navigationController?.pushViewController(testViewController, animated: true)
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
