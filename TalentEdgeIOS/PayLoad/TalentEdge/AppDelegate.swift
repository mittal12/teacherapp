//
//  AppDelegate.swift
//  TalentEdge
//
//

import UIKit
import QuartzCore
import AVKit
import UserNotifications
import CoreData

import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

              Fabric.with([Crashlytics.self])

        let options: UNAuthorizationOptions = [.alert, .sound];
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
//        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound, categories: nil)
//        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
//        UIApplication.sharedApplication().registerForRemoteNotifications()

        if UserDefaults.standard.value(forKey: "isTourViewSeen") != nil {
            if UserDefaults.standard.value(forKey: "isTourViewSeen") as? Bool == true {
                let sideMenuController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let navC = UINavigationController(rootViewController: sideMenuController)
                APPDELEGATE.window?.rootViewController = navC
                APPDELEGATE.window?.makeKeyAndVisible()
            }
        }
        
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        Swift.debugPrint()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        let deviceTokenString = deviceToken.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        TechUserDefault.singleton.setDeviceToken(deviceTokenString)
        print(deviceTokenString)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's mtraveanaged object context before the application terminates.
        saveContext()
    }
    
    func showAlertAppDelegate(_ title : String,message : String,buttonTitle : String,window: UIWindow){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TalentEdge")
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

