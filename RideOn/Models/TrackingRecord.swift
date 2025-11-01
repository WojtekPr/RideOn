//
//  TrackingRecord.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 01/11/2025.
//

// TrackingRecord.swift
import Foundation
import CoreLocation
import SwiftData

@Model
final class TrackingRecord {
    var id: UUID
    var date: Date
    var durationSeconds: TimeInterval
    var totalDistance: CLLocationDistance
    var maxSpeed: CLLocationSpeed
    
    @Relationship(deleteRule: .cascade)
    var allCoordinates: [Coordinate]
    
    init(session: TrackingSession) {
        self.id = session.id
        self.date = session.startTime ?? Date()
        self.durationSeconds = session.duration
        self.totalDistance = session.totalDistance
        self.maxSpeed = session.maxSpeed
        
        self.allCoordinates = session.allCoordinates.map { coord in
            Coordinate(latitude: coord.latitude, longitude: coord.longitude)
        }
    }
    
    // Właściwości pomocnicze dla HistoryView (używa durationSeconds)
    var formattedDuration: String {
        let duration = self.durationSeconds
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
        let minutes = Int(duration / 60) % 60
        let hours = Int(duration / 3600)
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    var distanceInKilometers: String {
        return String(format: "%.2f km", totalDistance / 1000.0)
    }
    
    var maxSpeedInKmH: String {
        return String(format: "%.1f km/h", maxSpeed * 3.6)
    }
    
    // Średnia prędkość dla pojedynczej trasy (m/s)
    var averageSpeed: CLLocationSpeed {
        return durationSeconds > 0 ? totalDistance / durationSeconds : 0
    }
    
    // Średnia prędkość w km/h
    var averageSpeedInKmH: String {
        let kmh = averageSpeed * 3.6
        return String(format: "%.1f km/h", kmh)
    }
}
