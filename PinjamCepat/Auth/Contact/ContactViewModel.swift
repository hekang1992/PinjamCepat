//
//  ContactViewModel.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/26.
//

import Combine
import Foundation

class ContactViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var saveModel: BaseModel?
    
    @Published var errorMsg: String?
    
    func listInfo(parameters: [String: Any]) {
        
        Task {
            do {
                model = try await WorkSerVice.listInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
    func saveListInfo(parameters: [String: Any]) {
        
        Task {
            do {
                saveModel = try await WorkSerVice.saveListInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
    func uploadListInfo(parameters: [String: Any]) {
        
        Task {
            do {
                _ = try await WorkSerVice.uploadListInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
}
