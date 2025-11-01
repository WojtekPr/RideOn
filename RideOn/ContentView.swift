//
//  ContentView.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 01/11/2025.
//

// ContentView.swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // 1. Śledzenie
            TrackingView()
                .tabItem {
                    Label("Śledzenie", systemImage: "figure.walk")
                }
            
            // 2. Historia
            HistoryView()
                .tabItem {
                    Label("Historia", systemImage: "list.bullet")
                }
            
            // 3. STATYSTYKI (NOWA ZAKŁADKA)
            StatsView()
                .tabItem {
                    Label("Statystyki", systemImage: "chart.bar.fill")
                }
        }
    }
}
