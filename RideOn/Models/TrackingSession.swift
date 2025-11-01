//
//  TrackingSession.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 01/11/2025.
//

// TrackingSession.swift
import Foundation
import CoreLocation
import MapKit

struct TrackingSession: Identifiable {
    var id = UUID()
    var isRunning: Bool = false
    var startTime: Date?
    var endTime: Date?
    var totalDistance: CLLocationDistance = 0.0
    var currentSpeed: CLLocationSpeed = 0.0
    var maxSpeed: CLLocationSpeed = 0.0
    var allCoordinates: [CLLocationCoordinate2D] = []
    
    // Właściwości obliczane i formatujące czas/dystans...
    var distanceInKilometers: String {
        let kilometers = totalDistance / 1000.0
        return String(format: "%.2f km", kilometers)
    }
    
    var speedInKmH: String {
        let kmh = max(currentSpeed, 0) * 3.6
        return String(format: "%.1f km/h", kmh)
    }
    
    var maxSpeedInKmH: String {
        let kmh = maxSpeed * 3.6
        return String(format: "%.1f km/h", kmh)
    }
    
    // OBLICZANA WŁAŚCIWOŚĆ: Czas trwania w sekundach
    var duration: TimeInterval {
        guard let start = startTime else { return 0 }
        
        // Kluczowa zmiana:
        // 1. Jeśli sesja jest uruchomiona, użyj aktualnego czasu (Date()).
        // 2. Jeśli sesja jest zakończona (isRunning == false), użyj zapisanego endTime
        //    (lub Date() jako fallback, jeśli endTime jest nil, choć nie powinno).
        let end: Date
        if isRunning {
            end = Date()
        } else {
            // Użyj endTime, jeśli dostępne, w przeciwnym razie użyj startTime (dla bezpieczeństwa)
            end = endTime ?? startTime!
        }
        
        return end.timeIntervalSince(start)
    }
    
    func formattedDuration() -> String {
        let duration = self.duration
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
        let minutes = Int(duration / 60) % 60
        let hours = Int(duration / 3600)
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
