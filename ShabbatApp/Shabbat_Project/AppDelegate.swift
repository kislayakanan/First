//
//  AppDelegate.swift
//  Shabbat_Project
//
//  Created by WebAstral on 4/18/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//   AIzaSyCKTNNGIzupp6xgASONOxK85gR-FJbYFso

import UIKit
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?
   var centerContainer: MMDrawerController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        sleep(3)
        
        //IQKeyboardManager.sharedManager().enable = true
        
        GMSServices.provideAPIKey("AIzaSyCKTNNGIzupp6xgASONOxK85gR-FJbYFso")
        Parse.setApplicationId("TvJSpzpJOad54k6aTyy26cz7ev3rZfTQkJFdDdZh", clientKey: "qzUhlxGR3OJ6JV3b0er3MRpAiAqztrrgIpA7IFzZ")
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        
        let mainScreen = mainStoryboard.instantiateViewControllerWithIdentifier("MainScreenVC") as! MainScreenVC
        
        let hostController = mainStoryboard.instantiateViewControllerWithIdentifier("leftSideDrawerViewController") as! leftSideDrawerViewController
        
        
        let mapController = mainStoryboard.instantiateViewControllerWithIdentifier("RightDrawerVC") as! RightDrawerVC
        
        
        //let seekController = mainStoryboard.instantiateViewControllerWithIdentifier("SeekVC") as! SeekVC
        
        
        
        let hostNav = UINavigationController(rootViewController: hostController)
        let mapNav = UINavigationController(rootViewController: mapController)
        
        
        let centerNav = UINavigationController(rootViewController: mainScreen)
        //var seekNav = UINavigationController(rootViewController: seekController)
        
        centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: hostNav,rightDrawerViewController: mapNav)//rightDrawerViewController:seekNav)
        
        //centerContainer = MMDrawerController(centerViewController: centerNav, RightDrawerVC: mapNav)
        
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView;
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView;
        
        centerContainer!.maximumLeftDrawerWidth = (window?.frame.width)!/2 + 40
        centerContainer!.maximumRightDrawerWidth = (window?.frame.width)!/2 + 40
        window!.rootViewController = centerContainer

        
        return true
//        let userNotificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
//        
//        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
//        application.registerUserNotificationSettings(settings)
//        application.registerForRemoteNotifications()
//        
//      
//        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        
    }

    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       
//        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
//        loginManager.logOut()
        
        
        
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
  
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        if error.code == 3010
        {
            print("Push notifications are not supported in the iOS Simulator.")
        }
        else
        {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        PFPush.handlePush(userInfo)
    }
    
    

}

