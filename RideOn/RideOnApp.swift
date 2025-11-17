//
//  RideOnApp.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 01/11/2025.
//

import SwiftUI
import SwiftData
import FirebaseCore // 1. Wymagane dla Firebase

// Klasa AppDelegate jest potrzebna do zainicjowania Firebase na starcie
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // 2. Inicjalizacja Firebase
        FirebaseApp.configure()
        return true
    }
}

@main
struct RideOnApp: App {
    
    // 3. Rejestracja App Delegate, aby uruchomić konfigurację Firebase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            // 4. Uruchamiamy RootView, który jest naszym routerem do Logowania/TabView
            RootView()
        }
        // Konfiguracja kontenera SwiftData dla modeli do zapisu
        .modelContainer(for: [TrackingRecord.self, Coordinate.self])
    }
}
