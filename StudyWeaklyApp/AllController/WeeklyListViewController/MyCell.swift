//
//  MyCell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 11/2/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import DropDown
class MyCell: DropDownCell {
    @IBOutlet weak var lbl_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
