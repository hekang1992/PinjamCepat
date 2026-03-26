//
//  PersonalSerVice.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/26.
//

class PersonalSerVice {
    
    static func listInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.post(
            url: "/physicianer/gravely",
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
            url: "/physicianer/thank",
            parameters: parameters
        )
        
        return result
    }
    
}
