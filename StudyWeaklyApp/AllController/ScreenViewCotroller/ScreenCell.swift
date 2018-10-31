//
//  ScreenCell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/16/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
protocol ScreenCellDelegate: class {
    func btnIndex(send:String)
}
 class ScreenCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var indicationView: UIActivityIndicatorView!
    
    @IBOutlet weak var btmOut: UIButton!
   weak var cellDelegate:ScreenCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func startAnimation(getStr:String){
        
        if getStr == "select"{
            indicationView.startAnimating()
         }else {
            indicationView.stopAnimating()
            
        }
    }
    
    @IBAction func indexBtnClick(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            indicationView.stopAnimating()
        }else{
             sender.isSelected = true
            indicationView.startAnimating()
        }
         print("cell click",String(sender.tag))
        cellDelegate?.btnIndex(send: String(sender.tag))
       // self.indexBtnClick(String(sender.tag))
       
        
    }
    
    
}
