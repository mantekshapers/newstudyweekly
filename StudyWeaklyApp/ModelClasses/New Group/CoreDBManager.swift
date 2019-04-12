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
class CDBManager
{
      static let sharedInstance = CDBManager()
      let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func getDataFromDB()->[AnyObject]
    {
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
                dataSetDict["userEmail"] = data.value(forKey: "userEmail") as AnyObject
                dataSetDict["userRole"] = data.value(forKey: "userRole") as AnyObject
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
    func getpublicationFromDB()->[AnyObject]
    {
        let getUserId    = NetworkAPI.userID()
        var dataArr = [AnyObject]()
        let managedContext = appDelegate?.persistentContainer.viewContext
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Publications")
        
        userFetch.returnsObjectsAsFaults = false
        do {
            let result = try managedContext?.fetch(userFetch)
            
            print("fethc publication==\(String(describing: result))")
            for data in result as! [NSManagedObject] {
                
                let userTmp = data.value(forKey: "userId") as? String
                if getUserId == userTmp
                {
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
    
    func updatePublicationFromDB(publicationId: String)
    {
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

    func addCDBData(object: [String:Any])
    {
        //  deleteAllCDB()
        let getDict = object["success"] as? [String: Any]
        let getName = getDict!["name"] as? String
        // let userName = object["username"] as? String
        let userId = getDict!["user_id"] as? String
        let userPassword = getDict!["student_password"] as? String
        let userRoles = getDict!["role"] as? String
        let userEmails = getDict!["email"] as? String
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
            user.setValue(userRoles, forKey: "userRole")
            user.setValue(userEmails, forKey: "userEmail")
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
    func addUnitsCDBData(publicationIdStr:String,object: [AnyObject])
    {
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
    
    func getUnitsDataFromUnitsTable(searchUnits:String)->[AnyObject]
    {
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
    
    func unitsDeleteFromDB()
    {
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
    
    func addPublicationCDBData(object: [String:Any])
    {
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
            
            print("fethc publication==\(String(describing: result))")
            for data in result as! [NSManagedObject]
            {
                let userTmp = data.value(forKey: "userId") as? String
                if getUserId == userTmp {
                    fetchPubArrData.append(data)
                }
            }
        } catch {
            print("Failed")
        }
        
        for i in 0..<publicationArr!.count
        {
            let publicationObject = NSManagedObject(entity: publicationEntity, insertInto: managedContext)
            let getDict = publicationArr?[i] as? [String:Any]
            
            let coverUrl =  getDict!["cover_url"] as? String ?? ""
            let coverUrl1     =  "https:" + coverUrl
            let publicationId = getDict!["publication_id"] as? String
            // let userName = object["username"] as? String
            let bodyStr = getDict!["body"] as? String
            print("bodyStr:\(bodyStr)")
            let skuStr = getDict!["sku"] as? String
            //let coverData = getDict!["cover_url"] as? String
            let titleStr = getDict!["title"] as? String
            let unitsArr = getDict!["units"] as! [AnyObject]
            
            print("unita data print==//\(unitsArr)")
            
            //            for data in result as! [NSManagedObject] {
            //                let UserId = data.value(forKey: "userId") as? String
            //                let getPubId = data.value(forKey: "publication_id") as? String
            if fetchPubArrData.count == 0
            {
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
            }
            else
            {
                // print("updatePublication==\(fetchPubArrData)")
                for data in fetchPubArrData as! [NSManagedObject]
                {
                    let UserId = data.value(forKey: "userId") as? String
                    let getPubId = data.value(forKey: "publication_id") as? String
                    let publiDown = data.value(forKey: "publication_download") as? String
                    
                    if getUserId == UserId && publicationId == getPubId
                    {
                        data.setValue(publicationId, forKeyPath: "publication_id")
                        // publicationObject.setValue(bodyStr, forKey: "body")
                        data.setValue(getUserId, forKey: "userId")
                        data.setValue(publiDown, forKey: "publication_download")
                        data.setValue(skuStr, forKey: "sku")
                        data.setValue(coverUrl1, forKey: "cover_url")
                        data.setValue(titleStr, forKey: "title")
                        data.setValue(unitsArr, forKey: "unitsOfArray")
                        
                        for dict in downloadTbleArr
                        {
                            let getDownPubId = dict.value(forKey: "publication_id") as? String ?? ""
                            let getDownUserId = dict.value(forKey: "userId") as? String ?? ""
                            let getDown = dict.value(forKey: "publication_download") as? String ?? ""
                            
                            if getPubId == getDownPubId && UserId == getDownUserId
                            {
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
    
    func getDownloadPublicFromDB()->[AnyObject]
    {
        let getUserId    = NetworkAPI.userID()
        var dataArr = [AnyObject]()
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchDownload = NSFetchRequest<NSFetchRequestResult>(entityName: "PublicationDownload")
        
        fetchDownload.returnsObjectsAsFaults = false
        do
        {
            let result = try managedContext?.fetch(fetchDownload)
            
            print("fethc fetchDownload==\(String(describing: result))")
            for data in result as! [NSManagedObject]
            {
                let userTmp = data.value(forKey: "userId") as? String
                if getUserId == userTmp
                {
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
    func addArticleInDB(getArticleData: [AnyObject],saveUnitsId: String)
    {
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
        do
        {
            let result = try managedContext?.fetch(articleFetch)
            
            print("fethc publication==\(String(describing: result))")
            for data in result as! [NSManagedObject]
            {
                //  let article_idTmp = data.value(forKey: "article_id") as? String
                let unit_idTmp = data.value(forKey: "unit_id") as? String
                let userIdTmp = data.value(forKey: "userId") as? String
                if getUserId == userIdTmp && saveUnitsId == userIdTmp {
                    fetchArticleData.append(data)
                    print(" 111_id===\(String(describing: unit_idTmp))")
                }
            }
        } catch {
            print("Failed")
        }
        
        //let getArticleId = getUnitsDetailDict["article_id"] as? String ?? ""
        // let getArticleUnitsId = getUnitsDetailDict["unit_id"] as? String ?? ""
        for i in 0..<getArticleData.count
        {
            //let publicationObject = NSManagedObject(entity: articleUnitEntity, insertInto: managedContext)
            let articleUnitObject = NSManagedObject(entity: articleUnitEntity, insertInto: managedContext)
            let getDict = getArticleData[i] as? [String:AnyObject]
            let arId = getDict!["article_id"] as? String
            let utId = getDict!["unit_id"] as? String
            
            if fetchArticleData.count == 0
            {
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
            }
            else
            {
                // print("updatePublication==\(fetchPubArrData)")
                for data in fetchArticleData as! [NSManagedObject]
                {
                    let userIdStr = data.value(forKey: "userId") as? String
                    let unitIdStr = data.value(forKey: "unit_id") as? String
                    let articleIdStr = data.value(forKey: "article_id") as? String
                    let readedStr = data.value(forKey: "read") as? String
                    
                    if getUserId == userIdStr && arId == articleIdStr && utId == unitIdStr
                    {
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
    
    func updateArticleToDB(getUnitsDetailDict: [String:AnyObject])
    {
        let getUserId    = NetworkAPI.userID()
        let getTmpArId =  getUnitsDetailDict["article_id"] as? String ?? ""
        let getTmpUnitId =  getUnitsDetailDict["unit_id"] as? String ?? ""
        // let getTmpreadedStr =  getUnitsDetailDict["read"] as? String ?? ""
        let artManagedContext = appDelegate?.persistentContainer.viewContext
        let articleFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticlesTable")
        articleFetch.returnsObjectsAsFaults = false
        do
        {
            let result = try artManagedContext?.fetch(articleFetch)
            //  print("fethc publication==\(result)")
            for data in result as! [NSManagedObject]
            {
                let article_idTmp = data.value(forKey: "article_id") as? String
                let unit_idTmp = data.value(forKey: "unit_id") as? String
                let userIdTmp = data.value(forKey: "userId") as? String
                
                if getUserId == userIdTmp && getTmpArId == article_idTmp && getTmpUnitId == unit_idTmp
                {
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
    
    func getArticleData(getUnitsId:String) ->[AnyObject]
    {
        var arData = [AnyObject]()
        let artManagedContext = appDelegate?.persistentContainer.viewContext
        
        let articleFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticlesTable")
        articleFetch.returnsObjectsAsFaults = false
        do {
            let result = try artManagedContext?.fetch(articleFetch)
            for data in result as! [NSManagedObject]
            {
                let unit_idTmp = data.value(forKey: "unit_id") as? String
                
                print(" units ==\(getUnitsId) & unit ==\(String(describing: unit_idTmp))")
                if getUnitsId == unit_idTmp
                {
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
    
    func addQuestionsInDB(articleId:String,questDict:[String:AnyObject])
    {
        // Now working on question
        let aStr = questDict["a"] as? String
        let bStr = questDict["b"] as? String
        let cStr = questDict["c"] as? String
        let dStr = questDict["d"] as? String
        let articleIdStr = questDict["article_id"] as? String
        let answerStr = questDict["answer"] as? String
        let answerSelectStr = questDict["selectAns"] as? String
        let difficultyStr = questDict["difficulty"] as? String
        let typeStr = questDict["type"] as? String
        let points_possible = questDict["points_possible"] as? Int
        let questionStr = questDict["question"] as? String
        let questionIdStr = questDict["question_id"] as? String
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let QuestionsEntity = NSEntityDescription.entity(forEntityName: "QuestionsTable", in: (managedContext)!)!
        /*
         let questionsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionsTable")
         //questionsFetch.fetchLimit = 1
         let predicate = NSPredicate(format: "article_id = %@",articleId)
         questionsFetch.predicate = predicate
         
         //articleFetch.returnsObjectsAsFaults = false
         do {
         let result = try managedContext?.fetch(questionsFetch) as? [NSManagedObject]
         if (result?.count)!>0{
         var updateCheck:String?  = "insert"
         for i in 0..<(result?.count)! {
         var qDictTMP = [String:AnyObject]()
         let qDict = result![i] as NSManagedObject
         
         let questionIdTmp1 = qDict.value(forKey: "question_id") as? String
         //let articleIdStr = questDict["article_id"] as? String
         if questionIdStr == questionIdTmp1 {
         updateCheck = "NotInsert"
         //                     qDict["a"] = qDict.value(forKey: "a") as AnyObject
         //                     qDict["b"] = qDict.value(forKey: "b") as AnyObject
         //                     qDict["c"] = qDict.value(forKey: "c") as AnyObject
         //                     qDict["d"] = qDict.value(forKey: "d") as AnyObject
         //                     qDict["article_id"] = qDict.value(forKey: "article_id") as AnyObject
         //                     qDict["answer"] = qDict.value(forKey: "answer") as AnyObject
         //                     qDict["selectAns"] = qDict.value(forKey: "selectAns") as AnyObject
         //                     qDict["difficulty"] = qDict.value(forKey: "difficulty") as AnyObject
         //                     qDict["type"] = qDict.value(forKey: "type") as AnyObject
         //                    qDict["points_possible"] = qDict.value(forKey: "points_possible") as AnyObject
         //                     qDict["question"] = qDict.value(forKey: "question") as AnyObject
         //                     qDict["question_id"] = qDict.value(forKey: "question_id") as AnyObject
         
         // qDict.setValue(, forKey: <#T##String#>)
         // qDict["selectAns"] = qDict.value(forKey: "selectAns") as AnyObject
         qDict.setValue(answerSelectStr, forKey: "selectAns")
         
         }
         
         }
         if updateCheck == "insert"{
         
         let questionObject = NSManagedObject(entity: QuestionsEntity, insertInto: managedContext)
         print("fethc == publication==\(result)")
         questionObject.setValue(articleIdStr, forKey: "article_id")
         questionObject.setValue(answerStr, forKey: "answer")
         questionObject.setValue(answerSelectStr, forKey: "selectAns")
         questionObject.setValue(aStr, forKey: "a")
         questionObject.setValue(bStr, forKey: "b")
         questionObject.setValue(cStr, forKey: "c")
         questionObject.setValue(dStr, forKey: "d")
         questionObject.setValue(difficultyStr, forKey: "difficulty")
         questionObject.setValue(typeStr, forKey: "type")
         questionObject.setValue(points_possible, forKey: "points_possible")
         questionObject.setValue(questionStr, forKey: "question")
         questionObject.setValue(questionIdStr, forKey: "question_id")
         
         do {
         try managedContext?.save()
         } catch let error as NSError {
         print("Could not save. \(error), \(error.userInfo)")
         }
         }
         
         return
         }
         */
        let questionObject = NSManagedObject(entity: QuestionsEntity, insertInto: managedContext)
        
        questionObject.setValue(articleIdStr, forKey: "article_id")
        questionObject.setValue(answerStr, forKey: "answer")
        questionObject.setValue(answerSelectStr, forKey: "selectAns")
        questionObject.setValue(aStr, forKey: "a")
        questionObject.setValue(bStr, forKey: "b")
        questionObject.setValue(cStr, forKey: "c")
        questionObject.setValue(dStr, forKey: "d")
        questionObject.setValue(difficultyStr, forKey: "difficulty")
        questionObject.setValue(typeStr, forKey: "type")
        questionObject.setValue(points_possible, forKey: "points_possible")
        questionObject.setValue(questionStr, forKey: "question")
        questionObject.setValue(questionIdStr, forKey: "question_id")
        
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchArticleQstMethod(articlesId:String)->[AnyObject]
    {
        var qFetchQuestionArr = [AnyObject]()
        let managedContext = appDelegate?.persistentContainer.viewContext
        //let QuestionsEntity = NSEntityDescription.entity(forEntityName: "QuestionsTable", in: (managedContext)!)!
        
        let questionsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionsTable")
        //questionsFetch.fetchLimit = 1
        let predicate = NSPredicate(format: "article_id = %@",articlesId)
        questionsFetch.predicate = predicate
        
        //articleFetch.returnsObjectsAsFaults = false
        do {
            let result = try managedContext?.fetch(questionsFetch) as? [NSManagedObject]
            if (result?.count)!>0
            {
                for i in 0..<(result?.count)!
                {
                    var qDictTmp = [String:AnyObject]()
                    let qDict = result![i]
                   // let questionIdTmp = qDict.value(forKey: "question_id") as? String
                    
                    qDictTmp["a"] = qDict.value(forKey: "a") as AnyObject
                    qDictTmp["b"] = qDict.value(forKey: "b") as AnyObject
                    qDictTmp["c"] = qDict.value(forKey: "c") as AnyObject
                    qDictTmp["d"] = qDict.value(forKey: "d") as AnyObject
                    qDictTmp["article_id"] = qDict.value(forKey: "article_id") as AnyObject
                    qDictTmp["answer"] = qDict.value(forKey: "answer") as AnyObject
                    qDictTmp["selectAns"] = qDict.value(forKey: "selectAns") as AnyObject
                    qDictTmp["difficulty"] = qDict.value(forKey: "difficulty") as AnyObject
                    qDictTmp["type"] = qDict.value(forKey: "type") as AnyObject
                   qDictTmp["points_possible"] = qDict.value(forKey: "points_possible") as AnyObject
                    qDictTmp["question"] = qDict.value(forKey: "question") as AnyObject
                    qDictTmp["question_id"] = qDict.value(forKey: "question_id") as AnyObject
                    
                    qFetchQuestionArr.append(qDictTmp as AnyObject)
                }
            }
        }catch {
            print("Failed")
        }
        return qFetchQuestionArr
    }
    
    func updateArticleOfQuestionMethod(articleId:String,questDict:[String:AnyObject])
    {
         let answerSelectStr = questDict["selectAns"] as? String
         let questionIdStr = questDict["question_id"] as? String
         let managedContext = appDelegate?.persistentContainer.viewContext
        let questionsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionsTable")
        //questionsFetch.fetchLimit = 1
        let predicate = NSPredicate(format: "article_id = %@",articleId)
        questionsFetch.predicate = predicate
        
        //articleFetch.returnsObjectsAsFaults = false
        do
        {
            let result = try managedContext?.fetch(questionsFetch) as? [NSManagedObject]
            if (result?.count)!>0
            {
                for i in 0..<(result?.count)!
                {
                    let qDict = result![i] as NSManagedObject
                    let questionIdTmp1 = qDict.value(forKey: "question_id") as? String
                    //let articleIdStr = questDict["article_id"] as? String
                    if questionIdStr == questionIdTmp1
                    {
                        //                     qDict["a"] = qDict.value(forKey: "a") as AnyObject
                        //                     qDict["b"] = qDict.value(forKey: "b") as AnyObject
                        //                     qDict["c"] = qDict.value(forKey: "c") as AnyObject
                        //                     qDict["d"] = qDict.value(forKey: "d") as AnyObject
                        //                     qDict["article_id"] = qDict.value(forKey: "article_id") as AnyObject
                        //                     qDict["answer"] = qDict.value(forKey: "answer") as AnyObject
                        //                     qDict["selectAns"] = qDict.value(forKey: "selectAns") as AnyObject
                        //                     qDict["difficulty"] = qDict.value(forKey: "difficulty") as AnyObject
                        //                     qDict["type"] = qDict.value(forKey: "type") as AnyObject
                        //                    qDict["points_possible"] = qDict.value(forKey: "points_possible") as AnyObject
                        //                     qDict["question"] = qDict.value(forKey: "question") as AnyObject
                        //                     qDict["question_id"] = qDict.value(forKey: "question_id") as AnyObject
                        
                        // qDict.setValue(, forKey: <#T##String#>)
                        // qDict["selectAns"] = qDict.value(forKey: "selectAns") as AnyObject
                        qDict.setValue(answerSelectStr, forKey: "selectAns")
                    }
                }
            }
        } catch {
                        print("Failed")
            }
    }
    
    // ------------- add search media in DB --------------
    func addSearchMediaInDB(getSearchDict:[String:AnyObject])
    {
        let getMediaId = getSearchDict["media_id"] as? String
        let media_nameTmp = getSearchDict["media_name"] as? String
        let media_splashTmp = getSearchDict["media_splash"] as? String
        let media_descriptionTmp = getSearchDict["media_description"] as? String
        let media_sourceTmp = getSearchDict["media_source"] as? String
        print("media_sourceTmp\(String(describing: media_sourceTmp))")
        //let downloadTmp = getSearchDict["download"] as? String
        // let getMediaId = getSearchDict["userId"] as? String
        let mediaSource = getSearchDict["media_source"] as! String
        let mediaUrlStr = "https://" +  CustomController.backSlaceRemoveFromUrl(urlStr: mediaSource)
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        let searchMediaEntity = NSEntityDescription.entity(forEntityName: "SearchMedia", in: (managedContext)!)!
        
        let articleFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchMedia")
        articleFetch.fetchLimit = 1
        let predicate = NSPredicate(format: "media_id = %@",getMediaId!)
        articleFetch.predicate = predicate
        
        //articleFetch.returnsObjectsAsFaults = false
        do
        {
            let result = try managedContext?.fetch(articleFetch) as? [NSManagedObject]
            if (result?.count)!>0{
                return
            }
            let currentDate = DateModel().saveCurrentDate()
            
            let searchMediaObject = NSManagedObject(entity: searchMediaEntity, insertInto: managedContext)
            print("fethc publication==\(String(describing: result))")
            searchMediaObject.setValue("download", forKey: "download")
            searchMediaObject.setValue(getMediaId, forKey: "media_id")
            searchMediaObject.setValue(media_nameTmp, forKey: "media_name")
            searchMediaObject.setValue(media_splashTmp, forKey: "media_splash")
            searchMediaObject.setValue(media_descriptionTmp, forKey: "media_description")
            searchMediaObject.setValue(mediaUrlStr, forKey: "media_source")
            searchMediaObject.setValue(NetworkAPI.userID(), forKey: "userId")
            searchMediaObject.setValue(currentDate, forKey: "dateCreate")
            
            do {
                try managedContext?.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }catch {
            print("Failed")
        }
    }
    
    func getSearchMedia(getSearchDict:[String:AnyObject],searchKey:String)->[AnyObject]
    {
        var searchMediaAr = [AnyObject]()
        let managedContext = appDelegate?.persistentContainer.viewContext
        let searchFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchMedia")
        
        if searchKey != "AllFetch"
        {
            let getMediaId = getSearchDict["media_id"] as? String
            searchFetch.fetchLimit = 1
            let predicate = NSPredicate(format: "media_id = %@",getMediaId!)
            searchFetch.predicate = predicate
        }
        searchFetch.returnsObjectsAsFaults = false
        do
        {
            let result = try managedContext?.fetch(searchFetch) as? [NSManagedObject]
            if (result?.count)!>0
            {
                for i in 0..<(result?.count)!
                {
                    var dictTmp = [String:AnyObject]()
                    let searchObject = result![i] as NSManagedObject
                    print("fethc publication==\(String(describing: result))")
                    dictTmp["download"] = searchObject.value(forKey: "download") as AnyObject
                    dictTmp["media_id"] = searchObject.value(forKey: "media_id") as AnyObject
                    dictTmp["media_name"] = searchObject.value(forKey: "media_name") as AnyObject
                    dictTmp["media_splash"] = searchObject.value(forKey: "media_splash") as AnyObject
                    dictTmp["media_description"] = searchObject.value(forKey: "media_description") as AnyObject
                    dictTmp["media_source"] = searchObject.value(forKey: "media_source") as AnyObject
                    dictTmp["userId"] = searchObject.value(forKey: "userId") as AnyObject
                    dictTmp["dateCreate"] = searchObject.value(forKey: "dateCreate") as AnyObject
                    searchMediaAr.append(dictTmp as AnyObject)
                }
            }
        }catch {
            print("Failed")
        }
        return searchMediaAr
    }
    
    func addPodDownloadMediaInDB(getSearchDict:[String:AnyObject])
    {
        let getMediaId = getSearchDict["media_id"] as? String
        let media_nameTmp = getSearchDict["name"] as? String
        let articleTmp = getSearchDict["article_id"] as? String
        let media_descriptionTmp = getSearchDict["description"] as? String
        let mediaSource = getSearchDict["url"] as! String
        let mediaUrlStr = "https://" +  CustomController.backSlaceRemoveFromUrl(urlStr: mediaSource)
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        let podMediaEntity = NSEntityDescription.entity(forEntityName: "PodMediaDownload", in: (managedContext)!)!
        
        let podMediaFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PodMediaDownload")
        podMediaFetch.fetchLimit = 1
        let predicate = NSPredicate(format: "media_id = %@",getMediaId!)
        podMediaFetch.predicate = predicate
        
        //articleFetch.returnsObjectsAsFaults = false
        do {
            let result = try managedContext?.fetch(podMediaFetch) as? [NSManagedObject]
            if (result?.count)!>0{
                return
            }
            let currentDate = DateModel().saveCurrentDate()
            print("currentDate==\(String(describing: currentDate))")

            let pMediaObject = NSManagedObject(entity: podMediaEntity, insertInto: managedContext)
            print("fethc publication==\(String(describing: result))")
            pMediaObject.setValue("download", forKey: "download")
            pMediaObject.setValue(getMediaId, forKey: "media_id")
            pMediaObject.setValue(media_nameTmp, forKey: "name")
            pMediaObject.setValue(mediaUrlStr, forKey: "media_source")
            pMediaObject.setValue(articleTmp, forKey: "article_id")
            
            pMediaObject.setValue(media_descriptionTmp, forKey: "m_description")
            pMediaObject.setValue(NetworkAPI.userID(), forKey: "userId")
            do {
                try managedContext?.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }catch {
            print("Failed")
        }
    }
    
    func getPodDownloadMediaMethod(getSearchDict:[String:AnyObject],searchKey:String)->[AnyObject]
    {
        var podMediaArr = [AnyObject]()
        let managedContext = appDelegate?.persistentContainer.viewContext
        let podDwnlFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PodMediaDownload")
        if searchKey != "AllFetch"
        {
            let getMediaId = getSearchDict["media_id"] as? String
            podDwnlFetch.fetchLimit = 1
            let predicate = NSPredicate(format: "media_id = %@",getMediaId!)
            podDwnlFetch.predicate = predicate
        }
        podDwnlFetch.returnsObjectsAsFaults = false
        do
        {
            let result = try managedContext?.fetch(podDwnlFetch) as? [NSManagedObject]
            if (result?.count)!>0
            {
                for i in 0..<(result?.count)!
                {
                    var dictTmp = [String:AnyObject]()
                    let searchObject = result![i] as NSManagedObject
                    print("fethc pod media ==\(String(describing: result))")
                    dictTmp["download"] = searchObject.value(forKey: "download") as AnyObject
                    dictTmp["media_id"] = searchObject.value(forKey: "media_id") as AnyObject
                    dictTmp["media_name"] = searchObject.value(forKey: "name") as AnyObject
                    dictTmp["media_description"] = searchObject.value(forKey: "m_description") as AnyObject
                    dictTmp["media_source"] = searchObject.value(forKey: "media_source") as AnyObject
                    dictTmp["userId"] = searchObject.value(forKey: "userId") as AnyObject
                    dictTmp["article_id"] = searchObject.value(forKey: "article_id") as AnyObject
                    
                    podMediaArr.append(dictTmp as AnyObject)
                }
            }
        }catch {
            print("Failed")
        }
        return podMediaArr
    }
    
    func podMediaInDB(podMediaArr:[AnyObject])
    {
        let getUserId    = NetworkAPI.userID()
        let getUnitsId    = StorageClass.getUnitsId()
         let getArticleId    = StorageClass.getArticleId()
        let managedContext = appDelegate?.persistentContainer.viewContext
        // let publicationArr = object["success"] as? [AnyObject]
        
        print("Get Article Array==\(getArticleData)")
        if podMediaArr.count == 0
        {
            return
        }
        var fetchArticleData = [AnyObject]()
        let articleUnitEntity = NSEntityDescription.entity(forEntityName: "PodMedia", in: (managedContext)!)!
        
        //        let publicationsDownFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PublicationDownload")
        //         publicationsDownFetch.returnsObjectsAsFaults = false
        //        print("unita data()()() print==//\(publicationArr)")
        
        let articleFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PodMedia")
        articleFetch.returnsObjectsAsFaults = false
        do
        {
            let result = try managedContext?.fetch(articleFetch)
            
            print("fethc publication==\(String(describing: result))")
            for data in result as! [NSManagedObject]
            {
               let article_idTmp = data.value(forKey: "article_id") as? String
                let unit_idTmp = data.value(forKey: "unit_id") as? String
                let userIdTmp = data.value(forKey: "userId") as? String
                if getUserId == userIdTmp && getUnitsId == userIdTmp && getArticleId == article_idTmp
                {
                    fetchArticleData.append(data)
                    print(" 111_id===\(String(describing: unit_idTmp))")
                  }
             }
        } catch {
            print("Failed")
        }
        
        //let getArticleId = getUnitsDetailDict["article_id"] as? String ?? ""
        // let getArticleUnitsId = getUnitsDetailDict["unit_id"] as? String ?? ""
        
        for i in 0..<podMediaArr.count
        {
            //let publicationObject = NSManagedObject(entity: articleUnitEntity, insertInto: managedContext)
            let articleUnitObject = NSManagedObject(entity: articleUnitEntity, insertInto: managedContext)
            let getDict = podMediaArr[i] as? [String:AnyObject]
            let arId = getDict!["article_id"] as? String
            let media_id = getDict!["media_id"] as? String
            
            if fetchArticleData.count == 0
            {
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
            }
            else
            {
                // print("updatePublication==\(fetchPubArrData)")
                for data in fetchArticleData as! [NSManagedObject]
                {
                    let userIdStr = data.value(forKey: "userId") as? String
                    let unitIdStr = data.value(forKey: "unit_id") as? String
                    let articleIdStr = data.value(forKey: "article_id") as? String
                    let readedStr = data.value(forKey: "read") as? String
                    let media_idStr = data.value(forKey: "media_id") as? String
                    
                    if getUserId == userIdStr && arId == articleIdStr && getUnitsId == unitIdStr && media_id == media_idStr
                    {
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
    
    func getPodMediaData(getUnitsId:String,getArticleId:String) ->[AnyObject]
    {
        var arData = [AnyObject]()
        let artManagedContext = appDelegate?.persistentContainer.viewContext
        
        let articleFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PodMedia")
        articleFetch.returnsObjectsAsFaults = false
        do {
            let result = try artManagedContext?.fetch(articleFetch)
            for data in result as! [NSManagedObject]
            {
                let unit_idTmp = data.value(forKey: "unit_id") as? String
                let article_idTmp = data.value(forKey: "article_id") as? String
                
                print(" units ==\(getUnitsId) & unit ==\(String(describing: unit_idTmp))")
                print(" getArticleId ==\(getArticleId) & article_idTmp ==\(String(describing: article_idTmp))")
                
                if getUnitsId == unit_idTmp && getArticleId == article_idTmp
                {
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
    
    func updatePodToDB(getPodDetailDict: [String:AnyObject])
    {
        let getUserId    = NetworkAPI.userID()
        let getTmpArId =  getPodDetailDict["article_id"] as? String ?? ""
        let getmedia_idId =  getPodDetailDict["media_id"] as? String ?? ""
        let getTmpUnitId =  StorageClass.getUnitsId() as String//getPodDetailDict["unit_id"] as? String ?? ""
        // let getTmpreadedStr =  getUnitsDetailDict["read"] as? String ?? ""
        let artManagedContext = appDelegate?.persistentContainer.viewContext
        let articleFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PodMedia")
        articleFetch.returnsObjectsAsFaults = false
        do
        {
            let result = try artManagedContext?.fetch(articleFetch)
            //  print("fethc publication==\(result)")
            for data in result as! [NSManagedObject]
            {
                let article_idTmp = data.value(forKey: "article_id") as? String
                let unit_idTmp = data.value(forKey: "unit_id") as? String
                let userIdTmp = data.value(forKey: "userId") as? String
                let media_idTemp = data.value(forKey: "media_id") as? String
                
                if getUserId == userIdTmp && getTmpArId == article_idTmp && getTmpUnitId == unit_idTmp && getmedia_idId == media_idTemp
                {
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
    
    func updateUserRevPointCDBData(revPoints:String)
    {
        let getUserId    = NetworkAPI.userID()
        var userEnterData:String? = "user exit in db"
        print("userEnterData\(userEnterData)")
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
        userFetch.fetchLimit = 1
        let predicate = NSPredicate(format: "userId = %@",getUserId!)
        userFetch.predicate = predicate
        userFetch.returnsObjectsAsFaults = false
        do
        {
            let result = try managedContext?.fetch(userFetch)
            for data in result as! [NSManagedObject] {
                //let getUserId = data.value(forKey: "userId") as? String
                let revUserPoints = data.value(forKey: "userPoints") as? String
                var revPointInt = Int(revUserPoints!)
                revPointInt = revPointInt! + Int(revPoints)!
                data.setValue(String(revPointInt!), forKey: "userPoints")
                
                print("===Rev point=\(String(describing: revPointInt))=Array==\(result!)")
                do {
                    try managedContext?.save()
                } catch {
                    print ("There was an error")
                }
            }
        } catch {
            
            print("Failed")
        }
        // return userEnterData!
    }
    
    func updateCDBData(userId:String)->String
    {
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
        do
        {
            let result = try managedContext?.fetch(userFetch)
            for data in result as! [NSManagedObject]
            {
                let getUserId = data.value(forKey: "userId") as? String
                if getUserId == userId
                {
                    userEnterData = "user exit in db"
                }else {
                    userEnterData = "user not exit in db"
                }
                print(result!)
            }
        } catch {
            
            print("Failed")
        }
        return userEnterData!
    }
    
    func deletDownloadedPublicationFromDB(publicationId: String)
    {
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchDownload = NSFetchRequest<NSFetchRequestResult>(entityName: "PublicationDownload")
        fetchDownload.returnsObjectsAsFaults = false
        do
        {
            let result = try managedContext?.fetch(fetchDownload)
            print("fethc fetchDownload==\(result)")
            for data in result as! [NSManagedObject]
            {
                let publicationIdTmp = data.value(forKey: "publication_id") as? String
                if publicationId == publicationIdTmp
                {
                    // managedContext?.delete(data as! NSManagedObject)
                    managedContext?.delete(data)
                }
            }
        } catch {
            print("Failed")
        }
        
        let fetchUnits = NSFetchRequest<NSFetchRequestResult>(entityName: "Units")
        fetchUnits.returnsObjectsAsFaults = false
        do
        {
            let result = try managedContext?.fetch(fetchUnits)
            
            print("fethc fetchDownload==\(result)")
            for data in result as! [NSManagedObject]
            {
                let publicationIdTmp = data.value(forKey: "publication_id") as? String
                if publicationId == publicationIdTmp
                {
                    // managedContext?.delete(data as! NSManagedObject)
                    managedContext?.delete(data)
                }
            }
        } catch {
            print("Failed")
        }
        
        do
        {
            try managedContext?.save() // <- remember to put this :)
        } catch {
            // Do something... fatalerror
        }
        updatePublicationFromDB(publicationId: publicationId)
    }

    func deleteAllCDB()
    {
        let context = appDelegate?.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "USER")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context?.execute(deleteRequest)
            try context?.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func deletePublicationAllCDB()
    {
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
    
    func addSwitchInCDB(onSwitch:String,switchType:String)
    {
        let managedContext = appDelegate?.persistentContainer.viewContext
        let switchEntity = NSEntityDescription.entity(forEntityName: "SwitchTable", in: (managedContext)!)!
        let switchFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SwitchTable")
        switchFetch.returnsObjectsAsFaults = false
        
        do
        {
            let result = try managedContext?.fetch(switchFetch) as? [NSManagedObject]
            if (result?.count)!>0
            {
                print("fethc switch==\(String(describing: result))")
                let data = result?[0]
                
                if switchType == "imageSwitch"
                {
                    data?.setValue(onSwitch, forKey: "imageSwitch")
                }
                else if switchType ==  "audioSwitch"
                {
                    data?.setValue(onSwitch, forKey: "audioSwitch")
                }
                else if switchType == "mediaSwitch"
                {
                    data?.setValue(onSwitch, forKey: "mediaSwitch")
                }
                
                do
                {
                    try managedContext?.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
                //                 let imageOnStr = data?.value(forKey: "imageSwitch") as? String
                //                 let audioOnStr = data?.value(forKey: "audioSwitch") as? String
                //                 let mediaOnStr = data?.value(forKey: "mediaSwitch") as? String
                
                return
            }
            let switchObject = NSManagedObject(entity: switchEntity, insertInto: managedContext)
            
            if switchType == "imageSwitch"
            {
                switchObject.setValue(onSwitch, forKey: "imageSwitch")
                switchObject.setValue("off", forKey: "audioSwitch")
                switchObject.setValue("off", forKey: "mediaSwitch")
            }
            else if switchType ==  "audioSwitch"
            {
                switchObject.setValue(onSwitch, forKey: "audioSwitch")
                switchObject.setValue("off", forKey: "imageSwitch")
                switchObject.setValue("off", forKey: "mediaSwitch")
            }
            else if switchType == "mediaSwitch"
            {
                switchObject.setValue(onSwitch, forKey: "mediaSwitch")
                switchObject.setValue("off", forKey: "imageSwitch")
                switchObject.setValue("off", forKey: "audioSwitch")
            }
            
            do {
                try managedContext?.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }catch {
            print("Failed")
        }
    }
    
    func fetchSwitchOnMethod()->[AnyObject]
    {
        var switchDataArr = [AnyObject]()
        let managedContext = appDelegate?.persistentContainer.viewContext
        let switchFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SwitchTable")
        switchFetch.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext?.fetch(switchFetch) as? [NSManagedObject]
            if (result?.count)!>0
            {
                var switchDict = [String:AnyObject]()
                print("fethc switch==\(result)")
                let data = result?[0] as? NSManagedObject
                let imgOn = data?.value(forKey: "imageSwitch")
                
                let audioOn = data?.value(forKey: "audioSwitch")
                let mediaOn = data?.value(forKey: "mediaSwitch")
                switchDict["imageSwitch"] = imgOn as AnyObject
                switchDict["audioSwitch"] = audioOn as AnyObject
                switchDict["mediaSwitch"] = mediaOn as AnyObject
                switchDataArr.append(switchDict as AnyObject)
            }
        }
        catch {
            print("Failed")
        }
        
        return switchDataArr
    }
    
    //----------------- add Search media
    func deleteFromCDB(object: Item)
    {
        //        try! database.write {
        //
        //            database.delete(object)
        //        }
        //    }
    }
}
