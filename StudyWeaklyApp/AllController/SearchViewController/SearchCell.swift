//
//  SearchCell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/16/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var lbl_searchTitle: UILabel!
    
    @IBOutlet weak var imgView_search: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
