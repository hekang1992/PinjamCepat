//
//  LoginManager.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import Foundation

class LoginManager {
    
    static let shared = LoginManager()
    
    private init() {}
    
    private let phoneKey = "pc_user_phone"
    
    private let tokenKey = "pc_user_token"
    
    func saveLogin(phone: String, token: String) {
        UserDefaults.standard.set(phone, forKey: phoneKey)
        UserDefaults.standard.set(token, forKey: tokenKey)
        UserDefaults.standard.synchronize()
    }
    
    func getPhone() -> String? {
        return UserDefaults.standard.string(forKey: phoneKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func isLoggedIn() -> Bool {
        guard let token = getToken(), !token.isEmpty else {
            return false
        }
        return true
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: phoneKey)
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.synchronize()
    }
}
