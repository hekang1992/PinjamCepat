//
//  NetworkEnvManager.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import Foundation
import CFNetwork

final class NetworkEnvManager {
    
    static let shared = NetworkEnvManager()
    private init() {}
    
    func getSystemLanguage() -> String {
        return Locale.current.identifier
    }
    
    func isUsingProxy() -> Int {
        guard let proxySettings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any] else {
            return 0
        }
        
        if let httpEnable = proxySettings[kCFNetworkProxiesHTTPEnable as String] as? Int,
           httpEnable == 1 {
            return 1
        }
        
        if let httpProxy = proxySettings[kCFNetworkProxiesHTTPProxy as String] as? String,
           !httpProxy.isEmpty {
            return 1
        }
        
        if let port = proxySettings[kCFNetworkProxiesHTTPPort as String] as? Int,
           port != 0 {
            return 1
        }
        
        return 0
    }
    
    func isUsingVPN() -> Int {
        guard let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
              let scopes = settings["__SCOPED__"] as? [String: Any] else {
            return 0
        }
        
        for key in scopes.keys {
            if key.contains("tap") ||
                key.contains("tun") ||
                key.contains("ppp") ||
                key.contains("ipsec") ||
                key.contains("utun") {
                return 1
            }
        }
        return 0
    }
    
    func getAllInfo() -> [String: Any] {
        return [
            "thereof": getSystemLanguage(),
            "notice": isUsingProxy(),
            "angel": isUsingVPN()
        ]
    }
}
