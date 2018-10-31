//
//  CoreDBManager.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/8/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class CDBManager {
      static let sharedInstance = CDBManager()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    func getDataFromDB()->[AnyObject] {
       var dataArr = [AnyObject]()
       let managedContext = appDelegate?.persistentContainer.viewContext
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "USER")
        userFetch.returnsObjectsAsFaults = false
        do {
            let result = try managedContext?.fetch(userFetch)
            for data in result as! [NSManagedObject] {
                var dataSetDict = [String:AnyObject]()
                dataSetDict["name"] = data.value(forKey: "userName") as AnyObject
                dataSetDict["userId"] = data.value(forKey: "userId") as AnyObject
                 dataSetDict["userPassword"] = data.value(forKey: "userPassword") as AnyObject
                dataSetDict["points"] = data.value(forKey: "userPoints") as AnyObject
                dataArr.append(dataSetDict as AnyObject)
              }
         } catch {
            print("Failed")
           }
        return dataArr
     }
     // here is get publication from core database
    
    func getpublicationFromDB()->[AnyObject] {
         let getUserId    = NetworkAPI.userID()
        var dataArr = [AnyObject]()
        let managedContext = appDelegate?.persistentContainer.viewContext
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Publications")
        
        userFetch.returnsObjectsAsFaults = false
        do {
            let result = try managedContext?.fetch(userFetch)
            
            print("fethc publication==\(result)")
            for data in result as! [NSManagedObject] {
                
               let userTmp = data.value(forKey: "userId") as? String
                if getUserId == userTmp {
                
                var dataSetDict = [String:AnyObject]()
                //publicationObject.setValue(getUserId, forKey: "userId")
                //publicationObject.setValue("notDownload", forKey: "publication_download")
                dataSetDict["userId"] = data.value(forKey: "userId") as AnyObject
                dataSetDict["publication_download"] = data.value(forKey: "publication_download") as AnyObject
                dataSetDict["publication_id"] = data.value(forKey: "publication_id") as AnyObject
                dataSetDict["sku"] = data.value(forKey: "sku") as AnyObject
                dataSetDict["cover_url"] = data.value(forKey: "cover_url") as AnyObject
                dataSetDict["title"] = data.value(forKey: "title") as AnyObject
                dataSetDict["units"] = data.value(forKey: "unitsOfArray") as AnyObject
                dataArr.append(dataSetDict as AnyObject)
                }
             }
        } catch {
            print("Failed")
        }
        return dataArr
        
        
        /*
        do {
            let result = try managedContext?.fetch(publicationsDownFetch)
            if (result?.count)!>0{
                
                for data in result as! [NSManagedObject] {
                    let UserId = data.value(forKey: "userId") as? String
                    let getPubId = data.value(forKey: "publication_id") as? String
                    if getUserId == UserId && publicationId == getPubId {
                        // data.setValue("karan", forKey: "userId")
                        publicationObject.setValue(publicationId, forKeyPath: "publication_id")
                        // publicationObject.setValue(bodyStr, forKey: "body")
                        publicationObject.setValue(getUserId, forKey: "userId")
                        publicationObject.setValue("downloaded", forKey: "publication_download")
                        publicationObject.setValue(skuStr, forKey: "sku")
                        publicationObject.setValue(coverUrl1, forKey: "cover_url")
                        publicationObject.setValue(titleStr, forKey: "title")
                        publicationObject.setValue(unitsArr, forKey: "unitsOfArray")
                        
                    }else {
                        publicationObject.setValue(publicationId, forKeyPath: "publication_id")
                        // publicationObject.setValue(bodyStr, forKey: "body")
                        publicationObject.setValue(getUserId, forKey: "userId")
                        publicationObject.setValue("notDownload", forKey: "publication_download")
                        publicationObject.setValue(skuStr, forKey: "sku")
                        publicationObject.setValue(coverUrl1, forKey: "cover_url")
                        publicationObject.setValue(titleStr, forKey: "title")
                        publicationObject.setValue(unitsArr, forKey: "unitsOfArray")
                        */
                        
    }
    
    
    func updatePublicationFromDB(publicationId: String){
        let managedContext = appDelegate?.persistentContainer.viewContext
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Publications")
        
        userFetch.returnsObjectsAsFaults = false
        do {
            let result = try managedContext?.fetch(userFetch)
            print("fethc publication==\(result)")
            for data in result as! [NSManagedObject] {
                let publicationTmp = data.value(forKey: "publication_id") as? String
                if publicationId == publicationTmp {
                    data.setValue("notDownload", forKey: "publication_download")
                   }
            }
        } catch {
            print("Failed")
        }
        
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func addCDBData(object: [String:Any]) {
       //  deleteAllCDB()
        let getDict = object["success"] as? [String: Any]
        let getName = getDict!["name"] as? String
       // let userName = object["username"] as? String
        let userId = getDict!["user_id"] as? String
        let userPassword = getDict!["student_password"] as? String
        let userPonits = getDict!["points"] as? String
        let managedContext = appDelegate?.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "USER", in: managedContext!)!
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        let getUserFromDB = updateCDBData(userId:userId!)
        if getUserFromDB != "user exit in db" { //user exit in db
         user.setValue(userId, forKeyPath: "userId")
         user.setValue(getName, forKey: "userName")
         user.setValue(userPassword, forKey: "userPassword")
         user.setValue(userPonits, forKey: "userPoints")
            do {
                try managedContext?.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }else{
            print("already save. in db")
            
        }
        
    }
    
    
    // here is add unit data in core database
    func addUnitsCDBData(publicationIdStr:String,object: [AnyObject]) {
        
         let getUserId    = NetworkAPI.userID()
        let managedContext = appDelegate?.persistentContainer.viewContext
         let unitsEntity = NSEntityDescription.entity(forEntityName: "Units", in: managedContext!)!
         let unitsData = NSManagedObject(entity: unitsEntity, insertInto: managedContext)
            unitsData.setValue(publicationIdStr, forKeyPath: "publication_id")
           unitsData.setValue(object, forKey: "units")
        
        let publicationDownload1 = NSEntityDescription.entity(forEntityName: "PublicationDownload", in: managedContext!)!
        let publicationDownloadObject = NSManagedObject(entity: publicationDownload1, insertInto: managedContext)
        publicationDownloadObject.setValue(publicationIdStr, forKeyPath: "publication_id")
        publicationDownloadObject.setValue(getUserId, forKey: "userId")
        publicationDownloadObject.setValue("downloaded", forKey: "publication_download")
            do {
                try managedContext?.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
              }
       }
    
    
    
    
    
    func getUnitsDataFromUnitsTable(searchUnits:String)->[AnyObject]{
        var unitArr = [AnyObject]()
        let managedContext = appDelegate?.persistentContainer.viewContext
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Units")
        userFetch.returnsObjectsAsFaults = false
        do {
            let result = try managedContext?.fetch(userFetch)
            for data in result as! [NSManagedObject] {
                if data.value(forKey: "publication_id") as! String == searchUnits {
                var dataSetDict = [String:AnyObject]()
                dataSetDict["publication_id"] = data.value(forKey: "publication_id") as AnyObject
                dataSetDict["units"] = data.value(forKey: "units") as AnyObject
                unitArr.append(dataSetDict as AnyObject)
        //       print("\(data.value(forKey: "units") as AnyObject)")
               }
           }
        } catch {
            print("Failed")
        }
        return unitArr
    }
    
    func unitsDeleteFromDB(){
        
        let context = appDelegate?.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Units")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context?.execute(deleteRequest)
            try context?.save()
        } catch {
            print ("There was an error")
        }
        
    }
    
    func addPublicationCDBData(object: [String:Any]){
        
        let getUserId    = NetworkAPI.userID()
         let managedContext = appDelegate?.persistentContainer.viewContext
        let publicationArr = object["success"] as? [AnyObject]
        
        if publicationArr?.count == 0{
            return
          }
        var fetchPubArrData = [AnyObject]()
         let publicationEntity = NSEntityDescription.entity(forEntityName: "Publications", in: (managedContext)!)!
        
//        let publicationsDownFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PublicationDownload")
//         publicationsDownFetch.returnsObjectsAsFaults = false
//        print("unita data()()() print==//\(publicationArr)")
        
        let downloadTbleArr = getDownloadPublicFromDB() as [AnyObject]
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Publications")
        userFetch.returnsObjectsAsFaults = false
        do {
            let result = try managedContext?.fetch(userFetch)
            
            print("fethc publication==\(result)")
            for data in result as! [NSManagedObject] {
                let userTmp = data.value(forKey: "userId") as? String
                if getUserId == userTmp {
                    fetchPubArrData.append(data)
                }
            }
        } catch {
            print("Failed")
        }
        
        for i in 0..<publicationArr!.count {
             let publicationObject = NSManagedObject(entity: publicationEntity, insertInto: managedContext)
            let getDict = publicationArr?[i] as? [String:Any]
            
            let coverUrl =  getDict!["cover_url"] as? String ?? ""
            let coverUrl1     =  "https:" + coverUrl
            let publicationId = getDict!["publication_id"] as? String
            // let userName = object["username"] as? String
            let bodyStr = getDict!["body"] as? String
            let skuStr = getDict!["sku"] as? String
            //let coverData = getDict!["cover_url"] as? String
            let titleStr = getDict!["title"] as? String
            let unitsArr = getDict!["units"] as! [AnyObject]
            
            print("unita data print==//\(unitsArr)")
           
//            for data in result as! [NSManagedObject] {
//                let UserId = data.value(forKey: "userId") as? String
//                let getPubId = data.value(forKey: "publication_id") as? String
        if fetchPubArrData.count == 0{
            publicationObject.setValue(publicationId, forKeyPath: "publication_id")
            // publicationObject.setValue(bodyStr, forKey: "body")
            publicationObject.setValue(getUserId, forKey: "userId")
            publicationObject.setValue("notDownload", forKey: "publication_download")
            publicationObject.setValue(skuStr, forKey: "sku")
            publicationObject.setValue(coverUrl1, forKey: "cover_url")
            publicationObject.setValue(titleStr, forKey: "title")
            publicationObject.setValue(unitsArr, forKey: "unitsOfArray")
            do {
                try managedContext?.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }else{
            
           // print("updatePublication==\(fetchPubArrData)")
            for data in fetchPubArrData as! [NSManagedObject] {
                  let UserId = data.value(forKey: "userId") as? String
                 let getPubId = data.value(forKey: "publication_id") as? String
                 let publiDown = data.value(forKey: "publication_download") as? String
                if getUserId == UserId && publicationId == getPubId{
                    
                    data.setValue(publicationId, forKeyPath: "publication_id")
                    // publicationObject.setValue(bodyStr, forKey: "body")
                    data.setValue(getUserId, forKey: "userId")
                    data.setValue(publiDown, forKey: "publication_download")
                    data.setValue(skuStr, forKey: "sku")
                    data.setValue(coverUrl1, forKey: "cover_url")
                    data.setValue(titleStr, forKey: "title")
                    data.setValue(unitsArr, forKey: "unitsOfArray")
                    
                    for dict in downloadTbleArr {
                        
                       let getDownPubId = dict.value(forKey: "publication_id") as? String ?? ""
                         let getDownUserId = dict.value(forKey: "userId") as? String ?? ""
                         let getDown = dict.value(forKey: "publication_download") as? String ?? ""
                        if getPubId == getDownPubId && UserId == getDownUserId {
                          data.setValue(publicationId, forKeyPath: "publication_id")
                    // publicationObject.setValue(bodyStr, forKey: "body")
                         data.setValue(getUserId, forKey: "userId")
                         data.setValue(getDown, forKey: "publication_download")
                         data.setValue(skuStr, forKey: "sku")
                         data.setValue(coverUrl1, forKey: "cover_url")
                         data.setValue(titleStr, forKey: "title")
                         data.setValue(unitsArr, forKey: "unitsOfArray")
                        }
                    }
                }
            }
           }
        }
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    

    func getDownloadPublicFromDB()->[AnyObject]{
        
        let getUserId    = NetworkAPI.userID()
        var dataArr = [AnyObject]()
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchDownload = NSFetchRequest<NSFetchRequestResult>(entityName: "PublicationDownload")
        
        fetchDownload.returnsObjectsAsFaults = false
        do {
            let result = try managedContext?.fetch(fetchDownload)
            
            print("fethc fetchDownload==\(result)")
            for data in result as! [NSManagedObject] {
                let userTmp = data.value(forKey: "userId") as? String
                if getUserId == userTmp {
                    
                    var dataSetDict = [String:AnyObject]()
                    dataSetDict["userId"] = data.value(forKey: "userId") as AnyObject
                    dataSetDict["publication_download"] = data.value(forKey: "publication_download") as AnyObject
                    dataSetDict["publication_id"] = data.value(forKey: "publication_id") as AnyObject
                    dataArr.append(dataSetDict as AnyObject)
                }
            }
        } catch {
            print("Failed")
        }
        return dataArr
        
    }
    

    // ------------- here is save readed article data -----------------------
    
    func addArticleInDB(getArticleData: [AnyObject],saveUnitsId: String){
        let getUserId    = NetworkAPI.userID()
        let managedContext = appDelegate?.persistentContainer.viewContext
       // let publicationArr = object["success"] as? [AnyObject]
        
        print("Get Article Array==\(getArticleData)")
        if getArticleData.count == 0{
            return
        }
        var fetchArticleData = [AnyObject]()
        let articleUnitEntity = NSEntityDescription.entity(forEntityName: "ArticlesTable", in: (managedContext)!)!
        
        //        let publicationsDownFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PublicationDownload")
        //         publicationsDownFetch.returnsObjectsAsFaults = false
        //        print("unita data()()() print==//\(publicationArr)")
        
        let articleFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticlesTable")
        articleFetch.returnsObjectsAsFaults = false
        do {
            
            let result = try managedContext?.fetch(articleFetch)
            
            print("fethc publication==\(result)")
            for data in result as! [NSManagedObject] {
               //  let article_idTmp = data.value(forKey: "article_id") as? String
                let unit_idTmp = data.value(forKey: "unit_id") as? String
                 let userIdTmp = data.value(forKey: "userId") as? String
                if getUserId == userIdTmp && saveUnitsId == userIdTmp {
                    fetchArticleData.append(data)
                      print(" 111_id===\(unit_idTmp)")
                 }
             }
            
        } catch {
            print("Failed")
        }
        
         //let getArticleId = getUnitsDetailDict["article_id"] as? String ?? ""
        // let getArticleUnitsId = getUnitsDetailDict["unit_id"] as? String ?? ""
        
        for i in 0..<getArticleData.count {
            //let publicationObject = NSManagedObject(entity: articleUnitEntity, insertInto: managedContext)
             let articleUnitObject = NSManagedObject(entity: articleUnitEntity, insertInto: managedContext)
            let getDict = getArticleData[i] as? [String:AnyObject]
             let arId = getDict!["article_id"] as? String
             let utId = getDict!["unit_id"] as? String
           
            if fetchArticleData.count == 0{
                articleUnitObject.setValue(utId, forKeyPath: "unit_id")
                // publicationObject.setValue(bodyStr, forKey: "body")
                articleUnitObject.setValue(getUserId, forKey: "userId")
                articleUnitObject.setValue(arId, forKey: "article_id")
                articleUnitObject.setValue("notReaded", forKey: "read")
              
                do {
                    try managedContext?.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }else{
                
                // print("updatePublication==\(fetchPubArrData)")
                for data in fetchArticleData as! [NSManagedObject] {
                    let userIdStr = data.value(forKey: "userId") as? String
                    let unitIdStr = data.value(forKey: "unit_id") as? String
                    let articleIdStr = data.value(forKey: "article_id") as? String
                     let readedStr = data.value(forKey: "read") as? String
                    if getUserId == userIdStr && arId == articleIdStr && utId == unitIdStr {
                        data.setValue(userIdStr, forKey: "userId")
                        data.setValue(unitIdStr, forKey: "unit_id")
                        data.setValue(articleIdStr, forKey: "article_id")
                        data.setValue(readedStr, forKey: "read")
                    }
                }
            }
        }
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
      }
    
    func updateArticleToDB(getUnitsDetailDict: [String:AnyObject]){
        
          let getUserId    = NetworkAPI.userID()
              let getTmpArId =  getUnitsDetailDict["article_id"] as? String ?? ""
              let getTmpUnitId =  getUnitsDetailDict["unit_id"] as? String ?? ""
             // let getTmpreadedStr =  getUnitsDetailDict["read"] as? String ?? ""
              let artManagedContext = appDelegate?.persistentContainer.viewContext
              let articleFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticlesTable")
              articleFetch.returnsObjectsAsFaults = false
        do {
              let result = try artManagedContext?.fetch(articleFetch)
            //  print("fethc publication==\(result)")
            for data in result as! [NSManagedObject] {
                let article_idTmp = data.value(forKey: "article_id") as? String
                let unit_idTmp = data.value(forKey: "unit_id") as? String
                let userIdTmp = data.value(forKey: "userId") as? String
                if getUserId == userIdTmp && getTmpArId == article_idTmp && getTmpUnitId == unit_idTmp {
                    
                    data.setValue(article_idTmp, forKey: "article_id")
                    data.setValue(unit_idTmp, forKey: "unit_id")
                    data.setValue(userIdTmp, forKey: "userId")
                    data.setValue("readed", forKey: "read")
                }
            }
        } catch {
            print("Failed")
        }
        
        do {
            try artManagedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
     }
    
    func getArticleData(getUnitsId:String) ->[AnyObject]{
          var arData = [AnyObject]()
          let artManagedContext = appDelegate?.persistentContainer.viewContext
        
        let articleFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticlesTable")
        articleFetch.returnsObjectsAsFaults = false
        do {
            let result = try artManagedContext?.fetch(articleFetch)
            for data in result as! [NSManagedObject] {
                 let unit_idTmp = data.value(forKey: "unit_id") as? String
                
                print(" units ==\(getUnitsId) & unit ==\(unit_idTmp)")
                if getUnitsId == unit_idTmp {
                    
                var arDict = [String:AnyObject]()
                 let article_idTmp = data.value(forKey: "article_id") as? String
                 let unit_idTmp = data.value(forKey: "unit_id") as? String
                let userIdTmp = data.value(forKey: "userId") as? String
                let readTmp = data.value(forKey: "read") as? String
                
                 arDict["article_id"] = article_idTmp as AnyObject
                 arDict["unit_id"] = unit_idTmp as AnyObject
                 arDict["userId"] = userIdTmp as AnyObject
                 arDict["read"] = readTmp as AnyObject
                 arData.append(arDict as AnyObject)
                    
                }
            }
            
           
    } catch {
            print("Failed")
        }
        
   return arData
     }
    
    func podMediaInDB(podMediaArr:[AnyObject]){
        
        let getUserId    = NetworkAPI.userID()
        let getUnitsId    = StorageClass.getUnitsId()
         let getArticleId    = StorageClass.getArticleId()
        let managedContext = appDelegate?.persistentContainer.viewContext
        // let publicationArr = object["success"] as? [AnyObject]
        
        print("Get Article Array==\(getArticleData)")
        if podMediaArr.count == 0{
            return
        }
        var fetchArticleData = [AnyObject]()
        let articleUnitEntity = NSEntityDescription.entity(forEntityName: "PodMedia", in: (managedContext)!)!
        
        //        let publicationsDownFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PublicationDownload")
        //         publicationsDownFetch.returnsObjectsAsFaults = false
        //        print("unita data()()() print==//\(publicationArr)")
        
        let articleFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PodMedia")
        articleFetch.returnsObjectsAsFaults = false
        do {
            
            let result = try managedContext?.fetch(articleFetch)
            
            print("fethc publication==\(result)")
            for data in result as! [NSManagedObject] {
               let article_idTmp = data.value(forKey: "article_id") as? String
                let unit_idTmp = data.value(forKey: "unit_id") as? String
                let userIdTmp = data.value(forKey: "userId") as? String
                if getUserId == userIdTmp && getUnitsId == userIdTmp && getArticleId == article_idTmp {
                    fetchArticleData.append(data)
                    print(" 111_id===\(unit_idTmp)")
                  }
             }
            
        } catch {
            print("Failed")
        }
        
        //let getArticleId = getUnitsDetailDict["article_id"] as? String ?? ""
        // let getArticleUnitsId = getUnitsDetailDict["unit_id"] as? String ?? ""
        
        for i in 0..<podMediaArr.count {
            //let publicationObject = NSManagedObject(entity: articleUnitEntity, insertInto: managedContext)
            let articleUnitObject = NSManagedObject(entity: articleUnitEntity, insertInto: managedContext)
            let getDict = podMediaArr[i] as? [String:AnyObject]
            let arId = getDict!["article_id"] as? String
           let media_id = getDict!["media_id"] as? String
            
            if fetchArticleData.count == 0{
                articleUnitObject.setValue(getUnitsId, forKeyPath: "unit_id")
                articleUnitObject.setValue(getUserId, forKey: "userId")
                articleUnitObject.setValue(arId, forKey: "article_id")
                articleUnitObject.setValue(media_id, forKey: "media_id")
                articleUnitObject.setValue("notReaded", forKey: "read")
                
                do {
                    try managedContext?.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }else{
                
                // print("updatePublication==\(fetchPubArrData)")
                for data in fetchArticleData as! [NSManagedObject] {
                    let userIdStr = data.value(forKey: "userId") as? String
                    let unitIdStr = data.value(forKey: "unit_id") as? String
                    let articleIdStr = data.value(forKey: "article_id") as? String
                    let readedStr = data.value(forKey: "read") as? String
                    let media_idStr = data.value(forKey: "media_id") as? String
                    if getUserId == userIdStr && arId == articleIdStr && getUnitsId == unitIdStr && media_id == media_idStr{
                        data.setValue(userIdStr, forKey: "userId")
                        data.setValue(unitIdStr, forKey: "unit_id")
                        data.setValue(articleIdStr, forKey: "article_id")
                         data.setValue(media_idStr, forKey: "media_id")
                        data.setValue(readedStr, forKey: "read")
                    }
                }
            }
        }
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    
    func getPodMediaData(getUnitsId:String,getArticleId:String) ->[AnyObject]{
        
        var arData = [AnyObject]()
        let artManagedContext = appDelegate?.persistentContainer.viewContext
        
        let articleFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PodMedia")
        articleFetch.returnsObjectsAsFaults = false
        do {
            let result = try artManagedContext?.fetch(articleFetch)
            for data in result as! [NSManagedObject] {
                let unit_idTmp = data.value(forKey: "unit_id") as? String
                let article_idTmp = data.value(forKey: "article_id") as? String
                
                print(" units ==\(getUnitsId) & unit ==\(unit_idTmp)")
                 print(" getArticleId ==\(getArticleId) & article_idTmp ==\(article_idTmp)")
                if getUnitsId == unit_idTmp && getArticleId == article_idTmp{
                    
                    var arDict = [String:AnyObject]()
                    let article_idTmp = data.value(forKey: "article_id") as? String
                    let unit_idTmp = data.value(forKey: "unit_id") as? String
                    let userIdTmp = data.value(forKey: "userId") as? String
                    let readTmp = data.value(forKey: "read") as? String
                    
                    arDict["article_id"] = article_idTmp as AnyObject
                    arDict["unit_id"] = unit_idTmp as AnyObject
                    arDict["userId"] = userIdTmp as AnyObject
                    arDict["read"] = readTmp as AnyObject
                    arData.append(arDict as AnyObject)
                    
                }
            }
            
        } catch {
            print("Failed")
        }
        
        print("pod array print==%@",arData)
        return arData
    }
    
    func updatePodToDB(getPodDetailDict: [String:AnyObject]){
        
        let getUserId    = NetworkAPI.userID()
        let getTmpArId =  getPodDetailDict["article_id"] as? String ?? ""
         let getmedia_idId =  getPodDetailDict["media_id"] as? String ?? ""
        let getTmpUnitId =  StorageClass.getUnitsId() as String//getPodDetailDict["unit_id"] as? String ?? ""
        // let getTmpreadedStr =  getUnitsDetailDict["read"] as? String ?? ""
        let artManagedContext = appDelegate?.persistentContainer.viewContext
        let articleFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PodMedia")
        articleFetch.returnsObjectsAsFaults = false
        do {
            let result = try artManagedContext?.fetch(articleFetch)
            //  print("fethc publication==\(result)")
            for data in result as! [NSManagedObject] {
                let article_idTmp = data.value(forKey: "article_id") as? String
                let unit_idTmp = data.value(forKey: "unit_id") as? String
                let userIdTmp = data.value(forKey: "userId") as? String
                 let media_idTemp = data.value(forKey: "media_id") as? String
                if getUserId == userIdTmp && getTmpArId == article_idTmp && getTmpUnitId == unit_idTmp && getmedia_idId == media_idTemp {
                    
                    data.setValue(article_idTmp, forKey: "article_id")
                     data.setValue(media_idTemp, forKey: "media_id")
                    data.setValue(unit_idTmp, forKey: "unit_id")
                    data.setValue(userIdTmp, forKey: "userId")
                    data.setValue("readed", forKey: "read")
                }
            }
        } catch {
            print("Failed")
        }
        do {
            try artManagedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    

    
    func updateCDBData(userId:String)->String {
        var userEnterData:String? = "user exit in db"
        let managedContext = appDelegate?.persistentContainer.viewContext
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "USER")
        // let results: Results<Item> = database.objects(Item.self)
        /* Let’s work on our request. We want to fetch just a one record:
         
         userFetch.fetchLimit = 1
         and only when a name is “John”:
         
         userFetch.predicate = NSPredicate(format: "name = %@", "John")
         Moreover, we want to sort by an email address with ascending order:
         
         userFetch.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: true)]
         */
        userFetch.returnsObjectsAsFaults = false
        do {
            let result = try managedContext?.fetch(userFetch)
            for data in result as! [NSManagedObject] {
                let getUserId = data.value(forKey: "userId") as? String
                if getUserId == userId {
                    // data.setValue("karan", forKey: "userId")
                    userEnterData = "user exit in db"
                    
                }else {
                   userEnterData = "user not exit in db"
                    
                }
                print(result)
            }
          } catch {
            
            print("Failed")
         }
        
        return userEnterData!
    }
    
    func deletDownloadedPublicationFromDB(publicationId: String){
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchDownload = NSFetchRequest<NSFetchRequestResult>(entityName: "PublicationDownload")
        fetchDownload.returnsObjectsAsFaults = false
        do {
            let result = try managedContext?.fetch(fetchDownload)
            
            print("fethc fetchDownload==\(result)")
            for data in result as! [NSManagedObject] {
                
                let publicationIdTmp = data.value(forKey: "publication_id") as? String
                if publicationId == publicationIdTmp {
                    // managedContext?.delete(data as! NSManagedObject)
                    managedContext?.delete(data)
                }
            }
        } catch {
            print("Failed")
        }
        
        
        let fetchUnits = NSFetchRequest<NSFetchRequestResult>(entityName: "Units")
        fetchUnits.returnsObjectsAsFaults = false
        do {
            let result = try managedContext?.fetch(fetchUnits)
            
            print("fethc fetchDownload==\(result)")
            for data in result as! [NSManagedObject] {
                
                let publicationIdTmp = data.value(forKey: "publication_id") as? String
                if publicationId == publicationIdTmp {
                    // managedContext?.delete(data as! NSManagedObject)
                    managedContext?.delete(data)
                }
            }
        } catch {
            print("Failed")
        }
        
        do {
            try managedContext?.save() // <- remember to put this :)
        } catch {
            // Do something... fatalerror
        }
        
        updatePublicationFromDB(publicationId: publicationId)
    }

        
    func deleteAllCDB()  {
         let context = appDelegate?.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "USER")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context?.execute(deleteRequest)
            try context?.save()
        } catch {
            print ("There was an error")
        }
//        try! database.write {
//            database.deleteAll()
//        }
    }
    
    func deletePublicationAllCDB()  {
        let context = appDelegate?.persistentContainer.viewContext
        
        let deleteFetch1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Publications")
       // let deleteRequest1 = NSBatchDeleteRequest(fetchRequest: deleteFetch1)
        let objects = try! context?.fetch(deleteFetch1)
        for obj in objects! {
            context?.delete(obj as! NSManagedObject)
        }
        do {
            try context?.save()
        } catch {
            print ("There was an error")
        }
       
    }
    
    func deleteFromCDB(object: Item) {
        
//        try! database.write {
//
//            database.delete(object)
//        }
//    }
}
}
