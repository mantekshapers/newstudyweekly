//
//  CustomBGBorderBtn.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/12/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class CustomBGBorderBtn: UIButton {
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        // createBorder()
      }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       }
    
   class  func btnBgColor()->UIColor{
//        self.layer.cornerRadius = 5.0
//        self.layer.borderColor = UIColor.red.cgColor
//        self.layer.borderWidth = 1.5
//        self.backgroundColor = UIColor.red
//        self.tintColor = UIColor.white
        return UIColor.init(red: 0/255, green: 157/255, blue: 220/255, alpha: 1.0)
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
