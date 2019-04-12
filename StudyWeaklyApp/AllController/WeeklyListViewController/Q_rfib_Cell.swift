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
    
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var txtField_option: UITextField!
    
    @IBOutlet weak var btn_down: UIButton!
    var dataArr = [AnyObject]()
       var dropDown1 = DropDown()

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
       // dropDown.anchorView = txtField_option // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
       // dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
       // dropDown.direction = .any
       // dataArr = arr
        
           }
    
    func dropDownMethod(dropDown:DropDown) {
        dropDown1 = dropDown
        // dropDown.anchorView = txtField_option // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        // dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        // dropDown.direction = .any
        // dataArr = arr
          }
    
    @IBAction func dropDownBtnClick(_ sender: UIButton) {
       //  let getDataStr  = dataArr[sender.tag] as? String
          dropDown1.anchorView = sender
          dropDown1.dataSource = ["Car", "Motorcycle", "Truck"]
          dropDown1.show()
          qrfibDelegate?.dropDownBtnClickSender(answr: "hello", indexTag: sender.tag)
        
        }
    
}
