//
//  FaceViewModel.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/26.
//

import Combine
import Foundation

class FaceViewModel: ObservableObject {
    
    @Published var model: BaseModel?
    
    @Published var errorMsg: String?
    
    @Published var pModel: BaseModel?
    
    @Published var saveModel: BaseModel?
    
    func getAuthIDInfo(parameters: [String: Any]) {
        
        Task {
            do {
                model = try await FaceService.getAuthIDInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
    func uploadRearInfo(parameters: [String: Any], imageData: Data) {
        
        Task {
            do {
                pModel = try await FaceService.uploadRearInfo(parameters: parameters,
                                                             imageData: imageData)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
    func saveAuthIDInfo(parameters: [String: Any]) {
        
        Task {
            do {
                saveModel = try await FaceService.saveAuthIDInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
    }
    
}
