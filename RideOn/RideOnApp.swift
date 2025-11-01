//
//  RideOnApp.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 01/11/2025.
//

import SwiftUI
import SwiftData

@main
struct RideOnApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Konfiguracja kontenera SwiftData dla modeli do zapisu
        .modelContainer(for: [TrackingRecord.self, Coordinate.self])
    }
}
