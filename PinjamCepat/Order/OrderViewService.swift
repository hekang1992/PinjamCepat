//
//  OrderViewService.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/27.
//

class OrderViewService {
    
    static func orderListInfo(parameters: [String: Any]) async throws -> BaseModel? {
        
        LoadingManager.shared.show()
        
        defer {
            LoadingManager.shared.hide()
        }
        
        let result: BaseModel = try await NetworkManager.shared.post(
            url: "/physicianer/intending",
            parameters: parameters
        )
        
        return result
    }
}
