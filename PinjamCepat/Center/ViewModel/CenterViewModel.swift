
//
//  CenterViewModel.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import Foundation
import Combine

class CenterViewModel {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    func centerInfo(parameters: [String: Any]) {
        Task {
            do {
                model = try await CenterService.centerInfo(parameters: parameters)
            } catch  {
                errorMsg = error.localizedDescription
            }
        }
    }
    
    func logoutInfo(parameters: [String: Any]) {
        Task {
            do {
                model = try await CenterService.logoutInfo(parameters: parameters)
            } catch  {
                errorMsg = error.localizedDescription
            }
        }
    }
    
    func deleteInfo(parameters: [String: Any]) {
        Task {
            do {
                model = try await CenterService.deleteInfo(parameters: parameters)
            } catch  {
                errorMsg = error.localizedDescription
            }
        }
    }
    
}
