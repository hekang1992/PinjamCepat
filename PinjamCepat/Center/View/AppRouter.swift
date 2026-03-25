//
//  AppRouter.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import UIKit

class AppRouter {
    
    static func open(_ urlString: String, from sourceVC: BaseViewController) {
        
        guard let components = URLComponents(string: urlString) else {
            return
        }
        
        let path = components.path
        let host = components.host
        
        var params: [String: String] = [:]
        components.queryItems?.forEach {
            params[$0.name] = $0.value
        }
        
        handle(path: path, host: host, params: params, sourceVC: sourceVC)
    }
    
    private static func handle(path: String, host: String?, params: [String: String], sourceVC: BaseViewController) {
        
        switch path {
            
        case "/prynne":
            let vc = SettingsViewController()
            vc.name = "Set Up".localized
            sourceVC.navigationController?.pushViewController(vc, animated: true)
            
        case "/and":
            let vc = ProductViewController()
            vc.productID = params["despondency"] ?? ""
            sourceVC.navigationController?.pushViewController(vc, animated: true)
            
        case "/you":
            self.switchRootVc()
            
        default:
            break
        }
    }
}

extension AppRouter {
    
    static func switchRootVc() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first(where: { $0.isKeyWindow }) else { return }
        
        let tabBarController = BaseTabBarController()
        
        UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve) {
            window.rootViewController = tabBarController
        }
    }
    
}
