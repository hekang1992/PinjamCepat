//
//  DeviceInfo.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/27.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import AdSupport
import AppTrackingTransparency
import NetworkExtension
import MachO

class DeviceInfo {
    
    static func getAllInfo(completion: @escaping ([String: Any]) -> Void) {
        
        getWifiInfo { wifiDict in
            
            var result: [String: Any] = [:]
            
            result["belong"] = getStorageAndMemory()
            
            result["noon"] = getBatteryInfo()
            
            result["connecting"] = getDeviceInfo()
            
            result["market"] = getSecurityInfo()
            
            result["springing"] = getSystemInfo()
            
            result["quaint"] = [
                "stories": wifiDict ?? [:]
            ]
            
            completion(result)
        }
    }
}

extension DeviceInfo {
    
    static func getStorageAndMemory() -> [String: Any] {
        
        let fileManager = FileManager.default
        let home = NSHomeDirectory()
        
        var freeDisk: Int64 = 0
        var totalDisk: Int64 = 0
        
        if let attr = try? fileManager.attributesOfFileSystem(forPath: home) {
            freeDisk = (attr[.systemFreeSize] as? NSNumber)?.int64Value ?? 0
            totalDisk = (attr[.systemSize] as? NSNumber)?.int64Value ?? 0
        }
        
        let totalMemory = ProcessInfo.processInfo.physicalMemory
        let freeMemory = getFreeMemory()
        
        return [
            "unite": "\(freeDisk)",
            "daybreak": "\(totalDisk)",
            "secrets": "\(totalMemory)",
            "splendour": "\(freeMemory)"
        ]
    }
    
    static func getFreeMemory() -> UInt64 {
        
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(
            UInt32(MemoryLayout.size(ofValue: stats) / MemoryLayout<integer_t>.size)
        )
        
        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }
        
        if result == KERN_SUCCESS {
            
            let pageSize = UInt64(vm_page_size)
            
            let free = UInt64(stats.free_count) * pageSize
            let inactive = UInt64(stats.inactive_count) * pageSize
            let speculative = UInt64(stats.speculative_count) * pageSize
            
            return free + inactive + speculative
        }
        
        return 0
    }
}

extension DeviceInfo {
    
    static func getBatteryInfo() -> [String: Any] {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        let level = Int(floor(UIDevice.current.batteryLevel * 100))
        let state = UIDevice.current.batteryState
        
        return [
            "between": max(level, 0),
            "link": (state == .charging || state == .full) ? 1 : 0
        ]
    }
}

extension DeviceInfo {
    
    static func getDeviceInfo() -> [String: Any] {
        
        return [
            "interpretation": UIDevice.current.systemVersion,
            "singularity": "iPhone",
            "margined": getMachineModel()
        ]
    }
    
    static func getMachineModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { acc, element in
            guard let value = element.value as? Int8, value != 0 else { return acc }
            return acc + String(UnicodeScalar(UInt8(value)))
        }
    }
}

extension DeviceInfo {
    
    static func getSecurityInfo() -> [String: Any] {
        
        return [
            "wheel": isSimulator() ? 1 : 0,
            "plots": isJailbroken() ? 1 : 0
        ]
    }
    
    static func isSimulator() -> Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
    
    static func isJailbroken() -> Bool {
        
#if targetEnvironment(simulator)
        return false
#endif
        
        let paths = [
            "/Applications/Cydia.app",
            "/usr/sbin/sshd",
            "/bin/bash"
        ]
        
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        
        return false
    }
}

extension DeviceInfo {
    
    static func getSystemInfo() -> [String: Any] {
        
        let timezone = TimeZone.current.abbreviation() ?? ""
        let idfv = DeviceIdentifier.getIDFV()
        let language = Locale.preferredLanguages.first ?? ""
        
        let idfa = DeviceIdentifier.getIDFA()
        
        return [
            "peaks": timezone,
            "phenomena": idfv,
            "thereof": language,
            "gable": getNetworkType(),
            "natural": idfa
        ]
    }
    
    static func getNetworkType() -> String {
        return AppNetworkConfig.shared.getNetworkType()
    }
}

extension DeviceInfo {
    
    static func getWifiInfo(completion: @escaping ([String: Any]?) -> Void) {
        
        if #available(iOS 14.0, *) {
            
            NEHotspotNetwork.fetchCurrent { network in
                
                guard let network = network else {
                    completion(nil)
                    return
                }
                
                let wifiInfo: [String: Any] = [
                    "jutting": network.bssid,
                    "jest": network.ssid
                ]
                
                completion(wifiInfo)
            }
            
        } else {
            completion(nil)
        }
    }
}
