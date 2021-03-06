//
//  AppDelegate.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        AppearanceManager.applyNavigationBarFix()
        AppearanceManager.hideListSeparators()
        AppearanceManager.setTableViewBackgroundColor()
        AppearanceManager.setTableViewCellBackgroundColor()
        
        PreferencesManager.shared.loadPreferences(usingDataManager: DataManager.shared)
        CountersManager.shared.initFromDisk(usingManager: DataManager.shared)
        CountersManager.shared.registerSaveObservers()
        
        #if DEBUG
        if CountersManager.shared.getCountersNames().isEmpty {
            _ = CountersManager.shared.add(counters: CountersManager.exampleArray)
        }
        debugPrint("DEBUG")
        #endif
        
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

