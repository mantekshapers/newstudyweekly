//
//  StorageClass.swift
//  StudiesWeekly
//
//  Created by Man Singh on 9/24/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation

class StorageClass{
    
    static func setUnitsId(getId:String){
      //  UserDefaults.setValue(getId, forKey: UserDefaultsKey.unitsID.rawValue)
        UserDefaults.standard.setValue(getId, forKey: UserDefaultsKey.unitsID.rawValue)
       }
    
    static func getUnitsId()->String{
        //UserDefaults.setValue(getId, forKey: UserDefaultsKey.unitsID.rawValue)
    let getValues  =  UserDefaults.standard.value(forKey: UserDefaultsKey.unitsID.rawValue) as? String ?? "0"
        return getValues
      }
    
    static func setArticleId(getId:String){
        //  UserDefaults.setValue(getId, forKey: UserDefaultsKey.unitsID.rawValue)
        UserDefaults.standard.setValue(getId, forKey: UserDefaultsKey.articleID.rawValue)
    }
    static func getArticleId()->String{
        //UserDefaults.setValue(getId, forKey: UserDefaultsKey.unitsID.rawValue)
       // UserDefaults.standard.setValue(setBool, forKey: UserDefaultsKey.articleID.rawValue)
        let getValues  =  UserDefaults.standard.value(forKey: UserDefaultsKey.articleID.rawValue) as? String ?? "0"
        return getValues
        
      }
    
    static func setWifi(setBool: Bool){
        //UserDefaults.setValue(getId, forKey: UserDefaultsKey.unitsID.rawValue)
         UserDefaults.standard.setValue(setBool, forKey: UserDefaultsKey.wifiKey.rawValue)

    }
    static func getWifi()->Bool{
        //UserDefaults.setValue(getId, forKey: UserDefaultsKey.unitsID.rawValue)
        let getValues  =  UserDefaults.standard.value(forKey: UserDefaultsKey.wifiKey.rawValue) as? Bool ?? false
        return getValues
    }
    
      static func removeDataFromUserDefault(setKey: String){
        UserDefaults.standard.removeObject(forKey: setKey)
      }
    
    static func saveNotificationOnUserDefault(setValue:String){
         UserDefaults.standard.setValue(setValue, forKey: UserDefaultsKey.notificationKey.rawValue)
    }
    
    static func getNotificationOnOff()->String{
        //UserDefaults.setValue(getId, forKey: UserDefaultsKey.unitsID.rawValue)
        let getValues  =  UserDefaults.standard.value(forKey: UserDefaultsKey.notificationKey.rawValue) as? String ?? ""
        return getValues
    }
}

