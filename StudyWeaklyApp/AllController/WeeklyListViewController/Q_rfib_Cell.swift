//
//  Q_rfib_Cell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import DropDown
protocol QrfibDelegate:class {
    func dropDownBtnClickSender(answr:String,indexTag:Int)
}
class Q_rfib_Cell: UITableViewCell {
    
    weak var qrfibDelegate:QrfibDelegate?
    @IBOutlet weak var btn_qrPlay: UIButton!
    
    @IBOutlet weak var lbl_qrTitle: UILabel!
    
    @IBOutlet weak var txtField_option: UITextField!
    
    @IBOutlet weak var btn_down: UIButton!
    var dataArr = [AnyObject]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        
        // The view to which the drop down will appear on
       
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
       }
    func optionMethod(arr:[AnyObject]) {
          let dropDown = DropDown()
        dropDown.anchorView = btn_down // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        dropDown.direction = .any
        dataArr = arr
       }
    
    @IBAction func dropDownBtnClick(_ sender: UIButton) {
       //  let getDataStr  = dataArr[sender.tag] as? String
         qrfibDelegate?.dropDownBtnClickSender(answr: "hello", indexTag: sender.tag)
        }
    
}
