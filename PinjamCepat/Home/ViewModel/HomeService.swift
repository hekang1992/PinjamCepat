//
//  HomeService.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

class HomeService {
    
    static func homeInfo() async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.get(
            url: "/physicianer/gloves"
        )
        
        return result
    }
    
    static func clickProductInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.post(
            url: "/physicianer/handle",
            parameters: parameters
        )
        
        return result
    }
    
    static func uploadLocationInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        let result: BaseModel = try await NetworkManager.shared.post(
            url: "/physicianer/gratitude",
            parameters: parameters
        )
        
        return result
    }
    
    static func uploadAppInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        let result: BaseModel = try await NetworkManager.shared.post(
            url: "/physicianer/holy",
            parameters: parameters
        )
        
        return result
    }
    
}
