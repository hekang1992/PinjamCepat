//
//  CustomLocationManager.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/27.
//

import Foundation
import CoreLocation

typealias LocationCallback = ([String: Any]) -> Void

class CustomLocationManager: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    private var callback: LocationCallback?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startLocation(callback: @escaping LocationCallback) {
        self.callback = callback
        
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            
        case .denied, .restricted:
            safeCallback([:])
            
        @unknown default:
            safeCallback([:])
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            
        case .denied, .restricted:
            safeCallback([:])
            
        case .notDetermined:
            break
            
        @unknown default:
            safeCallback([:])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            safeCallback([:])
            return
        }
        
        manager.stopUpdatingLocation()
        
        let latitude = location.coordinate.latitude
        
        let longitude = location.coordinate.longitude
        
        print("latitude----\(latitude), longitude----\(longitude)")
        
        UserDefaults.standard.setValue(formatCoordinate(latitude), forKey: "app_latitude")
        UserDefaults.standard.setValue(formatCoordinate(longitude), forKey: "app_longitude")
        UserDefaults.standard.synchronize()
        
        reverseGeocode(location: location, lat: latitude, lon: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error==: \(error.localizedDescription)")
        safeCallback([:])
    }
    
    private func reverseGeocode(location: CLLocation, lat: Double, lon: Double) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            guard let place = placemarks?.first else {
                self.safeCallback([:])
                return
            }
            
            let result: [String: Any] = [
                "spear": place.administrativeArea ?? "",
                "blazing": place.isoCountryCode ?? "",
                "source": place.country ?? "",
                "supernatural": place.name ?? "",
                "revelations": formatCoordinate(lat),
                "moon": formatCoordinate(lon),
                "set": place.locality ?? "",
                "regularity": place.subLocality ?? ""
            ]
            
            self.safeCallback(result)
        }
    }
    
    private func safeCallback(_ result: [String: Any]) {
        DispatchQueue.main.async {
            self.callback?(result)
        }
    }
    
    private func formatCoordinate(_ value: Double) -> String {
        let factor = pow(10.0, 6.0)
        let truncated = floor(value * factor) / factor
        return String(format: "%.6f", truncated)
    }
}
