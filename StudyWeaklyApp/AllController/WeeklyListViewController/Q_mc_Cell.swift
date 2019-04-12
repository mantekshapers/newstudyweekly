//
//  Q_mc_Cell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/9/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

protocol TestDelegate:class {
    func answerSeleckMethod(getAnwr:String,btnTag:Int)
}
class Q_mc_Cell: UITableViewCell {
  weak var testDelegateCall:TestDelegate?
    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var lbl_qTitle: UILabel!
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
    
    @IBAction func btnAClick(_ sender: UIButton) {
        self.testDelegateCall?.answerSeleckMethod(getAnwr:"a",btnTag:sender.tag)
    }
    
    @IBAction func btnBClick(_ sender: UIButton) {
        self.testDelegateCall?.answerSeleckMethod(getAnwr:"b",btnTag:sender.tag)
    }
    
    @IBAction func btnCClick(_ sender: UIButton) {
        self.testDelegateCall?.answerSeleckMethod(getAnwr:"c",btnTag:sender.tag)
    }
    
    @IBAction func btnDClick(_ sender: UIButton) {
        self.testDelegateCall?.answerSeleckMethod(getAnwr:"d",btnTag:sender.tag)
    }
    
    
}
