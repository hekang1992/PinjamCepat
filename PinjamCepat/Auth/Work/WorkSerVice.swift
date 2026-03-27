//
//  WorkSerVice.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/26.
//

class WorkSerVice {
    
    static func listInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.post(
            url: "/physicianer/pure",
            parameters: parameters
        )
        
        return result
    }
    
    static func saveListInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.post(
            url: "/physicianer/foolish",
            parameters: parameters
        )
        
        return result
    }
    
}
