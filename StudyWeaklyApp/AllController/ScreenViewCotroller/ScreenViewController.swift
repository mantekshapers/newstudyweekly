//
//  ScreenViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/16/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class ScreenViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,ScreenCellDelegate{
    
    @IBOutlet weak var lbl_select: UILabel!
    
    @IBOutlet weak var lbl_setting: UILabel!
    
    @IBOutlet weak var tblView_screen: UITableView!
    var dataScreenArr = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView_screen.delegate = self
        self.tblView_screen.dataSource = self
       
        
        for i in 0..<20{
            
            dataScreenArr.append("unselect" as AnyObject)
        }
        
        DispatchQueue.main.async {
            self.tblView_screen.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tabAsettingBtnClick(_ sender: UIButton) {
        lbl_select.backgroundColor = CustomBGColor.clearBGColor
        lbl_setting.backgroundColor = CustomBGColor.clearBGColor
        if sender.tag == 0 {
            lbl_select.backgroundColor =  CustomBGColor.selectBGColor
        }else if sender.tag == 1{
             lbl_setting.backgroundColor =  CustomBGColor.selectBGColor
          }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: ScreenCell! = tblView_screen.dequeueReusableCell(withIdentifier: "ScreenCell") as? ScreenCell
        
        if cell == nil {
            tblView_screen.register(UINib(nibName: "ScreenCell", bundle: nil), forCellReuseIdentifier: "ScreenCell")
            cell = tblView_screen.dequeueReusableCell(withIdentifier: "ScreenCell") as? ScreenCell
            
        }
        cell.cellDelegate = self
        cell.btmOut.tag = indexPath.row
        let getString = dataScreenArr[indexPath.row] as! String
        if getString == "select"{
            
          cell.startAnimation(getStr: getString)
           // cell.indicationView.startAnimating()
         }
        cell.indicationView.tag = indexPath.row
        cell.textLabel?.text =  String(indexPath.row)
        return cell
        // set the text from the data model
//dataScreenArr[indexPath.row] as? String
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func btnIndex(send:String) {
        
        print("cell index")
        dataScreenArr[Int(send)!] = "select" as AnyObject
        
        print(dataScreenArr)
        DispatchQueue.main.async {
            self.tblView_screen.reloadData()
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
