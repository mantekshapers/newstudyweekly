
//
//  ContentOptionViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/8/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class ContentOptionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var tblView: UITableView!
    let titleArr = ["Article Audio","Article Images","Related Media","Blackline Masters",]
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ContentOptionCell! = tblView.dequeueReusableCell(withIdentifier: "ContentOptionCell") as? ContentOptionCell
        if cell == nil {
            tblView.register(UINib(nibName: "ContentOptionCell", bundle: nil), forCellReuseIdentifier: "ContentOptionCell")
            cell = tblView.dequeueReusableCell(withIdentifier: "ContentOptionCell") as? ContentOptionCell
        }
       

        let getTitleStr = titleArr[indexPath.row]
        cell.lbl_title.text = getTitleStr
       cell.switch_out.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        // cell.lbl_weekly.text = "Week-" + getWeekly + " " + gettitle
        return cell
    }
    
    func switchValueDidChange(_ sender: UISwitch) {
        
        if sender.isOn {
            
        }else {
            
            
        }
        
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton)  {
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
