//
//  LocationManager.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 01/11/2025.
//

// LocationManager.swift
import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    @Published var allLocations: [CLLocation] = []
    @Published var currentSpeed: CLLocationSpeed = 0.0
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    private var lastFilteredLocation: CLLocation?
    
    private let MIN_DISTANCE_METERS: Double = 3.0
    private let MAX_HORIZONTAL_ACCURACY: Double = 20.0
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.activityType = .automotiveNavigation
    }
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startTracking() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else { return }
        
        self.allLocations = []
        self.currentSpeed = 0.0
        self.lastFilteredLocation = nil
        
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        self.currentSpeed = 0.0
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        let isAccurate = newLocation.horizontalAccuracy <= MAX_HORIZONTAL_ACCURACY
        let isRecent = newLocation.timestamp.timeIntervalSinceNow > -10
        
        if isRecent && isAccurate {
            
            if let last = lastFilteredLocation {
                let distance = newLocation.distance(from: last)
                
                if distance >= MIN_DISTANCE_METERS {
                    self.allLocations.append(newLocation)
                    self.lastFilteredLocation = newLocation
                } else {
                    return
                }
            } else {
                self.allLocations.append(newLocation)
                self.lastFilteredLocation = newLocation
            }
            
            if newLocation.speed >= 0 {
                self.currentSpeed = newLocation.speed
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Błąd lokalizacji: \(error.localizedDescription)")
    }
}
