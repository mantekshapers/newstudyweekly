//
//  TabViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 12/24/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class TabViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addNewTabBtnClick(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    @IBAction func tabBtnClick(_ sender: UIButton) {
        
         }
    
    @IBAction func historyBtnClick(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let screenViewController = story.instantiateViewController(withIdentifier: "ScreenViewController") as! ScreenViewController
        self.navigationController?.pushViewController(screenViewController, animated: false)
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
