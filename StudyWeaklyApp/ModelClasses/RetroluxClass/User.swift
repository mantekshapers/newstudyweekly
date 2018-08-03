//
//  User.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/2/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation
import Retrolux
import RealmSwift
class User: Reflection {
    enum UserRole: String {
        case teacher = "teacher"
        case student = "student"
        
        func isTeacher() -> Bool {
            return self == .teacher
         }
    }
    var password_hash: String = ""
    var student_password: String? = ""
    var email: String? = ""
    var updated: String? = ""
    var name: String? = ""
    var points: String? = ""
    var role: String? = ""
    var state: String? = ""
    var user_id: String = ""
    var username: String = ""
    var password: String = ""
   // var redeemed_points: RedeemedPoints = RedeemedPoints()
    var navigation_id: String = ""
    var is_synced: Bool = true
    
    var publicationIDs: [String] = []
    
//    override class func config(_ c: PropertyConfig) {
//        c["password"] = [.ignored]
//        c["articles_read"] = [.ignored]
//        c["is_synced"] = [.ignored]
//        c["publicationIDs"] = [.serializedName("publication_ids")]
//        c["navigation_id"] = [.ignored]
//    }
//
    var userRole: UserRole {
        return UserRole(rawValue: role ?? "") ?? .student
    }
    
    func isTeacher() -> Bool {
        return userRole.isTeacher()
}
}
