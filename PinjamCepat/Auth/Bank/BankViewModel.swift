//
//  WorkViewModel.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/26.
//

import Combine
import Foundation

class BankViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var saveModel: BaseModel?
    
    @Published var errorMsg: String?
    
    func listInfo(parameters: [String: Any]) {
        
        Task {
            do {
                model = try await BankSerVice.listInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
    func saveListInfo(parameters: [String: Any]) {
        
        Task {
            do {
                saveModel = try await BankSerVice.saveListInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
}
