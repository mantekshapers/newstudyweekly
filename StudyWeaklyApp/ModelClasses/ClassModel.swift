//
//  ClassModel.swift
//  StudiesWeekly
//
//  Created by Man Singh on 12/11/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation

struct ClassModel {
    var grade:String?
    var id:String?
    var name:String?
    var role:String?
    var publication_ids:[String]?
    
    init(getClassDict:[String:AnyObject]) {
        self.grade = getClassDict["grade"] as? String
         self.id = getClassDict["id"] as? String
         self.name = getClassDict["name"] as? String
         self.role = getClassDict["role"] as? String
         self.publication_ids = [String]()
         self.publication_ids = getClassDict["publication_ids"] as? [String]
        
    }
   
    
 }




//grade = 1;
//id = 1189201;
//name = memcachetest;
//"publication_ids" =     (
//    1894,
//    4332,
//    6173,
//    6388,
//    6567,
//    8778,
//    12770,
//    47656,
//    127807,
//    127808,
//    127820,
//    127845,
//    127945,
//    127985,
//    137952,
//    156602
//);
//role = teacher;
//},
