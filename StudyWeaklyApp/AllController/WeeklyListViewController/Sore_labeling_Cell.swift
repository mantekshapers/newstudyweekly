//
//  Sore_labeling_Cell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/11/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class Sore_labeling_Cell: UITableViewCell {
    

    @IBOutlet weak var lbl_lblTitle: UILabel!
    
    
    @IBOutlet weak var img_labeling: UIImageView!
    
    @IBOutlet weak var lbl_ans: UILabel!
    
    @IBOutlet weak var lbl_corect_inco: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
