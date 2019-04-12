//
//  ContentOptionCell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/8/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class ContentOptionCell: UITableViewCell
{
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var switch_out: UISwitch!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
