//
//  AppDelegate.swift
//  ShrinkMeister
//
//  Created by Jackie Zhang on 16/8/2.
//  Copyright © 2016年 Jackie Zhang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var viewLocator : ViewLocator!
    static var viewModelLocator : ViewModelLocator!
    
    var navigationController : UINavigationController!
    
    var mainViewModel : MainViewModel!
    var mainViewController : MainViewController!
    
    static var viewService : ViewControllerService!
    
    static var imageStore = ImageStore()
    
    static let launchScreenBackColor = UIColor(red: 26.0/255.0, green: 118.0/255.0, blue: 235.0/255.0, alpha: 1.0)

    
    static let collectionBackColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        AppDelegate.viewLocator = ViewLocator()
        
        AppDelegate.viewModelLocator = ViewModelLocator()
        
        let navigationController = AppDelegate.viewLocator.getView("Navigation") as! UINavigationController
        AppDelegate.viewService = ViewControllerServicesImp(navigationController: navigationController)
        
        mainViewModel = AppDelegate.viewModelLocator.getViewModel("Main") as! MainViewModel
        mainViewController = AppDelegate.viewLocator.getView("Main") as! MainViewController
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let launchViewController = LaunchScreenViewController()
        
        window!.rootViewController = launchViewController
        window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

