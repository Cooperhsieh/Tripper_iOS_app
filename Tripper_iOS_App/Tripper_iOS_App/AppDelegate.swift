//
//  AppDelegate.swift
//  Tripper_iOS_App
//
//  Created by Cooper on 2020/10/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //設定 Tabbar 選中顏色
        
     
        
        UITabBar.appearance().tintColor =  #colorLiteral(red: 0, green: 0.6745098039, blue: 0.7568627451, alpha: 1) //(0,172,193)
        UIBarButtonItem.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       
            
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

