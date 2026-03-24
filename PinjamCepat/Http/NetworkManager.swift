//
//  NetworkManager.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    private let base_url = "http://149.129.194.71/uponer"
    
    static let shared = NetworkManager()
    
    private let shortSession: Session
    
    private let longSession: Session
    
    private init() {
        let shortConfig = URLSessionConfiguration.default
        shortConfig.timeoutIntervalForRequest = 30
        shortConfig.timeoutIntervalForResource = 30
        shortSession = Session(configuration: shortConfig)
        
        let longConfig = URLSessionConfiguration.default
        longConfig.timeoutIntervalForRequest = 60
        longConfig.timeoutIntervalForResource = 60
        longSession = Session(configuration: longConfig)
    }
    
    func get<T: Decodable>(
        url: String,
        parameters: [String: Any]? = nil
    ) async throws -> T {
        
        let apiUrl = DeviceParamsManager.getURLWithParams(baseURL: base_url + url)
        
        let request = shortSession.request(
            apiUrl,
            method: .get,
            parameters: parameters
        )
            .validate()
            .serializingDecodable(T.self)
        
        let response = await request.response
        
        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
    // MARK: - POST multipart
    func post<T: Decodable>(
        url: String,
        parameters: [String: Any]
    ) async throws -> T {
        
        let apiUrl = DeviceParamsManager.getURLWithParams(baseURL: base_url + url)
        
        let request = longSession.upload(
            multipartFormData: { formData in
                for (k, v) in parameters {
                    formData.append("\(v)".data(using: .utf8)!, withName: k)
                }
            },
            to: apiUrl
        )
            .validate()
            .serializingDecodable(T.self)
        
        let response = await request.response
        
        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
    
    // MARK: - upload image
    func uploadImage<T: Decodable>(
        url: String,
        imageData: Data,
        parameters: [String: Any]? = nil,
        imageKey: String = "tookTo"
    ) async throws -> T {
        
        let apiUrl = DeviceParamsManager.getURLWithParams(baseURL: base_url + url)
        
        let request = longSession.upload(
            multipartFormData: { formData in
                
                formData.append(
                    imageData,
                    withName: imageKey,
                    fileName: "image.jpg",
                    mimeType: "image/jpeg"
                )
                
                parameters?.forEach {
                    formData.append("\($1)".data(using: .utf8)!, withName: $0)
                }
            },
            to: apiUrl
        )
            .validate()
            .serializingDecodable(T.self)
        
        let response = await request.response
        
        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
