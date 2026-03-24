//
//  LaunchService.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

class LaunchService {
    
    static func launchInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.get(
            url: "/physicianer/thereof",
            parameters: parameters
        )
        
        return result
    }
    
    
}
