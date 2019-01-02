//
//  WeeklyListViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/22/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class WeeklyListViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var lbl_hearderTitle: UILabel!
    
    @IBOutlet weak var tblView: UITableView!
    var getWeeklyDict:[String:AnyObject]?
    var weeklyArr = [AnyObject]()
    var sendUnitsDataArr = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        tblView.dataSource = self
        tblView.delegate = self
        print("+++++++++++++\(getWeeklyDict!)")
        weeklyArr = getWeeklyDict!["units"] as! [AnyObject]
        lbl_hearderTitle.text = getWeeklyDict!["title"] as? String ?? ""
        // Do any additional setup after loading the view.
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyArr.count
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: WeeklyTableViewCell! = tblView.dequeueReusableCell(withIdentifier: "WeeklyTableViewCell") as? WeeklyTableViewCell
        if cell == nil {
            tblView.register(UINib(nibName: "WeeklyTableViewCell", bundle: nil), forCellReuseIdentifier: "WeeklyTableViewCell")
            cell = tblView.dequeueReusableCell(withIdentifier: "WeeklyTableViewCell") as? WeeklyTableViewCell
                 }
        
        let getDict = weeklyArr[indexPath.row] as! [String:AnyObject]
        let getWeekly = getDict["week_num"]  as! String
        let gettitle = getDict["title"] as! String
        cell.lbl_weekly.text = "Week-" + getWeekly + " " + gettitle
        return cell
        
        }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let getDict = weeklyArr[indexPath.row] as? [String:AnyObject]
         let getUnitId = getDict!["unit_id"] as! String
       //  print("unitsArr\(sendUnitsDataArr)")
      //  for i in 0..<sendUnitsDataArr.count {
          //  let getDict1 = sendUnitsDataArr[i] as! [String: AnyObject]
           // let getUnitId1 = getDict1["unit_id"] as! String
           // if getUnitId1 == getUnitId{
          let story = UIStoryboard.init(name: "Main", bundle: nil)
          let weeklyUnitListVC  =  story.instantiateViewController(withIdentifier: "WeeklyUnitListVC") as! WeeklyUnitListVC
        weeklyUnitListVC.getUnitDict = getDict!
           weeklyUnitListVC.getUnitDataArr = sendUnitsDataArr
        self.navigationController?.pushViewController(weeklyUnitListVC, animated: true)
           // }
       // }
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
