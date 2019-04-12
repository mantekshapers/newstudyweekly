//
//  WeeklyUnitListCell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/22/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
class WeeklyUnitListCell: UITableViewCell
{
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewColor: UIView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
         imgView.layer.cornerRadius = imgView.frame.size.width/2
         imgView.clipsToBounds = true
      }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
     }
}
