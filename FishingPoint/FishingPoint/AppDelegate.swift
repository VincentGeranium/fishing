//
//  AppDelegate.swift
//  FishingPoint
//
//  Created by Fury on 24/05/2019.
//  Copyright © 2019 Fury. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
        FirebaseApp.configure()
        
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }
}
