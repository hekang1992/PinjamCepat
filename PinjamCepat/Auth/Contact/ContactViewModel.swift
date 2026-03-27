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
                model = try await ContactSerVice.listInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
    func saveListInfo(parameters: [String: Any]) {
        
        Task {
            do {
                saveModel = try await ContactSerVice.saveListInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
    func uploadListInfo(parameters: [String: Any]) {
        
        Task {
            do {
                _ = try await ContactSerVice.uploadListInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
}
