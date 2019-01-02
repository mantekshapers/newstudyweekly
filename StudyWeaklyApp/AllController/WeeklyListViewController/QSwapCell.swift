//
//  QSwapCell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 11/29/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class QSwapCell: UITableViewCell {
    
    @IBOutlet weak var btn_q_swapPlay: UIButton!
    
    @IBOutlet weak var lbl_q_swapTitle: UILabel!
    
    @IBOutlet weak var btn_edit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
