//  FurnitureApp
//
//  Copyright © 2020 Talha Asif. All rights reserved.
//


import UIKit
import IntentKit
import Intents
import IQKeyboardManagerSwift
import os.log
import Firebase
import FirebaseFirestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController:UINavigationController!

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        if Auth.auth().currentUser != nil {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

           

             let tabBarVC = UITabBarController()
             
             let homeBarVC = storyboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
            homeBarVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), selectedImage: nil)
                             
             let inboxBarVC = storyboard.instantiateViewController(withIdentifier: "Inbox") as! InboxBarViewController
                 inboxBarVC.tabBarItem = UITabBarItem(title: "Inbox", image: UIImage(systemName: "envelope"), selectedImage: nil)

             let arkitVC = storyboard.instantiateViewController(withIdentifier: "AR") as! MainViewController
                 arkitVC.tabBarItem = UITabBarItem(title: "AR View", image: UIImage(systemName: "arkit"), selectedImage: nil)
            
                                 
             let dashboardVC = storyboard.instantiateViewController(withIdentifier: "Dashboard") as! FurnitureListView
                 dashboardVC.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "list.dash"), selectedImage: nil)
            
            let profileVC = storyboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
                   profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), selectedImage: nil)
            
            
                             
                             
                             
            let controllers = [homeBarVC,dashboardVC, inboxBarVC,arkitVC, profileVC]
            tabBarVC.viewControllers = controllers
            
//            tabBarVC.tabBar.isTranslucent = false

            tabBarVC.tabBar.barTintColor = UIColor(red: 44/255, green: 46/255, blue: 47/255, alpha: 1)
            
            tabBarVC.tabBar.tintColor = UIColor(red: 234/255, green: 174/255, blue: 47/255, alpha: 1)
            
            self.navigationController = UINavigationController.init(rootViewController:tabBarVC)
            
            self.navigationController.navigationBar.barTintColor = UIColor(red: 44/255, green: 46/255, blue: 47/255, alpha: 1)
            
            UINavigationBar.appearance().tintColor = UIColor(red: 234/255, green: 174/255, blue: 47/255, alpha: 1)
            window?.rootViewController = self.navigationController
                window?.makeKeyAndVisible()
        }
        return true
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
    }

//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//
//        os_log("TK421: Continue type = %{public}s", userActivity.activityType)
//        guard userActivity.activityType == NSUserActivity.orderBeerActivityType else{
//            os_log("TK421: Can't continue unknown NSUserActivity type = %{public}s", userActivity.activityType)
//            return false
//        }
//
//
//        guard let window = window,
//            let rootViewController = window.rootViewController as? UINavigationController else {
//
//                os_log("TK421: Failed to access root view controller.")
//                return false
//        }
//
//        restorationHandler(rootViewController.viewControllers)
//
//        return true
//    }

}

