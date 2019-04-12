//
//  UserDAO.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/2/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation
import Retrolux
import RealmSwift
class UserDAO {
class func downloadUser(withID id: String, password: String, callback: @escaping UserCallback) {
    NetworkAPI.getUser(Query(id)).enqueue { (response) in
        if response.isSuccessful, let user = response.body?.success {
            user.password = password
           // write([user], using: try! Realm())
            callback(user, nil)
        } else {
//            Flurry.logEvent("Error getting user info", withParameters: ["Retrolux Error": response.error ?? "", "Server Data": response.dataString ?? ""])
//            debug("Unable to get user info", tag: "ERROR")
            callback(nil, response.error)
        }
    }
}
}
