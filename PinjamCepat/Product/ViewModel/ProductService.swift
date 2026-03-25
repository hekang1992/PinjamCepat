//
//  ProductService.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

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
}
