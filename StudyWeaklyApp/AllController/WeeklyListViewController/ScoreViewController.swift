//
//  ScoreViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/11/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
     var getUnitId:String?
    @IBOutlet weak var tblView_score: UITableView!
      var testQuestionArr = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tblView_score.delegate = self
        self.tblView_score.dataSource = self
        // Do any additional setup after loading the view.
        //https://app.studiesweekly.com/online/api/v2/app/assessments/user_scores?unit_id=127829
        //128061
       // 128061
       // getUnitId
       // scores?test_id=560698
       // let postDict = ["unit_id": "128061"]
        let postDict = ["test_id": getUnitId]
        CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.assessment_scores, postString: postDict as! [String : String], httpMethodName: "GET") { (respose, boolTrue) in
            if boolTrue == false{
                let getDict = respose as! [String:AnyObject]
                DispatchQueue.main.async {
                    //                    self.customAlertController.showCustomAlert3(getMesage: getDict["responseError"] as! String, getView: self)
                    //                    appdelegate?.hideLoader()
                 }
                return
            }
            
            let getDataArr = respose as? [AnyObject]
            
            if (getDataArr?.count ?? 0)>0{
                self.testQuestionArr = getDataArr!
            }
            
            DispatchQueue.main.async {
               // self.tblView_score.reloadData()
                print("test score_response =\(getDataArr ?? [])")
             }
         }
    }
    
    // UITableViewAutomaticDimension calculates height of label contents/text
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Swift 4.1 and below
//        let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
//        let typeStr = getDICT!["type"] as! String
//        if typeStr == "questions_labeling"{
//            return UITableViewAutomaticDimension
//        }
//        return UITableViewAutomaticDimension
        return 100
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //         let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
    //        let typeStr = getDICT!["type"] as! String
    //        if typeStr == "questions_labeling" {
    //        return 200
    //        }else if typeStr == "questions_mc" {
    //            return 100
    //        }else if typeStr == "questions_open"{
    //            return 50
    //        }
    //        return 0
    //    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///let cell = UITableViewCell()
        let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
        let typeStr = getDICT!["type"] as! String
        if typeStr == "questions_labeling" {
            var cell: Sore_labeling_Cell! = tblView_score.dequeueReusableCell(withIdentifier: "Sore_labeling_Cell") as? Sore_labeling_Cell
            if cell == nil {
                tblView_score.register(UINib(nibName: "Sore_labeling_Cell", bundle: nil), forCellReuseIdentifier: "Sore_labeling_Cell")
                cell = tblView_score.dequeueReusableCell(withIdentifier: "TestLblingCell") as? Sore_labeling_Cell
            }
            // let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
            let questStr = getDICT!["question"]  as? String
//            cell.lbl_question.attributedText = CustomController.stringFromHtml(string: questStr!)
            let imgDict = getDICT!["questions_labeling_q_data"] as? [String: AnyObject]
            let imgUrl = imgDict!["url"] as? String
            // let imgeUrl = "https://" + urlDtr
            CommonWebserviceClass.downloadImgFromServer(url:URL(string: imgUrl ?? "0")!) { (DATA, RESPOSE, error) in
                if DATA != nil {
                    DispatchQueue.main.async { // Correct
                        cell.img_labeling.image = UIImage(data: DATA!)
                    }
                }
            }
            return cell
        }else if typeStr == "questions_mc" {
            var cell: Q_mc_Cell! = tblView_score.dequeueReusableCell(withIdentifier: "Q_mc_Cell") as? Q_mc_Cell
            if cell == nil {
                tblView_score.register(UINib(nibName: "Q_mc_Cell", bundle: nil), forCellReuseIdentifier: "Q_mc_Cell")
                cell = tblView_score.dequeueReusableCell(withIdentifier: "Q_mc_Cell") as? Q_mc_Cell
            }
            //  let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
           
            return cell
            
        }else if typeStr == "questions_open"{
            
        }
        return UITableViewCell()
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
