//
//  SearchViewController.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var lbl_allbtn: UILabel!
    @IBOutlet weak var lbl_articleBtn: UILabel!
    
    @IBOutlet weak var llbl_mediaBtn: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnsClick(_ sender: UIButton) {
         lbl_allbtn.backgroundColor = UIColor.clear
        lbl_articleBtn.backgroundColor = UIColor.clear
        llbl_mediaBtn.backgroundColor = UIColor.clear
        let btnTag = sender.tag as Int
        if btnTag == 0 {
             lbl_allbtn.backgroundColor = UIColor.red
        }else if btnTag == 1 {
             lbl_articleBtn.backgroundColor = UIColor.red
        }else {
             llbl_mediaBtn.backgroundColor = UIColor.red
         }
        
        
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
