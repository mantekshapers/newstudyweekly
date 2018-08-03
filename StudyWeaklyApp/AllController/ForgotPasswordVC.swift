//
//  ForgotPasswordVC.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/13/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
class ForgotPasswordVC: UIViewController {
    @IBOutlet weak var recoverBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        recoverBtn.backgroundColor = CustomBGBorderBtn.btnBgColor()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgotPassBtnClick(_ sender: Any) {
        
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
