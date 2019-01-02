//
//  DateModel.swift
//  StudiesWeekly
//
//  Created by Man Singh on 12/21/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation
struct DateModel {
    var currentDate:Date?
    var formatter:DateFormatter?
    init() {
        currentDate = Date()
        formatter = DateFormatter()
    }
    
    func getCurrentDate(getStoreDate:String) -> String {
        
        formatter?.timeStyle = .none
        formatter?.dateStyle = .long
        
        let curent = formatter?.string(from: currentDate!)
        let otherDateName = getYesterDate()
        if curent == getStoreDate {
            return "Today"
        }else if otherDateName == getStoreDate{
             return "Yesterday"
        }
        return getStoreDate
      }
    
    func getYesterDate() -> String {
        
       // let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate!)
        formatter?.timeStyle = .none
        formatter?.dateStyle = .long
        let yesterday1 = formatter?.string(from: yesterday!)
        
        return yesterday1!
    }
    
    func getOtherDate()->String{
        return "Other"
        
    }
    
    func saveCurrentDate()->String{
        formatter?.timeStyle = .none
        formatter?.dateStyle = .long
        let savecurrent = formatter?.string(from: currentDate!)
        return savecurrent!
        
        
    }
    
    
      
}
