//
//  Q_true_false_Cell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

protocol QTrueFalseDelegate:class {
    func answerTrueFalseMethod(answr:String,indexTag: Int)
}
class Q_true_false_Cell: UITableViewCell {
    
    weak var qTrueFalseDelegate:QTrueFalseDelegate?
    @IBOutlet weak var btn_play: UIButton!
    
    @IBOutlet weak var lbl_qTitle: UILabel!
    
    @IBOutlet weak var btn_yes: UIButton!
    
    @IBOutlet weak var btn_no: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
     }
    
    
    @IBAction func yesBtnClick(_ sender: UIButton) {
        qTrueFalseDelegate?.answerTrueFalseMethod(answr: "Yes", indexTag: sender.tag)
       }
    
    @IBAction func noBtnClick(_ sender: UIButton) {
  qTrueFalseDelegate?.answerTrueFalseMethod(answr: "No", indexTag: sender.tag)
        
    }
    
}
