//
//  NotificationClass.swift
//  StudiesWeekly
//
//  Created by Man Singh on 1/15/19.
//  Copyright © 2019 TekShapers. All rights reserved.
//

import Foundation
import UIKit
class NotificationClass{
    static let notification = NotificationClass()
       private init(){
        
       }
    
    func notificationOnMethod(){
        
        StorageClass.saveNotificationOnUserDefault(setValue: "on")
    let app = UIApplication.shared.delegate as! AppDelegate
        
       app.notificationActiveMethod()
         
        
        
      }
    
    
    func notificationOffMethod(){
        
        StorageClass.saveNotificationOnUserDefault(setValue: "off")
        let app = UIApplication.shared.delegate as! AppDelegate
        
       app.notificationDeactiveMethod()
        
        
        
        
     }
    
}
