//
//  ContactSerVice.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/26.
//

class ContactSerVice {
    
    static func listInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.post(
            url: "/physicianer/blind",
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
            url: "/physicianer/reverence",
            parameters: parameters
        )
        
        return result
    }
    
}
