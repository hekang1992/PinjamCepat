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
        
        addSwitchObserver()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AppLaunchViewController()
        window?.makeKeyAndVisible()
        return true
    }

}

extension AppDelegate {
    
    private func addSwitchObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(switchRootVc), name: NSNotification.Name("switch_RootVc"), object: nil)
    }
    
    @objc func switchRootVc() {
        window?.rootViewController = BaseTabBarController()
    }
    
}
