//
//  CustomLocationManager.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/27.
//

import Foundation
import CoreLocation

typealias LocationCallback = ([String: String]) -> Void

class CustomLocationManager: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    private var callback: LocationCallback?
    
    private var hasCallback = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startLocation(callback: @escaping LocationCallback) {
        self.callback = callback
        self.hasCallback = false
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            
        case .denied, .restricted:
            safeCallback([:])
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
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
        
        let latitude = String(location.coordinate.latitude)
        
        let longitude = String(location.coordinate.longitude)
        
        print("latitude----\(latitude), longitude----\(longitude)")
        
        reverseGeocode(location: location, lat: latitude, lon: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error==: \(error.localizedDescription)")
        safeCallback([:])
    }
    
    private func reverseGeocode(location: CLLocation, lat: String, lon: String) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            guard let place = placemarks?.first else {
                self.safeCallback([:])
                return
            }
            
            let result: [String: String] = [
                "spear": place.administrativeArea ?? "",
                "blazing": place.isoCountryCode ?? "",
                "source": place.country ?? "",
                "supernatural": place.name ?? "",
                "revelations": lat,
                "moon": lon,
                "set": place.locality ?? "",
                "regularity": place.subLocality ?? ""
            ]
            
            self.safeCallback(result)
        }
    }
    
    private func safeCallback(_ result: [String: String]) {
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
