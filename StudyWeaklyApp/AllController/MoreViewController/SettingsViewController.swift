//
//  SettingsViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/8/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
class SettingsViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var lbl_gb: UILabel!
    
    @IBOutlet weak var lbl_max: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        let spaceData = StorageSizeClass.getStorageSpace() as Double
        print("device space showing now..\(spaceData)")
      }
    @IBAction func storageSliderClick(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        print("Slider changing to \(currentValue) ?")
        lbl_max.text = "Max Size: \(currentValue) GB"
        
    }
    
    @IBAction func sBackBtnClick(_ sender: Any) {
     // self.slideMenuController()?.openLeft()
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let homeController = story.instantiateViewController(withIdentifier: "HomeFileViewController") as! HomeFileViewController
         let na = UINavigationController(rootViewController: homeController)
         self.slideMenuController()?.changeMainViewController(na, close: true)
       }
    
    @IBAction func contentBtnClick(_ sender: UIButton) {
        
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let contentOptionVC  =  story.instantiateViewController(withIdentifier: "ContentOptionVC") as! ContentOptionViewController
       //  let na = UINavigationController(rootViewController: contentOptionVC)
       self.navigationController?.pushViewController(contentOptionVC, animated: true)
        
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
