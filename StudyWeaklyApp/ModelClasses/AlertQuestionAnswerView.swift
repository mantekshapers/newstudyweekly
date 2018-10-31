//
//  AlertQuestionAnswerView.swift
//  StudiesWeekly
//
//  Created by Man Singh on 9/21/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

protocol AlertQuestionDelegate:class {
    func oKayAlertBtnClick()
    func cancelAlertBtnClick()
}
class AlertQuestionAnswerView: UIView {
     weak var alertQuestionDelegate:AlertQuestionDelegate?
    
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_showPoints: UILabel!
    
    @IBOutlet weak var img_question: UIImageView!
    
    
    
    @IBOutlet weak var btn_okay: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func oKayBtnClick(_ sender: UIButton) {
         alertQuestionDelegate?.oKayAlertBtnClick()
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        alertQuestionDelegate?.cancelAlertBtnClick()
    }
    

}
