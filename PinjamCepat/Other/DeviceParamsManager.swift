//
//  DeviceParamsManager.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import AdSupport

class DeviceParamsManager {
    
    static func getAllDeviceParams() -> [String: String] {
        var params: [String: String] = [:]
        params["riser"] = getAppVersion()
        params["rouse"] = getDeviceModel()
        params["begin"] = getIDFV()
        params["neighbourhood"] = getOSVersion()
        params["able"] = "sessionId"
        params["doubted"] = getIDFA()
        params["handle"] = "1"
        return params
    }
    
    static func buildURL(baseURL: String, params: [String: String]) -> String {
        let separator = baseURL.contains("?") ? "&" : "?"
        
        let paramString = params.compactMap { (key, value) -> String? in
            guard !value.isEmpty else { return nil }
            guard let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return nil
            }
            return "\(key)=\(encodedValue)"
        }.joined(separator: "&")
        
        guard !paramString.isEmpty else {
            return baseURL
        }
        
        return "\(baseURL)\(separator)\(paramString)"
    }
    
    static func getURLWithParams(baseURL: String) -> String {
        let params = getAllDeviceParams()
        return buildURL(baseURL: baseURL, params: params)
    }
    
    private static func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    private static func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    private static func getIDFV() -> String {
        return DeviceIdentifier.getIDFV()
    }
    
    private static func getOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    private static func getIDFA() -> String {
        return DeviceIdentifier.getIDFA()
    }
}
