//
//  LoginViewModel.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    @Published var codeModel: BaseModel?
    
    @Published var loginModel: BaseModel?
    
    @Published var errorMsg: String?
    
    func codeInfo(parameters: [String: Any]) {
        
        Task {
            do {
                codeModel = try await LoginService.codeInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
    func loginInfo(parameters: [String: Any]) {
        
        Task {
            do {
                loginModel = try await LoginService.loginInfo(parameters: parameters)
            } catch {
                errorMsg = error.localizedDescription
            }
        }
        
    }
    
}
