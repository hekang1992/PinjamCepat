//
//  AppNetworkConfig.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit

class AppNetworkConfig: NSObject {
    
    static let shared = AppNetworkConfig()
    
    private override init() {}
    
    func saveNetworkType(type: String) {
        UserDefaults.standard.set(type, forKey: "pc_network_type")
        UserDefaults.standard.synchronize()
    }
    
    func getNetworkType() -> String {
        let networkType = UserDefaults.standard.string(forKey: "pc_network_type") ?? ""
        return networkType
    }
    
}
