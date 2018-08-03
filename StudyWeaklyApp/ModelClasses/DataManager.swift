//
//  DataManager.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/2/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation

class DataManager {
// MARK: User

class func getUser(withID id: String, password: String, callback: @escaping UserCallback) {
    UserDAO.downloadUser(withID: id, password: password, callback: callback)
}

//class func saveUser(_ user: User) {
//    UserDAO.write([user], using: try! Realm())
//}
//
//class func updateUserPassword(for userID: String, password: String, callback: @escaping (Bool, String?) -> ()) {
//    let args = UpdateUserPasswordArgs(password: password, userID: userID)
//    NetworkAPI.updateUserPassword(args).enqueue { (response) in
//        callback(response.body?.success?.boolValue ?? false, response.body?.error)
//    }
//}
//
//class func updateUsername(for userID: String, username: String, callback: @escaping (Bool, String?) -> ()) {
//    let args = UpdateUsernameArgs(username: username, userID: userID, updated: Date().iso8601)
//    NetworkAPI.updateUsername(args).enqueue { (response) in
//        callback(response.body?.success?.boolValue ?? false, response.body?.error)
//    }
//}
}
