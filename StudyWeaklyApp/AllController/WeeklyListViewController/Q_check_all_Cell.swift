//
//  Q_check_all_Cell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

protocol CheckAllDelegate:class {
    func answerSeleckAllMethod(getAnwr:String,btnTag:Int)
}
class Q_check_all_Cell: UITableViewCell {
    
    weak var checkAllDelegate:CheckAllDelegate?
    @IBOutlet weak var lbl_checkTitle: UILabel!
    @IBOutlet weak var btn_playCheck: UIButton!
    
    @IBOutlet weak var btn_a: UIButton!
    
    @IBOutlet weak var btn_b: UIButton!
    
    @IBOutlet weak var btn_c: UIButton!
    
    @IBOutlet weak var btn_d: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnAclick(_ sender: UIButton) {
        checkAllDelegate?.answerSeleckAllMethod(getAnwr: "a", btnTag: sender.tag)
    }
    
    @IBAction func btnBclick(_ sender: UIButton) {
         checkAllDelegate?.answerSeleckAllMethod(getAnwr: "b", btnTag: sender.tag)
    }
    
    @IBAction func btnCclick(_ sender: UIButton) {
        checkAllDelegate?.answerSeleckAllMethod(getAnwr: "c", btnTag: sender.tag)
    }
    
    @IBAction func btnDclick(_ sender: UIButton) {
        checkAllDelegate?.answerSeleckAllMethod(getAnwr: "d", btnTag: sender.tag)
    }
    
}
