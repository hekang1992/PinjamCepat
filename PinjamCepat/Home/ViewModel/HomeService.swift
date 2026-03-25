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
    
}
