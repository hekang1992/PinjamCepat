//
//  ProductService.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import Foundation

class ProductService {
    
    static func getProductDetailInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.post(
            url: "/physicianer/steal",
            parameters: parameters
        )
        
        return result
    }
    
    static func getAuthIDInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.post(
            url: "/physicianer/seems",
            parameters: parameters
        )
        
        return result
    }
    
    static func orderIDInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.post(
            url: "/physicianer/scurrilous",
            parameters: parameters
        )
        
        return result
    }
    
    static func trackInfo(parameters: [String: String]) async throws -> BaseModel? {
        
        let withdrew = "2"
        let elvish = DeviceIdentifier.getIDFV()
        let frequently = DeviceIdentifier.getIDFA()
        let moon = UserDefaults.standard.string(forKey: "app_longitude") ?? ""
        let revelations = UserDefaults.standard.string(forKey: "app_latitude") ?? ""
        let glanced = String(Int(Date().timeIntervalSince1970))
        
        var paras = ["withdrew": withdrew,
                     "elvish": elvish,
                     "frequently": frequently,
                     "moon": moon,
                     "revelations": revelations,
                     "glanced": glanced]
        
        paras.merge(parameters) { current, _ in current }
        
        let result: BaseModel = try await NetworkManager.shared.post(
            url: "/physicianer/glove",
            parameters: paras
        )
        
        return result
    }
    
}
