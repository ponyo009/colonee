//
//  AppDelegate.swift
//  gamies.com
//
//  Created by hanakawa kazuya on 2019/03/09.
//  Copyright © 2019 hanakawa kazuya. All rights reserved.
//

import UIKit
import NCMB

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let applicationkey = "6592f551af5bd3d036a6d2e256c3f355ee613b1fb786b16c6cd61fffdcc24fdf"
    let clientkey      = "a1718a69a8664ce4cbefc668d1a3017915ab1a923f4c98dd82231d400c5fd101"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NCMB.setApplicationKey(applicationkey, clientKey: clientkey)
        // Override point for customization after application launch.
        //▼▼▼起動時に処理される▼▼▼
        let obj = NCMBObject(className: "TestClass")
        obj?.setObject("Hello, NCMB!", forKey: "message")
        obj?.saveInBackground({ (error) in
            if error != nil {
                // 保存に失敗した場合の処理
            }else{
                // 保存に成功した場合の処理
            }
        })
        //▲▲▲起動時に処理される▲▲▲
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


}

