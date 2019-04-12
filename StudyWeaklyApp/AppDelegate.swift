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
import UserNotifications
import IQKeyboardManagerSwift

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate
{
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    var wifiDataArr = [AnyObject]()
    var window: UIWindow?
    
    //MARK: - Life Cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        let getUserID =  NetworkAPI.userID()
        if getUserID != nil
        {
             createTabbarMethod(getIndex: 0)
        }
        else
        {
         }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        getWiFiOnMethod()
    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    //MARK: - RootView Method
    func rootViewCallMethod(getAlertTitle: String)
    {
        print("btn sessionExpired here")
        if getAlertTitle == "sessionExpired"
        {
            CDBManager().deleteAllCDB()
            NetworkAPI.removeUserId()
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController  =  story.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let rooNav = UINavigationController(rootViewController: viewController)
            self.window?.rootViewController = rooNav
            self.window?.makeKeyAndVisible()
        }
    }
    
    func  createTabbarMethod(getIndex: Int)
    {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let homeViewController = story.instantiateViewController(withIdentifier: "HomeFileViewController") as! HomeFileViewController
         let home: UINavigationController = UINavigationController(rootViewController: homeViewController)
        self.window?.rootViewController = home
        self.window?.makeKeyAndVisible()
     }
    
    func showLoader()
    {
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.center = (self.window?.center)!
        self.window?.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    func hideLoader()
    {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    
    func getWiFiOnMethod()
    {
        wifiDataArr = CDBManager().fetchSwitchOnMethod()
    }
    
    //MARK: - Notification Method
    func notificationActiveMethod()
    {
        if #available(iOS 10.0, *)
        {
            // SETUP FOR NOTIFICATION FOR iOS >= 10.0
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil
                {
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
            }
        }
        else
        {
            // SETUP FOR NOTIFICATION FOR iOS < 10.0
            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            // Success = didRegisterForRemoteNotificationsWithDeviceToken
            // Fail = didFailToRegisterForRemoteNotificationsWithError
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func notificationDeactiveMethod()
    {
        DispatchQueue.main.async(execute: {
           UIApplication.shared.unregisterForRemoteNotifications()
        })
    }
    
    // ...............Delegate method of user notification .......................
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        // ...register device token with our Time Entry API server via REST
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        //print("DidFaildRegistration : Device token for push notifications: FAIL -- ")
        //print(error.localizedDescription)
    }
    

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer =
        {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "StudyWeaklyApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?
            {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext ()
    {
        let context = persistentContainer.viewContext
        if context.hasChanges
        {
            do
            {
                try context.save()
            }
            catch
            {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

