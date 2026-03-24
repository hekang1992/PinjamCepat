//
//  ViewModel.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import Combine
import Foundation

class LaunchViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    func appLaunchInfo(parameters: [String: Any]) {
        
        Task {
            do {
                model = try await LaunchService.launchInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
}
