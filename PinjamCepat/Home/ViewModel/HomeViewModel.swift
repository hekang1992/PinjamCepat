//
//  HomeViewModel.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var homeModel: BaseModel?
    
    @Published var errorMsg: String?
    
    func homeInfo() {
        Task {
            do {
                homeModel = try await HomeService.homeInfo()
            } catch {
                errorMsg = error.localizedDescription
            }
        }
    }
    
}
