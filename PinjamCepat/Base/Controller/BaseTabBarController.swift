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
        if #available(iOS 26.0, *) {
            self.tabBar.backgroundColor = .clear
        } else {
            self.tabBar.backgroundColor = .white
        }
    }
    
    private func setupTabs() {
        let scale: CGFloat = 0.88
        let verticalOffset: CGFloat = 5
        
        let homeVC = HomeViewController()
        let homeNav = BaseNavigationController(rootViewController: homeVC)
        let homeImage = UIImage(named: "en_home_tab_nor_image".localized)?
            .resized(by: scale)?
            .withRenderingMode(.alwaysOriginal)
        let homeSelectedImage = UIImage(named: "en_home_tab_sel_image".localized)?
            .resized(by: scale)?
            .withRenderingMode(.alwaysOriginal)
        homeNav.tabBarItem = UITabBarItem(
            title: nil,
            image: homeImage,
            selectedImage: homeSelectedImage
        )
        homeNav.tabBarItem.imageInsets = UIEdgeInsets(top: verticalOffset, left: 0, bottom: -verticalOffset, right: 0)
        
        let orderVC = OrderViewController()
        let orderNav = BaseNavigationController(rootViewController: orderVC)
        let orderImage = UIImage(named: "en_order_tab_nor_image".localized)?
            .resized(by: scale)?
            .withRenderingMode(.alwaysOriginal)
        let orderSelectedImage = UIImage(named: "en_order_tab_sel_image".localized)?
            .resized(by: scale)?
            .withRenderingMode(.alwaysOriginal)
        orderNav.tabBarItem = UITabBarItem(
            title: nil,
            image: orderImage,
            selectedImage: orderSelectedImage
        )
        orderNav.tabBarItem.imageInsets = UIEdgeInsets(top: verticalOffset, left: 0, bottom: -verticalOffset, right: 0)
        
        let centerVC = CenterViewController()
        let centerNav = BaseNavigationController(rootViewController: centerVC)
        let centerImage = UIImage(named: "en_center_tab_nor_image".localized)?
            .resized(by: scale)?
            .withRenderingMode(.alwaysOriginal)
        let centerSelectedImage = UIImage(named: "en_center_tab_sel_image".localized)?
            .resized(by: scale)?
            .withRenderingMode(.alwaysOriginal)
        centerNav.tabBarItem = UITabBarItem(
            title: nil,
            image: centerImage,
            selectedImage: centerSelectedImage
        )
        centerNav.tabBarItem.imageInsets = UIEdgeInsets(top: verticalOffset, left: 0, bottom: -verticalOffset, right: 0)
        
        viewControllers = [homeNav, orderNav, centerNav]
    }
    
}

extension BaseTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard LoginManager.shared.isLoggedIn() else {
            toLoginVc()
            return false
        }
        return true
    }
    
    private func toLoginVc() {
        let loginVc = BaseNavigationController(rootViewController: LoginViewController())
        loginVc.modalPresentationStyle = .overFullScreen
        self.present(loginVc, animated: true)
    }
}

extension UIImage {
    func resized(by scale: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
