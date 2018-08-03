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

 struct CustomBGColor {
     static let navBGColor =  UIColor.init(red: 0.0/255.0, green: 157.0/255, blue: 220.0/255.0, alpha: 1.0)
     static let profileBGColor =  UIColor.init(red: 0.0/255.0, green: 75.0/255, blue: 117.0/255.0, alpha: 1.0)
   
    //static let txtFieldBGColor = 
}

struct AlertTitle {
    static let loginTextStr = "Please fill user text"
    static let passwordTextStr = "Please fill password text"
 }

  public enum UserDefaultsKey: String {
    case userID = "sw.userID"
    case isTeacher = "sw.isTeacher"
 }




