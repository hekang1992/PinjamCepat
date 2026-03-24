//
//  BaseTabBarController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabs()
        setupTabBarAppearance()
    }
    
    private func setupTabs() {
        
        let homeVC = HomeViewController()
        let homeNav = BaseNavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "en_home_tab_nor_image")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "en_home_tab_sel_image")?.withRenderingMode(.alwaysOriginal)
        )
        
        let orderVC = OrderViewController()
        let orderNav = BaseNavigationController(rootViewController: orderVC)
        orderNav.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "en_order_tab_nor_image")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "en_order_tab_sel_image")?.withRenderingMode(.alwaysOriginal)
        )
        
        let centerVC = CenterViewController()
        let centerNav = BaseNavigationController(rootViewController: centerVC)
        centerNav.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "en_center_tab_nor_image")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "en_center_tab_sel_image")?.withRenderingMode(.alwaysOriginal)
        )
        
        viewControllers = [homeNav, orderNav, centerNav]
    }
    
    private func setupTabBarAppearance() {
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 100)
        
        UITabBarItem.appearance().imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
}

extension BaseTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
}
