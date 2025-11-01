//
//  TrackingViewModel.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 01/11/2025.
//

// TrackingViewModel.swift
import Foundation
import CoreLocation
import Combine
import MapKit
import SwiftData
import SwiftUI

final class TrackingViewModel: ObservableObject {
    
    @Published var currentSession = TrackingSession()
    @Published var liveFormattedDuration: String = "00:00"
    
    private var modelContext: ModelContext?
    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    private var timer: AnyCancellable?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    init() {
        locationManager.requestLocationAuthorization()
        
        locationManager.$currentSpeed
            .assign(to: \.currentSession.currentSpeed, on: self)
            .store(in: &cancellables)
        
        locationManager.$allLocations
            .sink { [weak self] allLocations in
                self?.handleNewLocations(allLocations)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Kontrola Timera
    
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.liveFormattedDuration = self.currentSession.formattedDuration()
            }
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    // MARK: - Przetwarzanie Danych
    
    private func handleNewLocations(_ allLocations: [CLLocation]) {
        guard currentSession.isRunning, let lastLocation = allLocations.last else { return }
        
        var totalDistance: CLLocationDistance = 0.0
        for i in 1..<allLocations.count {
            totalDistance += allLocations[i].distance(from: allLocations[i-1])
        }
        currentSession.totalDistance = totalDistance
        
        currentSession.allCoordinates = allLocations.map { $0.coordinate }
        
        let currentSpeed = max(lastLocation.speed, 0)
        if currentSpeed > currentSession.maxSpeed {
            currentSession.maxSpeed = currentSpeed
        }
    }
    
    // MARK: - Akcje
    
    func toggleTracking() {
        if currentSession.isRunning {
            stopTracking()
        } else {
            startNewSession()
        }
    }
    
    private func startNewSession() {
        currentSession = TrackingSession(isRunning: true, startTime: Date())
        locationManager.startTracking()
        startTimer()
    }
    
    private func stopTracking() {
        currentSession.isRunning = false
        currentSession.endTime = Date()
        locationManager.stopTracking()
        stopTimer()
    }
    
    func finishSession() -> TrackingSession {
        stopTracking()
        let finishedSession = currentSession
        
        // ZAPIS DO SWIFTDATA!
        if let context = modelContext {
            let newRecord = TrackingRecord(session: finishedSession)
            context.insert(newRecord)
            try? context.save()
        }
        
        currentSession = TrackingSession()
        liveFormattedDuration = "00:00"
        return finishedSession
    }
}
