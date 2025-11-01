//
//  StatsViewModel.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 02/11/2025.
//

// StatsViewModel.swift
import Foundation
import SwiftData
import CoreLocation

// Struktura przechowująca obliczone wyniki statystyczne
struct RideStats {
    let totalDistance: String
    let totalDuration: String
    let overallAverageSpeed: String
    let totalRides: Int
}

final class StatsViewModel: ObservableObject {
    
    @Published var stats: RideStats?
    
    // Kontekst modelu jest automatycznie dostępny w widoku, ale musimy go przekazać
    // lub użyć zapytania @Query w widoku, a obliczenia przenieść tutaj.
    
    // Funkcja obliczająca sumę i średnią na podstawie wszystkich rekordów
    func calculateStatistics(from records: [TrackingRecord]) {
        guard !records.isEmpty else {
            stats = RideStats(totalDistance: "0.00 km", totalDuration: "00:00", overallAverageSpeed: "0.0 km/h", totalRides: 0)
            return
        }
        
        let totalRides = records.count
        
        // Sumowanie dystansu i czasu
        let totalDistance = records.reduce(0.0) { $0 + $1.totalDistance }
        let totalDuration = records.reduce(0.0) { $0 + $1.durationSeconds }
        
        // Obliczanie ogólnej średniej prędkości (całkowity dystans / całkowity czas)
        let overallAverageSpeed = totalDuration > 0 ? totalDistance / totalDuration : 0
        
        // Formatowanie czasu trwania (użyjemy logiki z modelu)
        let formattedTotalDuration = formatTimeInterval(totalDuration)
        
        // Formatowanie wyników
        let formattedTotalDistance = String(format: "%.2f km", totalDistance / 1000.0)
        let formattedAverageSpeed = String(format: "%.1f km/h", overallAverageSpeed * 3.6)
        
        stats = RideStats(
            totalDistance: formattedTotalDistance,
            totalDuration: formattedTotalDuration,
            overallAverageSpeed: formattedAverageSpeed,
            totalRides: totalRides
        )
    }
    
    // Funkcja formatująca czas (skopiowana z modelu dla czystości logiki)
    private func formatTimeInterval(_ duration: TimeInterval) -> String {
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
