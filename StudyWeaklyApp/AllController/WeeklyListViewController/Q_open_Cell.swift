//
//  Q_open_Cell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

//protocol QopenDelegate:class{
//    func openPlayBtnClick()
//    }
//}
 class Q_open_Cell: UITableViewCell {
    
    @IBOutlet weak var btn_playOpen: UIButton!
    
    @IBOutlet weak var lbl_openQ: UILabel!
    
    @IBOutlet weak var txtField_open: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
     }
    
    
    
    
    
}
