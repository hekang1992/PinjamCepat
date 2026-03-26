//
//  FaceService.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/26.
//

import Foundation

class FaceService {
    
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
    
    static func uploadRearInfo(parameters: [String: Any], imageData: Data) async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.uploadImage(
            url: "/physicianer/remembrance",
            imageData: imageData,
            parameters: parameters
        )
        
        return result
    }
    
}
