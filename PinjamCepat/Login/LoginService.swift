//
//  LoginService.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

class LoginService {
    
    static func codeInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.post(
            url: "/physicianer/notice",
            parameters: parameters
        )
        
        return result
    }
    
    static func loginInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.post(
            url: "/physicianer/portent",
            parameters: parameters
        )
        
        return result
    }
    
}
