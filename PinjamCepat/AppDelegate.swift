//
//  AppDelegate.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AppLaunchViewController()
        window?.makeKeyAndVisible()
        return true
    }

}

