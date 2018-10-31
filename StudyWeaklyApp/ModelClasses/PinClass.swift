//
//  PinClass.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/4/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

protocol PinItDelegateClass:class {
    func pinItMethodCall(getIndex: Int)
    func removeMethodCall(getIndex: Int)
    func cancelMethodCall()
}
class PinClass: UIView {
    
    weak var pinInDelegateClass:PinItDelegateClass?
    @IBOutlet weak var btn_pinIt: UIButton!
    
    @IBOutlet weak var btn_remove: UIButton!
    
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

    @IBAction func btnPinClick(_ sender: UIButton) {
        self.pinInDelegateClass?.pinItMethodCall(getIndex: sender.tag)
     }
    
    @IBAction func btnRemoveClick(_ sender: UIButton) {
        self.pinInDelegateClass?.removeMethodCall(getIndex: sender.tag)
    }
    
    @IBAction func btnCancelClick(_ sender: UIButton) {
        self.pinInDelegateClass?.cancelMethodCall()
    }
}
