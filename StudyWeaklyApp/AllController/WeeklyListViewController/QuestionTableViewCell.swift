//
//  QuestionTableViewCell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/27/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

protocol BtnDelegate:class {
    func answerSeleckMethod(getAnwr:String,btnTag:Int)
}
class QuestionTableViewCell: UITableViewCell {
     weak var btnDelegateCall:BtnDelegate?
    
    @IBOutlet weak var lbl_qtype: UILabel!
    
    @IBOutlet weak var lbl_points: UILabel!
    
    @IBOutlet weak var view_qType: UIView!
    
    
    @IBOutlet weak var btn_out: UIButton!
    
    @IBOutlet weak var btn_b: UIButton!
    
    @IBOutlet weak var btn_c: UIButton!
    
    @IBOutlet weak var btn_d: UIButton!
    
    @IBOutlet weak var lbl_question: UILabel!
    @IBOutlet weak var img_a: UIImageView!
    
    @IBOutlet weak var img_b: UIImageView!
    
    @IBOutlet weak var img_c: UIImageView!
    
    @IBOutlet weak var img_d: UIImageView!
    
    @IBOutlet weak var lbl_a: UILabel!
    
    @IBOutlet weak var lbl_b: UILabel!
    
    @IBOutlet weak var lbl_c: UILabel!
    
    @IBOutlet weak var lbl_d: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnAclick(_ sender: UIButton) {
        btnDelegateCall?.answerSeleckMethod(getAnwr: "a",btnTag: sender.tag)
    }
    
    @IBAction func btnBclicl(_ sender: UIButton) {
        btnDelegateCall?.answerSeleckMethod(getAnwr: "b",btnTag: sender.tag)
    }
    
    @IBAction func btnCclick(_ sender: UIButton) {
         btnDelegateCall?.answerSeleckMethod(getAnwr: "c",btnTag: sender.tag)
    }
    
    @IBAction func btnDclick(_ sender: UIButton) {
         btnDelegateCall?.answerSeleckMethod(getAnwr: "d",btnTag: sender.tag)
    }
    
}
