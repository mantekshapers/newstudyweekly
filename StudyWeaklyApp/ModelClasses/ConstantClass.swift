//
//  ConstantClass.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/12/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation
import UIKit
struct BASEURL {
    static let MerchantID = "XXX"
    static let MerchantUsername = "XXXXX"
    static let ImageBaseURL = "XXXXXXX"
    static let baseURL = "https://app.studiesweekly.com/online/api/v2/app/login"
}
 struct BaseUrlOther {
    static let baseURLOther = "https://app.studiesweekly.com/online/api/v2/app/"
 }
 struct CustomBGColor {
     static let navBGColor =  UIColor.init(red: 0.0/255.0, green: 157.0/255, blue: 220.0/255.0, alpha: 1.0)
     static let profileBGColor =  UIColor.init(red: 0.0/255.0, green: 75.0/255, blue: 117.0/255.0, alpha: 1.0)
    static let GreenCellBGColor =  UIColor.init(red: 196.0/255.0, green: 228.0/255, blue: 205.0/255.0, alpha: 1.0)
    // static let qHeaderCellBGColor =  UIColor.init(red: 34.0/255.0, green: 117.0/255, blue: 53.0/255.0, alpha: 1.0)
      static let qHeaderCellBGColor =  UIColor.init(red: 43.0/255.0, green: 193.0/255, blue: 69.0/255.0, alpha: 1.0)
    static let questionBGColor = UIColor.init(red: 212.0/255.0, green: 212.0/255, blue: 212.0/255.0, alpha: 1.0)
    static let grayCellBGColor =  UIColor.init(red: 212.0/255.0, green: 212.0/255, blue: 212/255.0, alpha: 1.0)
    static let orangeCellBGColor =  "#fdb813"
    static let selectBGColor =  UIColor.red
    static let clearBGColor =  UIColor.clear
   
    //static let txtFieldBGColor = 
}

struct AlertTitle {
    static let loginTextStr = "Please fill user text"
    static let passwordTextStr = "Please fill password text"
    static let networkStr = "Please chech your network"
 }

  public enum UserDefaultsKey: String {
    case userID = "sw.userID"
    case isTeacher = "sw.isTeacher"
    case unitsID = "unitsID"
     case articleID = "article_id"
 }





