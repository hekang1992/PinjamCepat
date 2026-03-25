//
//  ProductViewModel.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    @Published var idModel: BaseModel?
    
    func getProductDetailInfo(parameters: [String: Any]) {
        
        Task {
            do {
                model = try await ProductService.getProductDetailInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
    func getAuthIDInfo(parameters: [String: Any]) {
        
        Task {
            do {
                idModel = try await ProductService.getAuthIDInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
}
