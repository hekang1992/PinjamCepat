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
            vc.name = "Product Details".localized
            sourceVC.navigationController?.pushViewController(vc, animated: true)
            
        case "/you":
            self.switchRootVc()
            
        case "/the":
            break
            
        case "/with":
            break
            
        default:
            break
        }
    }
}

extension AppRouter {
    
    static func switchRootVc() {
        NotificationCenter.default.post(name: NSNotification.Name("switch_RootVc"), object: nil)
    }
    
}
