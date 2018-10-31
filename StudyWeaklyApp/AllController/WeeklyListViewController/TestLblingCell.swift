//
//  TestLblingCell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/9/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
//protocol TestDelegate:class {
//    func answerSeleckMethod(getAnwr:String,btnTag:Int)
//}
class TestLblingCell: UITableViewCell {
    
    @IBOutlet weak var lbl_question: UILabel!
    
    @IBOutlet weak var btn_play: UIButton!
    
   
    @IBOutlet weak var img_imgView: UIImageView!
    
    @IBOutlet weak var lbl_drag: UILabel!
    
    @IBOutlet weak var lbl_drag1: UILabel!
    
    @IBOutlet weak var lbl_dragPositionConst: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
