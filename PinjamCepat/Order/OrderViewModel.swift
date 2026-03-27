//
//  OrderViewModel.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/27.
//

import Combine
import Foundation

class OrderViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    func orderListInfo(parameters: [String: Any]) {
        Task {
            do {
                model = try await OrderViewService.orderListInfo(parameters: parameters)
            } catch  {
                errorMsg = error.localizedDescription
            }
        }
    }
}
