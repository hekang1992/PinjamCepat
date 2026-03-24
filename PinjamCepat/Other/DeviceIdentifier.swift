//
//  DeviceIdentifier.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import AdSupport
import AppTrackingTransparency

class DeviceIdentifier {
    
    static func getIDFA() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    static func getIDFV() -> String {
        let service = "com.PinjamCepat.bundle.id"
        let account = "idfv"
        
        if let idfv = KeychainHelper.load(service: service, account: account) {
            return idfv
        }
        
        let idfv = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        
        let _ = KeychainHelper.save(value: idfv, service: service, account: account)
        
        return idfv
    }
    
}

class KeychainHelper {
    
    static func save(value: String, service: String, account: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    static func load(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
    }
    
}
