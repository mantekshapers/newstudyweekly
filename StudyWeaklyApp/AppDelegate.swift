//
//  AppDelegate.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/12/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import CoreData
import SlideMenuControllerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // https://app.studiesweekly.com/online/student_learning_index
      // Override point for customization after application launch.
        let getUserID =  NetworkAPI.userID()
        if getUserID != nil{
             createTabbarMethod(getIndex: 0)
        }else{
      
         }
        return true
        
        

      }
    
    
    func rootViewCallMethod(getAlertTitle: String) {
        print("btn sessionExpired here")
        if getAlertTitle == "sessionExpired" {
            CDBManager().deleteAllCDB()
            NetworkAPI.removeUserId()
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController  =  story.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let rooNav = UINavigationController(rootViewController: viewController)
            self.window?.rootViewController = rooNav
            self.window?.makeKeyAndVisible()
        }
    }
    
    func  createTabbarMethod(getIndex: Int) {
        
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let moreViewController  =  story.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        let more: UINavigationController = UINavigationController(rootViewController: moreViewController)
        let homeViewController = story.instantiateViewController(withIdentifier: "HomeFileViewController") as! HomeFileViewController
         let home: UINavigationController = UINavigationController(rootViewController: homeViewController)
        let slideMenuController = SlideMenuController(mainViewController: home, leftMenuViewController: more)
       
       // leftViewController.mainVC = nvc
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.hideStatusBar = false;
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        /*
         let tabBarController = UITabBarController()
         let  tabBarHeight = tabBarController.tabBar.frame.size.height
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let homeViewController = story.instantiateViewController(withIdentifier: "HomeFileViewController") as! HomeFileViewController
        print("tab bar height ===:",tabBarHeight)
        homeViewController.title = "HOME"
        homeViewController.tabBarItem.image = UIImage(named: "folder-gray")
        homeViewController.tabBarItem.selectedImage = UIImage(named: "folder")
        
        let nav1 = UINavigationController(rootViewController: homeViewController)
        let searchViewController  =  story.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        searchViewController.title = "SEARCH"
        searchViewController.tabBarItem.image = UIImage(named: "search-gray")
        searchViewController.tabBarItem.selectedImage = UIImage(named: "search")
        let nav2 = UINavigationController(rootViewController: searchViewController)
        let playViewController  =  story.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
        playViewController.title = "PLAY"
        playViewController.tabBarItem.image = UIImage(named: "play-gray")
        playViewController.tabBarItem.selectedImage = UIImage(named: "play")
    
        
        let nav3 = UINavigationController(rootViewController: playViewController)
        
        let moreViewController  =  story.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        moreViewController.title = "MORE"
        moreViewController.tabBarItem.image = UIImage(named: "more-gray")
        moreViewController.tabBarItem.selectedImage = UIImage(named: "more")
        let nav4 = UINavigationController(rootViewController: moreViewController)
        
        let myViewControllers = [nav1, nav2, nav3,nav4]
        
        //set the view controllers for the tab bar controller
        tabBarController.viewControllers = myViewControllers
        tabBarController.selectedIndex = getIndex
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        */
        // Do any additional setup after loading the view.
     }
    
    func showLoader(){
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.center = (self.window?.center)!
        self.window?.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    func hideLoader(){
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "StudyWeaklyApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

