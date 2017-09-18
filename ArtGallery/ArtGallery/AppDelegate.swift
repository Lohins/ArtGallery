//  AppDelegate.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-21.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //setupSlideNavController()
        
        setupRootviewController()
        
        return true
    }
    
    func setupRootviewController(){
        
        let welcomeVC = AGWelcomeViewController()
        
        _ = SlideNavigationController.init(rootViewController: welcomeVC)
                
        SlideNavigationController.sharedInstance().leftMenu = AGLeftMenuViewController.sharedInstance
        
        SlideNavigationController.sharedInstance().portraitSlideOffset = CGFloat( 0.25 ) * GlobalValue.SCREENBOUND.width
        
        window?.rootViewController = SlideNavigationController.sharedInstance()
    
    }
    
//    // 初始化 Slide Nav Controller
//    func setupSlideNavController(){
//        //let vc = AGIArtistFieldSelectViewController()
//        let welcomeVC = AGWelcomeViewController()
//        _ = SlideNavigationController.init(rootViewController: welcomeVC)
//
//        let leftMenuVC = AGLeftMenuViewController()
//       
//        SlideNavigationController.sharedInstance().leftMenu = leftMenuVC
//        
//        SlideNavigationController.sharedInstance().portraitSlideOffset = CGFloat( 0.25 ) * GlobalValue.SCREENBOUND.width
//        window?.rootViewController = SlideNavigationController.sharedInstance()
//    }
    
    

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


}

