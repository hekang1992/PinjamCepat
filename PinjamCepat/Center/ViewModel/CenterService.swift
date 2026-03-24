//
//  CenterService.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

class CenterService {
    
    static func centerInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.get(
            url: "/physicianer/doers",
            parameters: parameters
        )
        
        return result
    }
    
}
