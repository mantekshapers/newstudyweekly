//
//  BonusPointCell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/29/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

protocol DownloadBtnDelegate: class {
    
    func downloadedCellBtnClick(indexCell:UIButton)
}
class BonusPointCell: UITableViewCell {
    
    
    weak var downloadBtnDelegate:DownloadBtnDelegate?
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_cellNo: UILabel!
    
    @IBOutlet weak var img_circle: UIImageView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var img_download: UIImageView!
    
    @IBOutlet weak var btn_download: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func downloadBtnClick(_ sender: UIButton) {
        downloadBtnDelegate?.downloadedCellBtnClick(indexCell: sender)
    }
    
    
    
}
