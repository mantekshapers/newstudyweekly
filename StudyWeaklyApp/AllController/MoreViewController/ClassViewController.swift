//
//  ClassViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 12/11/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class ClassViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tblView: UITableView!
    var dataClassArr = [ClassModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        let userId = NetworkAPI.userID()
       // /online/api/v2/app/classroom
        let postClassDict = ["userId":userId]
        CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.classRoom, postString:[:] , httpMethodName: "GET") { (respose, boolTrue) in
            if boolTrue == false{
                // let getDict = respose as! [String:AnyObject]
                //                        DispatchQueue.main.async {
                //                            self.customAlertController.showCustomAlert3(getMesage: getDict["responseError"] as! String, getView: self)
                //                            appdelegate?.hideLoader()
                //                        }
                DispatchQueue.main.async {
                
                }
                return
            }
          
            let arrayData = respose as! [AnyObject]
            if arrayData.count>0{
                self.dataClassArr.removeAll()
                for data in arrayData {
                    let dataClassModel = ClassModel(getClassDict: data as! [String : AnyObject])
                    self.dataClassArr.append(dataClassModel)
                    print("name==\(dataClassModel.name)")
                     print("publication_ids==\(dataClassModel.publication_ids)")
                }
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
                
            }
        }
    
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(dataClassArr.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ClassCell! = tblView.dequeueReusableCell(withIdentifier: "ClassCell") as? ClassCell
        if cell == nil {
            tblView.register(UINib(nibName: "ClassCell", bundle: nil), forCellReuseIdentifier: "ClassCell")
            cell = tblView.dequeueReusableCell(withIdentifier: "ClassCell") as? ClassCell
          }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select")
        
    }
    
    
    @IBAction func backBtnClick(_ sender: UIButton) {
          self.slideMenuController()?.openLeft()
//        let story = UIStoryboard.init(name: "Main", bundle: nil)
//        let homeController = story.instantiateViewController(withIdentifier: "HomeFileViewController") as! HomeFileViewController
//        let na = UINavigationController(rootViewController: homeController)
//        self.slideMenuController()?.changeMainViewController(na, close: true)
        
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
